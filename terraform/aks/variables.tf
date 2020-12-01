variable "rg_name" {
    type        = string
    description = "Name of the Resource Group for all resources to be created"
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