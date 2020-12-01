provider "azurerm" {
    features {
        key_vault {
            purge_soft_delete_on_destroy = true
        }
    }
    version = "~>2.28.0"
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg01" {
    name        = var.rg_name
    location    = var.location
}

resource "azurerm_storage_account" "stor01" {
    name                = lower(replace("${var.rg_name}stor", "/[^0-9A-Za-z]/", ""))
    location            = azurerm_resource_group.rg01.location
    resource_group_name = azurerm_resource_group.rg01.name

    account_tier                = var.storage_tier
    account_replication_type    = var.storage_replication
}

resource "azurerm_storage_container" "container01" {
    name                    = lower(replace("${var.rg_name}", "/[^0-9A-Za-z]/", ""))
    storage_account_name    = azurerm_storage_account.stor01.name
    container_access_type   = var.container_access
}

resource "azurerm_key_vault" "kv01" {
    name                = lower(replace("${var.rg_name}kv", "/[^0-9A-Za-z]/", ""))
    location            = azurerm_resource_group.rg01.location
    resource_group_name = azurerm_resource_group.rg01.name

    sku_name            = var.kv_sku_name

    enabled_for_disk_encryption = var.kv_disk_encrypt
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    soft_delete_enabled         = var.kv_soft_delete
    soft_delete_retention_days  = var.kv_delete_retention_days

    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = data.azurerm_client_config.current.object_id

        key_permissions         = var.kv_key_perms
        secret_permissions      = var.kv_secret_perms
        storage_permissions     = var.kv_storage_perms
        certificate_permissions = var.kv_certificate_permissions
    }
}

# output "client_cert" {
#     value = azurerm_kubernetes_cluster.aks01.kube_config.0.client_certificate
# }

# output "kube_config" {
#     value = azurerm_kubernetes_cluster.aks01.kube_config_raw
# }
