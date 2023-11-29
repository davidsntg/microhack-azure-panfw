resource "azurerm_virtual_network" "virtual_network_hub" {
  name                = var.vnet_hub_name
  address_space       = [var.vnet_hub_address_space]
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "subnet_pan_mgmt" {
  name                 = "pan-mgmt-subnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  address_prefixes     = [cidrsubnet(var.vnet_hub_address_space, 4, 0)]
}

resource "azurerm_subnet" "subnet_pan_untrusted" {
  name                 = "pan-untrusted-subnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  address_prefixes     = [cidrsubnet(var.vnet_hub_address_space, 4, 1)]
}

resource "azurerm_subnet" "subnet_pan_trusted" {
  name                 = "pan-trusted-subnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network_hub.name
  address_prefixes     = [cidrsubnet(var.vnet_hub_address_space, 4, 2)]
}

resource "azurerm_virtual_network" "virtual_network_spoke01" {
  name                = var.vnet_spoke01_name
  address_space       = [var.vnet_spoke01_address_space]
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "subnet_spoke01_default" {
  name                 = "snet-default"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network_spoke01.name
  address_prefixes     = [cidrsubnet(var.vnet_spoke01_address_space, 4, 0)]
}

resource "azurerm_virtual_network_peering" "peering_hub_to_spoke01" {
  name                         = "hub-to-spoke01"
  resource_group_name          = azurerm_resource_group.resource_group.name
  virtual_network_name         = azurerm_virtual_network.virtual_network_hub.name
  remote_virtual_network_id    = azurerm_virtual_network.virtual_network_spoke01.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "peering_spoke01_to_hub" {
  name                         = "spoke01-to-hub"
  resource_group_name          = azurerm_resource_group.resource_group.name
  virtual_network_name         = azurerm_virtual_network.virtual_network_spoke01.name
  remote_virtual_network_id    = azurerm_virtual_network.virtual_network_hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network" "virtual_network_spoke02" {
  name                = var.vnet_spoke02_name
  address_space       = [var.vnet_spoke02_address_space]
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "subnet_spoke02_default" {
  name                 = "snet-default"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network_spoke02.name
  address_prefixes     = [cidrsubnet(var.vnet_spoke02_address_space, 4, 0)]
}

resource "azurerm_virtual_network_peering" "peering_hub_to_spoke02" {
  name                         = "hub-to-spoke02"
  resource_group_name          = azurerm_resource_group.resource_group.name
  virtual_network_name         = azurerm_virtual_network.virtual_network_hub.name
  remote_virtual_network_id    = azurerm_virtual_network.virtual_network_spoke02.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "peering_spoke02_to_hub" {
  name                         = "spoke02-to-hub"
  resource_group_name          = azurerm_resource_group.resource_group.name
  virtual_network_name         = azurerm_virtual_network.virtual_network_spoke02.name
  remote_virtual_network_id    = azurerm_virtual_network.virtual_network_hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_route_table" "route_table_spoke01" {
  name                          = "spoke01-rt"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  disable_bgp_route_propagation = true
}

resource "azurerm_route" "route_spoke01_default" {
  name                   = "spoke01-default-route"
  resource_group_name    = azurerm_resource_group.resource_group.name
  route_table_name       = azurerm_route_table.route_table_spoke01.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_lb.trusted_ilb.private_ip_address
}

resource "azurerm_subnet_route_table_association" "route_table_association_spoke01" {
  subnet_id      = azurerm_subnet.subnet_spoke01_default.id
  route_table_id = azurerm_route_table.route_table_spoke01.id
}


resource "azurerm_route_table" "route_table_spoke02" {
  name                          = "spoke02-rt"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  disable_bgp_route_propagation = true
}

resource "azurerm_route" "route_spoke02_default" {
  name                   = "spoke02-default-route"
  resource_group_name    = azurerm_resource_group.resource_group.name
  route_table_name       = azurerm_route_table.route_table_spoke02.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_lb.trusted_ilb.private_ip_address
}

resource "azurerm_subnet_route_table_association" "route_table_association_spoke02" {
  subnet_id      = azurerm_subnet.subnet_spoke02_default.id
  route_table_id = azurerm_route_table.route_table_spoke02.id
}