

#Create the key vault and secret manually with vmpassword to fetch the password

data "azurerm_key_vault" "prdapp84684d" {
  name                = "prdapp84684d"
  resource_group_name = azurerm_resource_group.example.name
}

data "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  key_vault_id = data.azurerm_key_vault.prdapp84684d.id
}