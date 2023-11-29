resource "azurerm_network_security_group" "fw-mgmt-nsg" {
  name                = "${var.firewall_vm_name}-mgmt-nsg"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

# Allow inbound access to Management subnet.

data "http" "ipinfo" {
  url = "https://ifconfig.me"
}


resource "azurerm_network_security_rule" "network_security_rule_mgmt" {
  name                        = "mgmt-allow-inbound"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.fw-mgmt-nsg.name
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
  network_security_group_id = azurerm_network_security_group.fw-mgmt-nsg.id
}

resource "azurerm_network_security_group" "fw-untrusted-nsg" {
  name                = "${var.firewall_vm_name}-untrusted-nsg"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_network_security_rule" "network_security_rule_untrusted" {
  name                        = "untrusted-allow-inbound"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.fw-untrusted-nsg.name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 1000
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = module.paloalto_vmseries_01.interfaces["${var.firewall_vm_name}-untrusted"].private_ip_address
  destination_port_range      = "*"
}

resource "azurerm_subnet_network_security_group_association" "network_security_group_association_untrusted" {
  subnet_id                 = azurerm_subnet.subnet_pan_untrusted.id
  network_security_group_id = azurerm_network_security_group.fw-untrusted-nsg.id
}

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

resource "local_file" "bootstrap" {

  content = templatefile("${path.module}/files/bootstrap.tpl", {
    interface-trust    = "${cidrhost(azurerm_subnet.subnet_pan_trusted.address_prefixes[0], 4)}/${split("/", azurerm_subnet.subnet_pan_trusted.address_prefixes[0])[1]}"
    interface-untrust  = "${cidrhost(azurerm_subnet.subnet_pan_untrusted.address_prefixes[0], 4)}/${split("/", azurerm_subnet.subnet_pan_untrusted.address_prefixes[0])[1]}"
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

resource "azurerm_public_ip" "fw_mgmt_pip" {
  name                = "${var.firewall_vm_name}-mgmt-pip"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.firewall_vm_name}-mgmt-${random_integer.id.result}"
}

resource "azurerm_public_ip" "fw_untrusted_pip" {
  name                = "${var.firewall_vm_name}-untrusted-pip"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

module "paloalto_vmseries_01" {
  source  = "PaloAltoNetworks/vmseries-modules/azurerm//modules/vmseries"
  version = "1.2.0"

  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  name                = var.firewall_vm_name
  username            = var.username
  password            = coalesce(var.password, random_password.password.result)
  img_version         = var.common_vmseries_version
  img_sku             = var.common_vmseries_sku
  vm_size             = var.common_vmseries_vm_size
  enable_zones        = var.enable_zones
  bootstrap_options = (join(",",
    [
      "storage-account=${module.bootstrap.storage_account.name}",
      "access-key=${module.bootstrap.storage_account.primary_access_key}",
      "file-share=${module.bootstrap.storage_share.name}",
      "share-directory=None"
    ]
  ))
  interfaces = [
    {
      name                     = "${var.firewall_vm_name}-mgmt"
      subnet_id                = azurerm_subnet.subnet_pan_mgmt.id
      public_ip_name           = azurerm_public_ip.fw_mgmt_pip.name
      public_ip_resource_group = azurerm_public_ip.fw_mgmt_pip.resource_group_name
    },
    {
      name      = "${var.firewall_vm_name}-trusted"
      subnet_id = azurerm_subnet.subnet_pan_trusted.id
    },
    {
      name                     = "${var.firewall_vm_name}-untrusted"
      subnet_id                = azurerm_subnet.subnet_pan_untrusted.id
      public_ip_name           = azurerm_public_ip.fw_untrusted_pip.name
      public_ip_resource_group = azurerm_public_ip.fw_untrusted_pip.resource_group_name
    }
  ]
  depends_on = [module.bootstrap]
}
