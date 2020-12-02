provider "azurerm" {
    features {}
    version = "~>2.28.0"
}

# Data calls
data "azurerm_resource_group" "rg01" {
    name        = var.rg_name
}

data "azurerm_key_vault" "kv01" {
    name                = lower(replace("${var.rg_name}kv", "/[^0-9A-Za-z]/", ""))
    resource_group_name = data.azurerm_resource_group.rg01.name
}

data "azurerm_storage_account" "stor01" {
    name                = lower(replace("${var.rg_name}stor", "/[^0-9A-Za-z]/", ""))
    resource_group_name = data.azurerm_resource_group.rg01.name
}

data "azurerm_image" "vault" {
  name                = var.image_name
  resource_group_name = var.image_rg
}

data "http" "mypublicip" {
  url = "http://ipv4.icanhazip.com"
}

# Resources
# Random ids for admin creation
resource "random_id" "admin_username" {
    byte_length = 2
    prefix      = "admin"
}

resource "random_password" "admin_password" {
    length              = 32
    special             = true
    override_special    = "_%@"
}

# Secret output to key vault
resource "azurerm_key_vault_secret" "vm_username" {
    name            = "${var.vm01_name}-user"
    value           = random_id.admin_username.hex
    key_vault_id    = data.azurerm_key_vault.kv01.id
}
resource "azurerm_key_vault_secret" "vm_secret" {
    name            = "${var.vm01_name}-secret"
    value           = random_password.admin_password.result
    key_vault_id    = data.azurerm_key_vault.kv01.id
}

# Network resources creation
resource "azurerm_virtual_network" "vnet01" {
  name                = lower(replace("${var.rg_name}vnet01", "/[^0-9A-Za-z]/", ""))
  address_space       = ["192.168.100.0/28"]
  location            = data.azurerm_resource_group.rg01.location
  resource_group_name = data.azurerm_resource_group.rg01.name
}

resource "azurerm_subnet" "sn01" {
    name                    = "${azurerm_virtual_network.vnet01.name}-internal01"
    resource_group_name     = data.azurerm_resource_group.rg01.name
    virtual_network_name    = azurerm_virtual_network.vnet01.name
    address_prefixes        = azurerm_virtual_network.vnet01.address_space # Subnet uses the full address space for the vnet
}

resource "azurerm_network_security_group" "nsg01" {
    name                    = "nsg01"
    resource_group_name     = data.azurerm_resource_group.rg01.name
    location                = data.azurerm_resource_group.rg01.location

    security_rule {
        name                       = "Inbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "${chomp(data.http.mypublicip.body)}/32"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "vm_nic01" {
    name                = "${var.vm01_name}-nic01"
    location            = data.azurerm_resource_group.rg01.location
    resource_group_name = data.azurerm_resource_group.rg01.name

    ip_configuration    {
        name                            = "internal"
        subnet_id                       = azurerm_subnet.sn01.id
        private_ip_address_allocation   = "Dynamic"
        public_ip_address_id            = azurerm_public_ip.pubIp.id
    }
}

resource "azurerm_public_ip" "pubIp" {
    name                = "${var.vm01_name}-pubIp01"
    location            = data.azurerm_resource_group.rg01.location
    resource_group_name = data.azurerm_resource_group.rg01.name
    allocation_method   = "Dynamic"
}

# Virtual machine creation
resource "azurerm_linux_virtual_machine" "vm01" {
    name                = var.vm01_name
    location            = data.azurerm_resource_group.rg01.location
    resource_group_name = data.azurerm_resource_group.rg01.name
    size                = var.vm_size
    
    # Authentication
    admin_username                  = random_id.admin_username.hex
    admin_password                  = random_password.admin_password.result
    disable_password_authentication = false

    identity {
        type = "SystemAssigned"
    }

    network_interface_ids = [
        azurerm_network_interface.vm_nic01.id,
    ]
    
    os_disk {
        caching                 = "ReadWrite"
        storage_account_type    = "Standard_LRS"
        name                    = "${var.vm01_name}-osdisk"
    }
    
    source_image_id = data.azurerm_image.vault.id
}

# Permissions allocation
resource "azurerm_role_assignment" "StorageBlobDataContributor" {
    scope                   = data.azurerm_storage_account.stor01.id
    role_definition_name    = "Storage Blob Data Contributor"
    principal_id            = azurerm_linux_virtual_machine.vm01.identity[0].principal_id
}