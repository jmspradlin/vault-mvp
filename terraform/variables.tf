variable "rg_name" {
    type        = string
    description = "Name of the Resource Group for all resources to be created"
}

variable "location" {
    type        = string
    default     = "eastus2"
    description = "Azure Region for all resources that will be created. Default is East US 2"
}

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

variable "cluster_name" {
    type = string
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