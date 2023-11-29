resource "azurerm_public_ip" "panfw_untrusted_nat_gateway_pip" {
  name                = "pafw-untrusted-natgw-pip"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "panfw_untrusted_nat_gateway" {
  name                    = "pafw-untrusted-natgw"
  location                = azurerm_resource_group.resource_group.location
  resource_group_name     = azurerm_resource_group.resource_group.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  //zones                   = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "natgw_pip_association" {
  nat_gateway_id       = azurerm_nat_gateway.panfw_untrusted_nat_gateway.id
  public_ip_address_id = azurerm_public_ip.panfw_untrusted_nat_gateway_pip.id
}

resource "azurerm_subnet_nat_gateway_association" "natgw_subnet_untrusted_association" {
  subnet_id      = azurerm_subnet.subnet_pan_untrusted.id
  nat_gateway_id = azurerm_nat_gateway.panfw_untrusted_nat_gateway.id
}