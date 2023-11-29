resource "random_integer" "id" {
  min = 100
  max = 999
}

resource "random_integer" "id2" {
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

# Allow inbound access to Management subnet.

data "http" "ipinfo" {
  url = "https://ifconfig.me"
}

resource "azurerm_public_ip" "fws_untrusted_pip" {
  name                = "${var.firewall_vm_name}-untrusted-pip"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Firewall #1

resource "azurerm_public_ip" "fw01_mgmt_pip" {
  name                = "${var.firewall_vm_name}-01-mgmt-pip"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.firewall_vm_name}-mgmt-01-${random_integer.id.result}"
}

resource "local_file" "bootstrap01" {

  content = templatefile("${path.module}/files/bootstrap.tpl", {
    interface-trust-01       = "${cidrhost(azurerm_subnet.subnet_pan_trusted.address_prefixes[0], 4)}/32"
    interface-trust-02       = "${cidrhost(azurerm_subnet.subnet_pan_trusted.address_prefixes[0], 5)}/32"
    interface-trust-failover = "${cidrhost(azurerm_subnet.subnet_pan_trusted.address_prefixes[0], 6)}/${split("/", azurerm_subnet.subnet_pan_trusted.address_prefixes[0])[1]}"
    interface-untrust-01     = "${cidrhost(azurerm_subnet.subnet_pan_untrusted.address_prefixes[0], 4)}/32"
    interface-untrust-02     = "${cidrhost(azurerm_subnet.subnet_pan_untrusted.address_prefixes[0], 5)}/32"
    next-hop-trusted         = "${cidrhost(azurerm_subnet.subnet_pan_trusted.address_prefixes[0], 1)}"
    next-hop-untrusted       = "${cidrhost(azurerm_subnet.subnet_pan_untrusted.address_prefixes[0], 1)}"
  })
  filename = "${path.module}/files/bootstrap01.xml"

}

module "bootstrap01" {
  source  = "PaloAltoNetworks/vmseries-modules/azurerm//modules/bootstrap"
  version = "1.2.0"

  name                = "paloaltobootstrap${random_integer.id.result}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  storage_share_name  = "sharepaloaltobootstrap${random_integer.id.result}"
  storage_acl         = false

  files = {
    "files/init-cfg.txt"    = "config/init-cfg.txt"
    "files/bootstrap01.xml" = "config/bootstrap.xml"
  }
  files_md5 = {
    "files/init-cfg.txt"    = md5(file("files/init-cfg.txt"))
    "files/bootstrap01.xml" = md5(local_file.bootstrap01.content)
  }

  depends_on = [local_file.bootstrap01]
}

module "paloalto_vmseries_01" {
  source  = "PaloAltoNetworks/vmseries-modules/azurerm//modules/vmseries"
  version = "1.2.0"

  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  name                = "${var.firewall_vm_name}-01"
  username            = var.username
  password            = coalesce(var.password, random_password.password.result)
  img_version         = var.common_vmseries_version
  img_sku             = var.common_vmseries_sku
  vm_size             = var.common_vmseries_vm_size
  enable_zones        = var.enable_zones
  bootstrap_options = (join(",",
    [
      "storage-account=${module.bootstrap01.storage_account.name}",
      "access-key=${module.bootstrap01.storage_account.primary_access_key}",
      "file-share=${module.bootstrap01.storage_share.name}",
      "share-directory=None"
    ]
  ))
  interfaces = [
    {
      name                     = "${var.firewall_vm_name}-01-mgmt"
      subnet_id                = azurerm_subnet.subnet_pan_mgmt.id
      private_ip_address       = cidrhost(azurerm_subnet.subnet_pan_mgmt.address_prefixes[0], 4)
      public_ip_name           = azurerm_public_ip.fw01_mgmt_pip.name
      public_ip_resource_group = azurerm_public_ip.fw01_mgmt_pip.resource_group_name
    },
    {
      name               = "${var.firewall_vm_name}-01-trusted"
      subnet_id          = azurerm_subnet.subnet_pan_trusted.id
      private_ip_address = cidrhost(azurerm_subnet.subnet_pan_trusted.address_prefixes[0], 4)
    },
    {
      name               = "${var.firewall_vm_name}-01-untrusted"
      subnet_id          = azurerm_subnet.subnet_pan_untrusted.id
      private_ip_address = cidrhost(azurerm_subnet.subnet_pan_untrusted.address_prefixes[0], 4)
    },
    {
      name               = "${var.firewall_vm_name}-01-ha"
      subnet_id          = azurerm_subnet.subnet_pan_ha.id
      private_ip_address = cidrhost(azurerm_subnet.subnet_pan_ha.address_prefixes[0], 4)
    }
  ]
  depends_on = [module.bootstrap01]
}

# Firewall #2

resource "azurerm_public_ip" "fw02_mgmt_pip" {
  name                = "${var.firewall_vm_name}-02-mgmt-pip"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.firewall_vm_name}-mgmt-02-${random_integer.id.result}"
}

resource "local_file" "bootstrap02" {

  content = templatefile("${path.module}/files/bootstrap.tpl", {
    interface-trust-01       = "${cidrhost(azurerm_subnet.subnet_pan_trusted.address_prefixes[0], 4)}/32"
    interface-trust-02       = "${cidrhost(azurerm_subnet.subnet_pan_trusted.address_prefixes[0], 5)}/32"
    interface-trust-failover = "${cidrhost(azurerm_subnet.subnet_pan_trusted.address_prefixes[0], 6)}/${split("/", azurerm_subnet.subnet_pan_trusted.address_prefixes[0])[1]}"
    interface-untrust-01     = "${cidrhost(azurerm_subnet.subnet_pan_untrusted.address_prefixes[0], 4)}/32"
    interface-untrust-02     = "${cidrhost(azurerm_subnet.subnet_pan_untrusted.address_prefixes[0], 5)}/32"
    next-hop-trusted         = "${cidrhost(azurerm_subnet.subnet_pan_trusted.address_prefixes[0], 1)}"
    next-hop-untrusted       = "${cidrhost(azurerm_subnet.subnet_pan_untrusted.address_prefixes[0], 1)}"
  })
  filename = "${path.module}/files/bootstrap02.xml"

}

module "bootstrap02" {
  source  = "PaloAltoNetworks/vmseries-modules/azurerm//modules/bootstrap"
  version = "1.2.0"

  name                = "paloaltobootstrap${random_integer.id2.result}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  storage_share_name  = "sharepaloaltobootstrap${random_integer.id2.result}"
  storage_acl         = false

  files = {
    "files/init-cfg.txt"    = "config/init-cfg.txt"
    "files/bootstrap02.xml" = "config/bootstrap.xml"
  }
  files_md5 = {
    "files/init-cfg.txt"    = md5(file("files/init-cfg.txt"))
    "files/bootstrap02.xml" = md5(local_file.bootstrap02.content)
  }

  depends_on = [local_file.bootstrap02]
}

module "paloalto_vmseries_02" {
  source  = "PaloAltoNetworks/vmseries-modules/azurerm//modules/vmseries"
  version = "1.2.0"

  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  name                = "${var.firewall_vm_name}-02"
  username            = var.username
  password            = coalesce(var.password, random_password.password.result)
  img_version         = var.common_vmseries_version
  img_sku             = var.common_vmseries_sku
  vm_size             = var.common_vmseries_vm_size
  enable_zones        = var.enable_zones
  bootstrap_options = (join(",",
    [
      "storage-account=${module.bootstrap02.storage_account.name}",
      "access-key=${module.bootstrap02.storage_account.primary_access_key}",
      "file-share=${module.bootstrap02.storage_share.name}",
      "share-directory=None"
    ]
  ))
  interfaces = [
    {
      name                     = "${var.firewall_vm_name}-02-mgmt"
      subnet_id                = azurerm_subnet.subnet_pan_mgmt.id
      private_ip_address       = cidrhost(azurerm_subnet.subnet_pan_mgmt.address_prefixes[0], 5)
      public_ip_name           = azurerm_public_ip.fw02_mgmt_pip.name
      public_ip_resource_group = azurerm_public_ip.fw02_mgmt_pip.resource_group_name
    },
    {
      name               = "${var.firewall_vm_name}-02-trusted"
      subnet_id          = azurerm_subnet.subnet_pan_trusted.id
      private_ip_address = cidrhost(azurerm_subnet.subnet_pan_trusted.address_prefixes[0], 5)
    },
    {
      name               = "${var.firewall_vm_name}-02-untrusted"
      subnet_id          = azurerm_subnet.subnet_pan_untrusted.id
      private_ip_address = cidrhost(azurerm_subnet.subnet_pan_untrusted.address_prefixes[0], 5)
    },
    {
      name               = "${var.firewall_vm_name}-02-ha"
      subnet_id          = azurerm_subnet.subnet_pan_ha.id
      private_ip_address = cidrhost(azurerm_subnet.subnet_pan_ha.address_prefixes[0], 5)
    }
  ]
  depends_on = [module.bootstrap02]
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
  destination_address_prefix  = module.paloalto_vmseries_01.interfaces["${var.firewall_vm_name}-01-untrusted"].private_ip_address
  destination_port_range      = "*"
}

resource "azurerm_subnet_network_security_group_association" "network_security_group_association_untrusted" {
  subnet_id                 = azurerm_subnet.subnet_pan_untrusted.id
  network_security_group_id = azurerm_network_security_group.fws-untrusted-nsg.id
}