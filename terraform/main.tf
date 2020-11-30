provider "azurerm" {
    features {
        key_vault {
            purge_soft_delete_on_destroy = true
        }
    }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg01" {
    name        = var.rg_name
    location    = var.location
}

resource "azurerm_storage_account" "stor01" {
    name                = join("", lower(replace("${var.cluster_name}", "/^0-9A-Za-z/", "")), "stor")
    location            = azurerm_resource_group.rg01.location
    resource_group_name = azurerm_resource_group.rg01.name

    account_tier                = var.storage_tier
    account_replication_type    = var.storage_replication
}

resource "azurerm_storage_container" "container01" {
    name                    = lower(replace("${var.cluster_name}", "/^0-9A-Za-z/", ""))
    storage_account_name    = azurerm_storage_account.stor01.name
    container_access_type   = var.container_access
}


resource "azurerm_kubernetes_cluster" "aks01" {
    name                = var.cluster_name
    location            = azurerm_resource_group.rg01.location
    resource_group_name = azurerm_resource_group.rg01.name
    dns_prefix          = lower(replace("${var.cluster_name}", "/^0-9A-Za-z/", ""))

    default_node_pool {
        name        = "default"
        node_count  = var.node_pool_count
        vm_size     = var.node_pool_vm_size
    }

    identity {
        type    = "SystemAssigned"
    }
}

resource "azurerm_key_vault" "kv01" {
    name                = join("", lower(replace("${var.cluster_name}", "/^0-9A-Za-z/", "")), "kv")
    location            = azurerm_resource_group.rg01.location
    resource_group_name = azurerm_resource_group.rg01.name

    enabled_for_disk_encryption = true
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    soft_delete_enabled         = true
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false

    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = data.azurerm_client_config.current.object_id

        key_permissions = [
            "create",
            "decrypt",
            "delete",
            "get",
            "list",
            "ManageContacts",
            "update",
        ]

        secret_permissions = [
            "delete",
            "get",
            "list",
            "purge",
            "recover",
            "restore",
            "set",
        ]

        storage_permissions = [
            "delete",
            "get",
            "list",
            "set",
            "update",
        ]
    }
}


output "client_cert" {
    value = azurerm_kubernetes_cluster.aks01.kube_config.0.client_certificate
}

output "kube_config" {
    value = azurerm_kubernetes_cluster.aks01.kube_config_raw
}
