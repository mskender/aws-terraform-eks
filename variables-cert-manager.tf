variable install_certmanager {
    type = bool
    default = false
    description = "Whether to install Cert-Manager on EKS cluster"
}

variable certmanager_clusterissuer_type {
    type = string
    default = "ACME"
    description = "ClusterIssuer type to install (as per cert-manager docs)"
}


