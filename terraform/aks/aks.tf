provider "azurerm" {
    features {}
    version = "~>2.28.0"
}

data "azurerm_resource_group" "rg01" {
    name        = var.rg_name
}

data "azurerm_key_vault" "kv01" {
    name                = lower(replace("${var.cluster_name}kv", "/[^0-9A-Za-z]/", ""))
    resource_group_name = data.azurerm_resource_group.rg01.name
}

resource "azurerm_kubernetes_cluster" "aks01" {
    name                = var.cluster_name
    location            = data.azurerm_resource_group.rg01.location
    resource_group_name = data.azurerm_resource_group.rg01.name
    dns_prefix          = lower(replace("${var.cluster_name}", "/[^0-9A-Za-z]/", ""))

    default_node_pool {
        name        = "default"
        node_count  = var.node_pool_count
        vm_size     = var.node_pool_vm_size
    }

    identity {
        type    = "SystemAssigned"
    }
}

resource "azurerm_key_vault_secret" "aks_client_cert" {
    name            = "${var.cluster_name}-clientcert"
    value           = azurerm_kubernetes_cluster.aks01.kube_config.0.client_certificate
    key_vault_id    = data.azurerm_key_vault.kv01.id
}

resource "azurerm_key_vault_secret" "kube_config" {
    name            = "${var.cluster_name}-kubeconfig"
    value           = azurerm_kubernetes_cluster.aks01.kube_config_raw
    key_vault_id    = data.azurerm_key_vault.kv01.id
}