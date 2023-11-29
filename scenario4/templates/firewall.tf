resource "random_integer" "id" {
  min = 100
  max = 999
}

resource "random_password" "password" {
  length      = 16
  min_lower   = 1
  min_numeric = 1
  min_special = 1
  min_upper   = 1
}

data "http" "ipinfo" {
  url = "https://ifconfig.me"
}

resource "azurerm_public_ip" "fws_untrusted_pip" {
  name                = "${var.firewall_vm_name}-elb-untrusted-pip"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "local_file" "bootstrap" {

  content = templatefile("${path.module}/files/bootstrap.tpl", {
    next-hop-trusted   = "${cidrhost(azurerm_subnet.subnet_pan_trusted.address_prefixes[0], 1)}"
    next-hop-untrusted = "${cidrhost(azurerm_subnet.subnet_pan_untrusted.address_prefixes[0], 1)}"
  })
  filename = "${path.module}/files/bootstrap.xml"

}

module "bootstrap" {
  source  = "PaloAltoNetworks/vmseries-modules/azurerm//modules/bootstrap"
  version = "1.2.0"

  name                = "paloaltobootstrap${random_integer.id.result}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  storage_share_name  = "sharepaloaltobootstrap${random_integer.id.result}"
  storage_acl         = false

  files = {
    "files/init-cfg.txt"  = "config/init-cfg.txt"
    "files/bootstrap.xml" = "config/bootstrap.xml"
  }
  files_md5 = {
    "files/init-cfg.txt"  = md5(file("files/init-cfg.txt"))
    "files/bootstrap.xml" = md5(local_file.bootstrap.content)
  }

  depends_on = [local_file.bootstrap]
}

resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = "panfw-vmss"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  sku                 = "Standard_D3_v2"
  instances           = 1
  //zones               = var.avzones
  zone_balance       = var.zone_balance
  provision_vm_agent = false
  identity {
    type = "SystemAssigned"
  }
  custom_data = base64encode(join(",",
    [
      "storage-account=${module.bootstrap.storage_account.name}",
      "access-key=${module.bootstrap.storage_account.primary_access_key}",
      "file-share=${module.bootstrap.storage_share.name}",
      "share-directory=None"
    ]
  ))

  admin_username                  = var.username
  admin_password                  = coalesce(var.password, random_password.password.result)
  disable_password_authentication = false

  network_interface {
    name    = "mgmt"
    primary = true

    ip_configuration {
      name      = "mgmt"
      primary   = true
      subnet_id = azurerm_subnet.subnet_pan_mgmt.id
      public_ip_address {
        name              = "mgmt-pip"
        domain_name_label = "mgmt-${random_integer.id.result}"
      }
    }
  }

  network_interface {
    name                          = "trusted"
    enable_accelerated_networking = true
    enable_ip_forwarding          = true

    ip_configuration {
      name                                   = "trusted"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet_pan_trusted.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.trusted_ilb_backendpool.id]
    }
  }

  network_interface {
    name                          = "untrusted"
    enable_accelerated_networking = true
    enable_ip_forwarding          = true

    ip_configuration {
      name                                   = "untrusted"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet_pan_untrusted.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.untrusted_elb_backendpool.id]
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.common_vmseries_publisher
    offer     = var.common_vmseries_img_offer
    sku       = var.common_vmseries_sku
    version   = var.common_vmseries_version
  }
  plan {
    name      = var.common_vmseries_sku
    publisher = var.common_vmseries_publisher
    product   = var.common_vmseries_img_offer
  }

  //custom_data = filebase64("cloud-init.txt")  

  computer_name_prefix = "vmss"
  upgrade_mode         = "Manual"

  boot_diagnostics {}

  depends_on = [module.bootstrap]
}

# NSGs

resource "azurerm_network_security_group" "fws-mgmt-nsg" {
  name                = "${var.firewall_vm_name}-mgmt-nsg"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_network_security_rule" "network_security_rule_mgmt" {
  name                        = "mgmt-allow-inbound"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.fws-mgmt-nsg.name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 1000
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefixes     = [coalesce(var.allow_inbound_mgmt_ips, data.http.ipinfo.response_body)]
  destination_address_prefix  = "*"
  destination_port_range      = "443"
}

resource "azurerm_subnet_network_security_group_association" "network_security_group_association_mgmt" {
  subnet_id                 = azurerm_subnet.subnet_pan_mgmt.id
  network_security_group_id = azurerm_network_security_group.fws-mgmt-nsg.id
}

resource "azurerm_network_security_group" "fws-untrusted-nsg" {
  name                = "${var.firewall_vm_name}-untrusted-nsg"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_network_security_rule" "network_security_rule_untrusted" {
  name                        = "untrusted-allow-inbound"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.fws-untrusted-nsg.name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 1000
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
}

resource "azurerm_subnet_network_security_group_association" "network_security_group_association_untrusted" {
  subnet_id                 = azurerm_subnet.subnet_pan_untrusted.id
  network_security_group_id = azurerm_network_security_group.fws-untrusted-nsg.id
}