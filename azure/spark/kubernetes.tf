provider "kubernetes" {
  host = azurerm_kubernetes_cluster.k8s.kube_config[0].host

  client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config[0].client_key)
  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate)

//  load_config_file = false
}


resource "kubernetes_namespace" "spark-operator" {
  metadata {
    name = "spark-operator"
  }
}

resource "kubernetes_namespace" "spark-jobs" {
  metadata {
    name = "spark-jobs"
  }
}

