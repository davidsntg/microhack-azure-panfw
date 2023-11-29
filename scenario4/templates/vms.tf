resource "time_sleep" "wait_5_minutes" {
  depends_on = [azurerm_linux_virtual_machine_scale_set.example]

  create_duration = "300s"
}

resource "azurerm_network_interface" "spoke01-vm01-nic" {
  name                          = "spoke01-vm01ni01"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke01_default.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_linux_virtual_machine" "spoke01-vm01" {
  name                            = "spoke01-vm01"
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  size                            = var.vm_size
  admin_username                  = var.username
  disable_password_authentication = "false"
  admin_password                  = var.password
  network_interface_ids           = [azurerm_network_interface.spoke01-vm01-nic.id]
  custom_data                     = base64encode(local.custom_script_spoke1)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "spoke01-vm01od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  boot_diagnostics {

  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_network_interface" "spoke01-vm02-nic" {
  name                          = "spoke01-vm02ni01"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke01_default.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_linux_virtual_machine" "spoke01-vm02" {
  name                            = "spoke01-vm02"
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  size                            = var.vm_size
  admin_username                  = var.username
  disable_password_authentication = "false"
  admin_password                  = var.password
  network_interface_ids           = [azurerm_network_interface.spoke01-vm02-nic.id]
  custom_data                     = base64encode(local.custom_script_spoke1)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "spoke01-vm02od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  boot_diagnostics {

  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_network_interface" "spoke01-vm03-nic" {
  name                          = "spoke01-vm03ni01"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke01_default.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "spoke01-vm03" {
  name                            = "spoke01-vm03"
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  size                            = var.vm_size
  admin_username                  = var.username
  disable_password_authentication = "false"
  admin_password                  = var.password
  network_interface_ids           = [azurerm_network_interface.spoke01-vm03-nic.id]
  custom_data                     = base64encode(local.custom_script_spoke1)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "spoke01-vm03od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  boot_diagnostics {

  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_network_interface" "spoke01-vm04-nic" {
  name                          = "spoke01-vm04ni01"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke01_default.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_linux_virtual_machine" "spoke01-vm04" {
  name                            = "spoke01-vm04"
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  size                            = var.vm_size
  admin_username                  = var.username
  disable_password_authentication = "false"
  admin_password                  = var.password
  network_interface_ids           = [azurerm_network_interface.spoke01-vm04-nic.id]
  custom_data                     = base64encode(local.custom_script_spoke1)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "spoke01-vm04od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  boot_diagnostics {

  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_network_interface" "spoke01-vm05-nic" {
  name                          = "spoke01-vm05ni01"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke01_default.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_linux_virtual_machine" "spoke01-vm05" {
  name                            = "spoke01-vm05"
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  size                            = var.vm_size
  admin_username                  = var.username
  disable_password_authentication = "false"
  admin_password                  = var.password
  network_interface_ids           = [azurerm_network_interface.spoke01-vm05-nic.id]
  custom_data                     = base64encode(local.custom_script_spoke1)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "spoke01-vm05od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  boot_diagnostics {

  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_network_interface" "spoke02-vm01-nic" {
  name                          = "spoke02-vm01ni01"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke02_default.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_linux_virtual_machine" "spoke02-vm01" {
  name                            = "spoke02-vm01"
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  size                            = var.vm_size
  admin_username                  = var.username
  disable_password_authentication = "false"
  admin_password                  = var.password
  network_interface_ids           = [azurerm_network_interface.spoke02-vm01-nic.id]
  custom_data                     = base64encode(local.custom_script_spoke2)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "spoke02-vm01od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  boot_diagnostics {

  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_network_interface" "spoke02-vm02-nic" {
  name                          = "spoke02-vm02ni01"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke02_default.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_linux_virtual_machine" "spoke02-vm02" {
  name                            = "spoke02-vm02"
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  size                            = var.vm_size
  admin_username                  = var.username
  disable_password_authentication = "false"
  admin_password                  = var.password
  network_interface_ids           = [azurerm_network_interface.spoke02-vm02-nic.id]
  custom_data                     = base64encode(local.custom_script_spoke2)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "spoke02-vm02od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  boot_diagnostics {

  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_network_interface" "spoke02-vm03-nic" {
  name                          = "spoke02-vm03ni01"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke02_default.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_linux_virtual_machine" "spoke02-vm03" {
  name                            = "spoke02-vm03"
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  size                            = var.vm_size
  admin_username                  = var.username
  disable_password_authentication = "false"
  admin_password                  = var.password
  network_interface_ids           = [azurerm_network_interface.spoke02-vm03-nic.id]
  custom_data                     = base64encode(local.custom_script_spoke2)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "spoke02-vm03od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  boot_diagnostics {

  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_network_interface" "spoke02-vm04-nic" {
  name                          = "spoke02-vm04ni01"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke02_default.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_linux_virtual_machine" "spoke02-vm04" {
  name                            = "spoke02-vm04"
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  size                            = var.vm_size
  admin_username                  = var.username
  disable_password_authentication = "false"
  admin_password                  = var.password
  network_interface_ids           = [azurerm_network_interface.spoke02-vm04-nic.id]
  custom_data                     = base64encode(local.custom_script_spoke2)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "spoke02-vm04od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  boot_diagnostics {

  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_network_interface" "spoke02-vm05-nic" {
  name                          = "spoke02-vm05ni01"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke02_default.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [time_sleep.wait_5_minutes]
}

resource "azurerm_linux_virtual_machine" "spoke02-vm05" {
  name                            = "spoke02-vm05"
  location                        = azurerm_resource_group.resource_group.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  size                            = var.vm_size
  admin_username                  = var.username
  disable_password_authentication = "false"
  admin_password                  = var.password
  network_interface_ids           = [azurerm_network_interface.spoke02-vm05-nic.id]
  custom_data                     = base64encode(local.custom_script_spoke2)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "spoke02-vm05od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  boot_diagnostics {

  }
  depends_on = [time_sleep.wait_5_minutes]
}