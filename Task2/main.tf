#provider details for azure 
provider "azurerm" {
  features {}
}

#Creating resource group
resource "azurerm_resource_group" "Macrolife" {
  name     = "${var.prefix}"
  location = var.location
}

#Creating Vitual network for resources
resource "azurerm_virtual_network" "Macrolife" {
  name                = "${var.prefix}-network"
  address_space       = var.vnetcidr
  location            = azurerm_resource_group.Macrolife.location
  resource_group_name = azurerm_resource_group.Macrolife.name
}

#Creating the subnets inside the Vnet
resource "azurerm_subnet" "websubnet" {
  name                 = "${var.prefix}-websubnet"
  resource_group_name  = azurerm_resource_group.Macrolife.name
  virtual_network_name = azurerm_virtual_network.Macrolife.name
  address_prefixes     = var.websubnetcidr
}

resource "azurerm_subnet" "appsubnet" {
  name                 = "${var.prefix}-appsubnet"
  resource_group_name  = azurerm_resource_group.Macrolife.name
  virtual_network_name = azurerm_virtual_network.Macrolife.name
  address_prefixes     = var.appsubnetcidr
}
#Creating a Nsg and setting up security inbound rules
resource "azurerm_network_security_group" "Macrolife" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.Macrolife.location
  resource_group_name = azurerm_resource_group.Macrolife.name

  security_rule {
    name                       = "http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
#Creating the nic & virtual machines in the respective subnets
resource "azurerm_network_interface" "Macrolife" {
  name                = "${var.prefix}-webnic"
  location            = azurerm_resource_group.Macrolife.location
  resource_group_name = azurerm_resource_group.Macrolife.name

  ip_configuration {
    name                          = "webconfiguration1"
    subnet_id                     = azurerm_subnet.websubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "Macrolife" {
  name                  = var.webhostname
  location              = azurerm_resource_group.Macrolife.location
  resource_group_name   = azurerm_resource_group.Macrolife.name
  network_interface_ids = [azurerm_network_interface.Macrolife.id]
  vm_size               = "Standard_DS1_v2"
  admin_username        = var.hostuser
  admin_password        = var.secretpass


  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
}

resource "azurerm_network_interface" "Macrolife" {
  name                = "${var.prefix}-appnic"
  location            = azurerm_resource_group.Macrolife.location
  resource_group_name = azurerm_resource_group.Macrolife.name

  ip_configuration {
    name                          = "appconfiguration1"
    subnet_id                     = azurerm_subnet.appsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "Macrolife" {
  name                  = var.apphostname
  location              = azurerm_resource_group.Macrolife.location
  resource_group_name   = azurerm_resource_group.Macrolife.name
  network_interface_ids = [azurerm_network_interface.Macrolife.id]
  vm_size               = "Standard_DS1_v2"
  admin_username        = var.hostuser
  admin_password        = var.secretpass


  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
}
resource "azurerm_storage_account" "Macrolife" {
  name                     = "${var.prefix}-storage"
  resource_group_name      = azurerm_resource_group.Macrolife.name
  location                 = azurerm_resource_group.Macrolife.location
  account_tier             = "Standard"
  account_replication_type = var.replication
}

#Not part of the script this the answer for the last requirement for setting up secret
#Tenant and obeject id are to mentioned
resource "azurerm_key_vault" "Macrolife" {
  name                       = "Macrolifekeyvault"
  location                   = azurerm_resource_group.Macrolife.location
  resource_group_name        = azurerm_resource_group.Macrolife.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
      "purge",
      "recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "Macrolifehost" {
  name         = var.hostuser
  value        = var.secretpass
  key_vault_id = azurerm_key_vault.Macrolife.id
}
