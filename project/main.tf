terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# resource group
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  count               = var.vn_count
  name                = "myVnet-${count.index + 1}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  count                = var.subnet_count
  name                 = "mySubnet-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network[count.index].name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  count               = var.instance_count == 2 ? 1 : 0
  name                = "myPublicIP-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  count               = var.instance_count == 2 ? 1 : 0
  name                = "myNIC-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet[count.index].id
    #subnet_id                     = "${element(azurerm_subnet.my_terraform_subnet.id, count.index)}"
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  count                 = var.instance_count
  name                  = "myVM-${count.index + 1}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = azurerm_network_interface.my_terraform_nic[count.index].id
  #network_interface_ids = "${element(azurerm_network_interface.my_terraform_nic.id, count.index)}"
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password                  = "password@768954"
  disable_password_authentication = false

}

# Create database server
resource "azurerm_mssql_server" "server" {
  count                        = var.databaseserver_count == 1 ? 1 : 0
  name                         = "sampledbserver657-${count.index + 1}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  version                      = "12.0"
}

# Create database
resource "azurerm_mssql_database" "db" {
  count     = var.databaseserver_count == 1 ? 1 : 0
  name      = "sampledb657-${count.index + 1}"
  server_id = azurerm_mssql_server.server[count.index].id
}