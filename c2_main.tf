# resource "azurerm_resource_group" "newrg" {
#   name     = "newRG"
#   location = "east asia"
# }
# #vnet creation
# resource "azurerm_virtual_network" "myvnet" {
#   name                = "myvnet-1"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.newrg.location
#   resource_group_name = azurerm_resource_group.newrg.name
# }
# #subnet creation
# resource "azurerm_subnet" "mysubnet" {
#   name                 = "mysubnet-1"
#   address_prefixes     = ["10.0.1.0/24"]
#   resource_group_name  = azurerm_resource_group.newrg.name
#   virtual_network_name = azurerm_virtual_network.myvnet.name
# }
# resource "azurerm_public_ip" "mypubip" {
#   count=2
#   depends_on = [
#     azurerm_virtual_network.myvnet,
#     azurerm_subnet.mysubnet
#   ]
#   name                = "my-pubip-${count.index}"
#   allocation_method   = "Static"
#   location            = azurerm_resource_group.newrg.location
#   resource_group_name = azurerm_resource_group.newrg.name
# }
# resource "azurerm_network_interface" "mynic" {
#   count=2
#   name                = "mynic-${count.index}"
#   location            = azurerm_resource_group.newrg.location
#   resource_group_name = azurerm_resource_group.newrg.name

#   ip_configuration {
#     name                          = "ipconfig-vnet1"
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = azurerm_subnet.mysubnet.id
#     public_ip_address_id          = element(azurerm_public_ip.mypubip[*].id, count.index)
#   }
# }
# resource "azurerm_network_security_group" "nsg1" {
#   name                = "acceptanceTestSecurityGroup1"
#   location            = azurerm_resource_group.newrg.location
#   resource_group_name = azurerm_resource_group.newrg.name
#   security_rule {
#     name                       = "test123"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }
# resource "azurerm_network_interface_security_group_association" "nic-nsg-association" {
#   count = 2
#   network_interface_id      = element(azurerm_network_interface.mynic[*].id, count.index)
#   network_security_group_id = azurerm_network_security_group.nsg1.id
# }
resource "azurerm_resource_group" "newrg" {
  name     = "newRG"
  location = "east asia"
}
#vnet creation
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.newrg.location
  resource_group_name = azurerm_resource_group.newrg.name
}
#subnet creation
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = azurerm_resource_group.newrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
}
resource "azurerm_public_ip" "mypubip" {
  depends_on = [
    azurerm_virtual_network.myvnet,
    azurerm_subnet.mysubnet
  ]
  name                = "my-pubip"
  allocation_method   = "Static"
  location            = azurerm_resource_group.newrg.location
  resource_group_name = azurerm_resource_group.newrg.name
}
resource "azurerm_network_interface" "mynic" {

  name                = "mynic"
  location            = azurerm_resource_group.newrg.location
  resource_group_name = azurerm_resource_group.newrg.name

  ip_configuration {
    name                          = "ipconfig-vnet1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.mysubnet.id
    public_ip_address_id          = azurerm_public_ip.mypubip.id
  }
}
resource "azurerm_network_security_group" "nsg1" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.newrg.location
  resource_group_name = azurerm_resource_group.newrg.name
  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_interface_security_group_association" "nic-nsg-association" {

  network_interface_id      = azurerm_network_interface.mynic.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}