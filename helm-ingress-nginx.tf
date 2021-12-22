
resource "helm_release" "ingress_nginx" {

name = "ingress-nginx"
repository = "https://kubernetes.github.io/ingress-nginx"
chart = "ingress-nginx"
#version = "default" #param plx

set {
    name = "controller.extraArgs.enable-ssl-passthrough"
    value = "true"
}

set {
    name = "ingressClassResource"
    value = "nginx" #TODO: customize!
}

#add Prometheus metriks.
depends_on = [

    aws_eks_cluster.main,
    aws_eks_node_group.workers,
    resource.local_file.kubeconfig
]
}