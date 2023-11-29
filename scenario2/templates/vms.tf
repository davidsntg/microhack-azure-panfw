
resource "azurerm_network_interface" "spoke01-vm-nic" {
  name                = "spoke01-vmni01"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke01_default.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "spoke01-vm" {
  name                            = "spoke01-vm"
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  size                            = var.vm_size
  admin_username                  = var.username
  disable_password_authentication = "false"
  admin_password                  = var.password
  network_interface_ids           = [azurerm_network_interface.spoke01-vm-nic.id]
  custom_data                     = base64encode(local.custom_script_spoke01)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "spoke01-vmod01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  boot_diagnostics {

  }
}

resource "azurerm_network_interface" "spoke02-vm-nic" {
  name                = "spoke02-vmni01"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke02_default.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "spoke02-vm" {
  name                            = "spoke02-vm"
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  size                            = var.vm_size
  admin_username                  = var.username
  disable_password_authentication = "false"
  admin_password                  = var.password
  network_interface_ids           = [azurerm_network_interface.spoke02-vm-nic.id]
  custom_data                     = base64encode(local.custom_script_spoke02)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "spoke02-vmod01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  boot_diagnostics {

  }
}