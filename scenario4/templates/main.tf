data "azurerm_marketplace_agreement" "paloaltonetworks" {
  publisher = "paloaltonetworks"
  offer     = "vmseries-flex"
  plan      = "byol"
}

resource "azurerm_marketplace_agreement" "paloaltonetworks" {
  count     = data.azurerm_marketplace_agreement.paloaltonetworks.id == null ? 1 : 0
  publisher = "paloaltonetworks"
  offer     = "vmseries-flex"
  plan      = "byol"
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}