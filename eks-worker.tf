locals {

    eks_node_group_name = var.node_group_name == null ? "${var.prefix}-eks-node${local.suffix}" : var.node_group_name
}

module "node_group" {
  
  count = (var.create_node_group && var.create_cluster) ? 1:0
  create_node_group = var.create_node_group
  source = "github.com/mskender/aws-terraform-eks-node-group.git?ref=v0.1.2"
  
  cluster_name = aws_eks_cluster.main[0].name
  node_group_name = local.eks_node_group_name

  subnet_ids      = var.eks_subnet_ids
  node_scaling = var.eks_worker_scaling
  instance_types = var.worker_instance_types

}
