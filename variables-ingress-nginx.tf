variable install_ingress_nginx {
    type = bool
    default = false
    description = "Whether to install Nginx Ingress on EKS cluster. Helm release from https://github.com/kubernetes/ingress-nginx"
}
