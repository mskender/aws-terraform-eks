locals {


    suffix = var.suffix == "" ? "" : "-${var.suffix}"
    eks_cluster_name = var.cluster_name == null ? "${var.prefix}-eks${local.suffix}" : var.cluster_name
}

resource aws_eks_cluster "main" {

    count = var.create_cluster ? 1:0
    name = local.eks_cluster_name
    role_arn = aws_iam_role.eks-control[0].arn
    version = var.eks_version

    dynamic "encryption_config" {
    for_each = toset(var.encryption_config)

    content {
        provider {
            key_arn = encryption_config.value["key_arn"]
        }
        resources = ["secrets"]
        }
    }

    vpc_config {

        security_group_ids      = var.eks_security_group_ids
        subnet_ids              = var.eks_subnet_ids
        endpoint_private_access = var.eks_private_api_access
        endpoint_public_access  = var.eks_public_api_access
        public_access_cidrs     = var.eks_public_api_access_cidrs
    }

    kubernetes_network_config {
      service_ipv4_cidr = var.eks_service_cidr
    }

}