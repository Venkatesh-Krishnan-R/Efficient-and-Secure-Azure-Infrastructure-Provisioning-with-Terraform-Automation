resource "azurerm_managed_disk" "example" {
  name                 = "Disk1"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "16"
  depends_on = [
    azurerm_resource_group.example,
    azurerm_windows_virtual_machine.example
  ]
}
resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.example.id
  virtual_machine_id = azurerm_windows_virtual_machine.example.id
  lun                = "0"
  caching            = "ReadWrite"
  depends_on = [
    azurerm_resource_group.example,
    azurerm_windows_virtual_machine.example
  ]
}