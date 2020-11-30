# vault-mvp

## Backend.tf file
To configure a remote backend, add a file to the /terraform directory titled 'backend.tf' with the following content:
```
# Backend: Remote TF State
terraform {
  backend "azurerm" {
    resource_group_name  = "state-rg01"
    storage_account_name = "STORAGE-ACCOUNT-NAME"
    container_name       = "tfstate"
    key                  = "nonprod.terraform.tfstate"
  }
```
replacing "`STORAGE-ACCOUNT-NAME`" with the storage account created from the terraform state directory.
IMPORTANT: DO NOT COMMIT THIS FILE