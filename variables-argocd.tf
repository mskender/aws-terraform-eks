variable install_argocd {
    type = bool
    default = false
    description = "Whether to install ArgoCD CI/CD solution for K8S"
}

variable argocd_fqdn {
    type=string
    default = "argocd.example.com"
    description = "ArgoCD FQDN to set on Ingress"
}

variable argocd_version {
    type = string
    default = ""
    description = "Version of ArgoCD to install"
}
