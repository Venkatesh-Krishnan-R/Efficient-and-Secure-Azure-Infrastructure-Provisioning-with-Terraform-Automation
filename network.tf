locals {
  subnet =[
    {
      name = "subnetA"
      address_prefixes = ["10.0.0.0/24"]
    },
    {
      name = "subnetB"
      address_prefixes = ["10.0.1.0/24"]
    }
  ]
}

resource "azurerm_virtual_network" "example" {
  name                = "app-network"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]

  depends_on = [
    azurerm_resource_group.example
  ]
}

resource "azurerm_subnet" "subnetA" {
  name                 = local.subnet[0].name
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = local.subnet[0].address_prefixes
  
  depends_on = [
    azurerm_virtual_network.example
  ]
}
resource "azurerm_subnet" "subnetB" {
  name                 = local.subnet[1].name
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = local.subnet[1].address_prefixes
  depends_on = [
    azurerm_virtual_network.example
  ]
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example.id
  }
  depends_on = [
    azurerm_virtual_network.example,
    azurerm_public_ip.example,
    azurerm_subnet.subnetA
  ]
}

resource "azurerm_network_interface" "example1" {
  name                = "example-nic1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetB.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example1.id
  }
  depends_on = [
    azurerm_virtual_network.example,
    azurerm_public_ip.example1,
    azurerm_subnet.subnetB

  ]
}

resource "azurerm_public_ip" "example" {
  name                    = "PublicIP"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  allocation_method       = "Static"
  depends_on = [
    azurerm_resource_group.example
  ]
}

resource "azurerm_public_ip" "example1" {
  name                    = "PublicIP1"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  allocation_method       = "Static"
  depends_on = [
    azurerm_resource_group.example
  ]
}

resource "azurerm_network_security_group" "example" {
  name                = "NSG1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "test123"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [
    azurerm_resource_group.example
  ]
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.subnetA.id
  network_security_group_id = azurerm_network_security_group.example.id

  depends_on = [
    azurerm_network_security_group.example,
    azurerm_subnet.subnetA
  ]
}

