variable "rg_name" {
    type        = string
    description = "Name of the Resource Group for all resources to be created"
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

variable "source_image_id" {
    type = string
    description = "Azure resource ID for the source image. Pattern should be '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/********/providers/Microsoft.....'"
}