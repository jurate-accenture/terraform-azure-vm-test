
resource "azurerm_resource_group" "Terraform_Azure" {
  name     = "TerraformJZ"
  location = "westus2"
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "myTFVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "westus2"
  resource_group_name = azurerm_resource_group.Terraform_Azure.name
}



resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.Terraform_Azure.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "network_interface" {
  name                = "myNIC"
  location            = azurerm_resource_group.Terraform_Azure.location
  resource_group_name = azurerm_resource_group.Terraform_Azure.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "myVM"
  location              = azurerm_resource_group.Terraform_Azure.location
  resource_group_name   = azurerm_resource_group.Terraform_Azure.name
  network_interface_ids = [azurerm_network_interface.network_interface.id]

  size       = "Standard_D2s_v3"
  admin_username = "jurate"
 

   
  disable_password_authentication = false
  admin_username                   = "jurate177"  # Replace with your username
  admin_password                   = "myvm177"  # Replace with your desired password
 
    

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}