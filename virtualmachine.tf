resource "azurerm_windows_virtual_machine" "example" {
  name                = "Test-Machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  admin_password      = data.azurerm_key_vault.prdapp84684d.id
  network_interface_ids = [
    azurerm_network_interface.example,
    azurerm_network_interface.example1
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.example
  ]
}


