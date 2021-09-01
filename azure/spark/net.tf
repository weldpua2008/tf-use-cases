# Create a virtual network within the resource group
//resource "azurerm_virtual_network" "vnet1" {
//  name                = "terraform-azurerm-virtual-network-1"
//  address_space       = ["10.0.0.0/16"]
//  location            = azurerm_resource_group.rg.location
//  resource_group_name = azurerm_resource_group.rg.name
//
//  subnet {
//    name           = "private1"
//    address_prefix = "10.0.1.0/24"
//    security_group = azurerm_network_security_group.private_sg.id
//  }
//  tags                     = var.tags
//}

//resource "azurerm_network_security_group" "private_sg" {
//  name                = "private_sg"
//  location            = azurerm_resource_group.rg.location
//  resource_group_name = azurerm_resource_group.rg.name
//  tags                     = var.tags
//  security_rule {
//    name                       = "allowIm"
//    priority                   = 100
//    direction                  = "Inbound"
//    access                     = "Allow"
//    protocol                   = "Tcp"
//    source_port_range          = "*"
//    destination_port_range     = "*"
//    source_address_prefix      = "*"
//    destination_address_prefix = "*"
//  }
//}
//
//# Create subnets within the virtual network
//resource "azurerm_subnet" "private1" {
//  name                 = "private1"
//  resource_group_name = azurerm_resource_group.rg.name
//  virtual_network_name = azurerm_virtual_network.vnet1.name
//  address_prefixes     = ["10.0.1.0/24"]
//}
