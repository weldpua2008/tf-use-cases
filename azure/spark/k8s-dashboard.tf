//  apiVersion: v1
//  kind: Namespace
//  metadata:
//    name: kubernetes-dashboard
resource "kubernetes_namespace" "kubernetes-dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }
}

//  apiVersion: v1
//  kind: ServiceAccount
//  metadata:
//    labels:
//      k8s-app: kubernetes-dashboard
//    name: kubernetes-dashboard
//    namespace: kubernetes-dashboard
resource "kubernetes_service_account" "kubernetes-dashboard" {
  automount_service_account_token =  true
  metadata {
    name = "kubernetes-dashboard"
    namespace = kubernetes_namespace.kubernetes-dashboard.id
    labels = {
      k8s-app = "kubernetes-dashboard"
    }
  }
}

//  kind: Service
//  apiVersion: v1
//  metadata:
//    labels:
//      k8s-app: kubernetes-dashboard
//    name: kubernetes-dashboard
//    namespace: kubernetes-dashboard
//  spec:
//    ports:
//      - port: 443
//        targetPort: 8443
//    selector:
//      k8s-app: kubernetes-dashboard
resource "kubernetes_service" "kubernetes-dashboard" {
  metadata {
    name = "kubernetes-dashboard"
    namespace = kubernetes_namespace.kubernetes-dashboard.id
    labels = {
      k8s-app = "kubernetes-dashboard"
    }
  }
  spec {
    selector = {
      k8s-app = "kubernetes-dashboard"
    }
//    session_affinity = "ClientIP"
    port {
      port        = 443
      target_port = 8443
    }
//    type = "LoadBalancer"
  }
}

//  apiVersion: v1
//  kind: Secret
//  metadata:
//    labels:
//      k8s-app: kubernetes-dashboard
//    name: kubernetes-dashboard-certs
//    namespace: kubernetes-dashboard
//  type: Opaque
resource "kubernetes_secret" "kubernetes-dashboard-certs" {
  metadata {
    name = "kubernetes-dashboard-certs"
    namespace = kubernetes_namespace.kubernetes-dashboard.id
    labels = {
      k8s-app = "kubernetes-dashboard"
    }
  }
  type = "Opaque"
}

//  apiVersion: v1
//  kind: Secret
//  metadata:
//    labels:
//      k8s-app: kubernetes-dashboard
//    name: kubernetes-dashboard-csrf
//    namespace: kubernetes-dashboard
//  type: Opaque
//  data:
//    csrf: ""
resource "kubernetes_secret" "kubernetes-dashboard-csrf" {
  metadata {
    name = "kubernetes-dashboard-csrf"
    namespace = kubernetes_namespace.kubernetes-dashboard.id
    labels = {
      k8s-app = "kubernetes-dashboard"
    }

  }
  data = {
      csrf = ""
    }
  type = "Opaque"
}

//  apiVersion: v1
//  kind: Secret
//  metadata:
//    labels:
//      k8s-app: kubernetes-dashboard
//    name: kubernetes-dashboard-key-holder
//    namespace: kubernetes-dashboard
//  type: Opaque

resource "kubernetes_secret" "kubernetes-dashboard-key-holder" {
  metadata {
    name = "kubernetes-dashboard-key-holder"
    namespace = kubernetes_namespace.kubernetes-dashboard.id
    labels = {
      k8s-app = "kubernetes-dashboard"
    }
  }
  type = "Opaque"
}

//  kind: ConfigMap
//  apiVersion: v1
//  metadata:
//    labels:
//      k8s-app: kubernetes-dashboard
//    name: kubernetes-dashboard-settings
//    namespace: kubernetes-dashboard
resource "kubernetes_config_map" "kubernetes-dashboard-settings" {
  metadata {
    name = "kubernetes-dashboard-settings"
    namespace = kubernetes_namespace.kubernetes-dashboard.id
    labels = {
      k8s-app = "kubernetes-dashboard"
    }
  }
}


//  kind: Role
//  apiVersion: rbac.authorization.k8s.io/v1
//  metadata:
//    labels:
//      k8s-app: kubernetes-dashboard
//    name: kubernetes-dashboard
//    namespace: kubernetes-dashboard
//  rules:
//    # Allow Dashboard to get, update and delete Dashboard exclusive secrets.
//    - apiGroups: [""]
//      resources: ["secrets"]
//      resourceNames: ["kubernetes-dashboard-key-holder", "kubernetes-dashboard-certs", "kubernetes-dashboard-csrf"]
//      verbs: ["get", "update", "delete"]
//      # Allow Dashboard to get and update 'kubernetes-dashboard-settings' config map.
//    - apiGroups: [""]
//      resources: ["configmaps"]
//      resourceNames: ["kubernetes-dashboard-settings"]
//      verbs: ["get", "update"]
//      # Allow Dashboard to get metrics.
//    - apiGroups: [""]
//      resources: ["services"]
//      resourceNames: ["heapster", "dashboard-metrics-scraper"]
//      verbs: ["proxy"]
//    - apiGroups: [""]
//      resources: ["services/proxy"]
//      resourceNames: ["heapster", "http:heapster:", "https:heapster:", "dashboard-metrics-scraper", "http:dashboard-metrics-scraper"]
//      verbs: ["get"]
resource "kubernetes_role" "kubernetes-dashboard" {
  metadata  {
    labels = {
      "k8s-app" = "kubernetes-dashboard"
    }
    name = "kubernetes-dashboard"
    namespace = "kubernetes-dashboard"
  }

  rule {
    api_groups     = [""]
    resources      = ["secrets"]
    resource_names = ["kubernetes-dashboard-key-holder", "kubernetes-dashboard-certs", "kubernetes-dashboard-csrf"]
    verbs          = ["get", "update", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    resource_names = ["kubernetes-dashboard-settings"]
    verbs      = ["get", "update"]
  }
  rule {
    api_groups = [""]
    resources  = ["services"]
    resource_names = ["heapster", "dashboard-metrics-scraper"]
    verbs      = ["proxy"]
  }
  rule {
    api_groups = [""]
    resources  = ["services/proxy"]
    resource_names =  ["heapster", "http:heapster:", "https:heapster:", "dashboard-metrics-scraper", "http:dashboard-metrics-scraper"]
    verbs      = ["get"]
  }
}


//  kind: ClusterRole
//  apiVersion: rbac.authorization.k8s.io/v1
//  metadata:
//    labels:
//      k8s-app: kubernetes-dashboard
//    name: kubernetes-dashboard
//  rules:
//    # Allow Metrics Scraper to get metrics from the Metrics server
//    - apiGroups: ["metrics.k8s.io"]
//      resources: ["pods", "nodes"]
//      verbs: ["get", "list", "watch"]
resource "kubernetes_cluster_role" "kubernetes-dashboard" {
  metadata  {
    labels = {
      "k8s-app" = "kubernetes-dashboard"
    }
    name = "kubernetes-dashboard"
  }

  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}


//  apiVersion: rbac.authorization.k8s.io/v1
//  kind: RoleBinding
//  metadata:
//    labels:
//      k8s-app: kubernetes-dashboard
//    name: kubernetes-dashboard
//    namespace: kubernetes-dashboard
//  roleRef:
//    apiGroup: rbac.authorization.k8s.io
//    kind: Role
//    name: kubernetes-dashboard
//  subjects:
//    - kind: ServiceAccount
//      name: kubernetes-dashboard
//      namespace: kubernetes-dashboard

resource "kubernetes_cluster_role_binding" "kubernetes-dashboard" {

  metadata  {
    labels = {
      "k8s-app" = "kubernetes-dashboard"
    }
    name = "kubernetes-dashboard"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "kubernetes-dashboard"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "kubernetes-dashboard"
    namespace = "kubernetes-dashboard"
  }
}
