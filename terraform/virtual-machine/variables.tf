variable "rg_name" {
    type        = string
    description = "Name of the Resource Group for all resources to be created"
}

variable "image_name" {
    type = string
    description = "Name of the Vault image to be used"
}

variable "image_rg" {
    type = string
    description = "Resource Group of the Vault image to be used"
}

variable "vm01_name" {
    type = string
    description = "Name of the virtual machine to be created"
}

variable "vm_size" {
    type = string
    default     = "Standard_D2s_v3"
    description = "Azure SKU size of the virtual machine to be created"
}