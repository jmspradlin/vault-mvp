variable "rg_name" {
    type        = string
    description = "Name of the Resource Group for all resources to be created"
}

variable "location" {
    type        = string
    default     = "eastus2"
    description = "Azure Region for all resources that will be created. Default is East US 2"
}

# Storage Account variables
variable "storage_tier" {
    type        = string
    default     = "Standard"
    description = "Storage Account Tier for Vault Backend. Default is Standard"
}

variable "storage_replication" {
    type        = string
    default     = "LRS"
    description = "Replication level of the storage account. Default is Locally Redundant (LRS)"
}

variable "container_access" {
    type        = string
    default     = "private"
    description = "The access level configured for this container. Can be 'blob', 'container', or 'private'. Default is private"
}

# AKS variables
variable "cluster_name" {
    type        = string
    description = "Name of the AKS clusted to be created."
}

variable "node_pool_count" {
    type        = number
    default     = 2
    description = "Count of the nodes to be created"
}

variable "node_pool_vm_size" {
    type        = string
    default     = "Standard_D2s_v3"
    description = "VM size of each node to be created"
}

# Key Vault variables
variable "kv_sku_name" {
    type        = string
    default     = "standard"
    description = "Key Vault sku level. Default is standard"
}

variable "kv_disk_encrypt" {
    type        = bool
    default     = true
    description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys"
}

variable "kv_soft_delete" {
    type        = bool
    default     = true
    description = " Should Soft Delete be enabled for this Key Vault?"
}

variable "kv_delete_retention_days" {
    type        = number
    default     = 7
    description = "(optional) describe your variable"
}

variable "kv_key_perms" {
    type        = list(string)
    default     = [
        "create",
        "decrypt",
        "delete",
        "get",
        "list",
        "update",
    ]
    description = "Permissions for the Key Vault Keys"
}

variable "kv_secret_perms" {
    type        = list(string)
    default     = [
        "delete",
        "get",
        "list",
        "purge",
        "recover",
        "restore",
        "set",
    ]
    description = "Permissions for the Key Vault Secrets"
}

variable "kv_storage_perms" {
    type        = list(string)
    default     = [
        "delete",
        "get",
        "list",
        "set",
        "update",
    ]
    description = "Permissions for the Key Vault Storage"
}

variable "kv_certificate_permissions" {
    type        = list(string)
    default     = [
        "create",
        "delete",
        "get",
        "import",
        "list",
        "purge",
        "recover",
        "restore",
        "update",
    ]
    description = "Permissions for the Key Vault Storage"
}