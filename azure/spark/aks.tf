resource "azurerm_resource_group" "k8s" {
    name     = "k8s"
    location = var.location
    tags                     = local.tags_k8s
}

resource "azurerm_log_analytics_workspace" "k8s" {
    # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
    name                = "loganalytics-k8s-23082021"
    location            = var.location
    resource_group_name = azurerm_resource_group.k8s.name
    # The Free SKU has a default daily_quota_gb value of 0.5 (GB).
    sku                 = "Free"
    # 7 (Free Tier only)
    retention_in_days   = 7
    tags                     = local.tags_k8s
}

resource "azurerm_log_analytics_solution" "k8s" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.k8s.location
    resource_group_name   = azurerm_resource_group.k8s.name
    workspace_resource_id = azurerm_log_analytics_workspace.k8s.id
    workspace_name        = azurerm_log_analytics_workspace.k8s.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
    tags                     = local.tags_k8s
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = "k8s-base"
    location            = azurerm_resource_group.k8s.location
    resource_group_name = azurerm_resource_group.k8s.name
    dns_prefix          = "spark-k8s"

    linux_profile {
        admin_username = "ubuntu"
        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = 1
        vm_size         = "Standard_D2_v2"
        os_disk_size_gb = 30
        # Required for advanced networking
//        vnet_subnet_id = azurerm_subnet.private1.id
    }
    # Advanced networking
    network_profile {
//      network_plugin     = "azure"
//      docker_bridge_cidr = "172.17.0.1/16"
//      dns_service_ip     = "10.2.0.10"
//      service_cidr       = "10.2.0.0/24"
      load_balancer_sku = "Standard"
      network_plugin = "kubenet"
    }

   identity {
      type = "SystemAssigned"
    }

    addon_profile {
      http_application_routing {
              enabled                            = false
//              http_application_routing_zone_name = "ad6ac5a7c5cd4b569494.eastus2.aksapp.io"
      }

      oms_agent {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.k8s.id
      }
//      Kubernetes Dashboard addon is deprecated for Kubernetes version >= 1.19.0
//      kube_dashboard  {
//        enabled = true
//      }
    }

    tags                     = local.tags_k8s

}

resource "null_resource" "save-kube-config" {
  triggers = {
    config = azurerm_kubernetes_cluster.k8s.kube_config_raw
  }

  provisioner "local-exec" {
    command = <<EOF
      mkdir -p ${path.module}/.kube
      echo "${azurerm_kubernetes_cluster.k8s.kube_config_raw}" > ${path.module}/.kube/config_zure_k8s
      chmod 0600 ${path.module}/.kube/config_zure_k8s
EOF
  }
}

