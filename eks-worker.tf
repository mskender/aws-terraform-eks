locals {

    eks_node_group_name = var.node_group_name == null ? "${var.prefix}-eks-node${local.suffix}" : var.node_group_name
}

# resource "aws_eks_node_group" "workers" {

#   cluster_name    = aws_eks_cluster.main.name
#   node_group_name = local.eks_node_group_name
#   node_role_arn   = aws_iam_role.eks-worker.arn
#   subnet_ids      = var.eks_subnet_ids

#   scaling_config { 
#       min_size = var.eks_worker_scaling["min_size"]
#       max_size = var.eks_worker_scaling["max_size"]
#       desired_size =  var.eks_worker_scaling["desired_size"]
#       }

#   update_config {
#     max_unavailable = 1
#   }

#   instance_types = var.worker_instance_types
#   ami_type = "AL2_x86_64"
#   disk_size =  50
#   capacity_type = "ON_DEMAND"

#   depends_on = [
#     aws_iam_role_policy_attachment.worker-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.worker-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.worker-AmazonEC2ContainerRegistryReadOnly,
#   ]

# }

module "node_group" {
  
  create_node_group = var.create_node_group
  source = "github.com/mskender/aws-terraform-eks-node-group.git?ref=v0.1.2"
  #source = "../aws-terraform-eks-node-group"
  cluster_name = aws_eks_cluster.main.name
  node_group_name = local.eks_node_group_name

  subnet_ids      = var.eks_subnet_ids
  node_scaling = var.eks_worker_scaling
  instance_types = var.worker_instance_types

}
