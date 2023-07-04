locals {

    eks_iam_role_name = "${var.prefix}-eks-control-role${local.suffix}"
}

resource "aws_iam_role" "eks-control" {
  count = var.create_cluster ? 1:0
  name                  = local.eks_iam_role_name
  assume_role_policy    = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "Service": "eks.amazonaws.com"
        }
      },
    ]
  })
  #permissions_boundary  = var.permissions_boundary
  force_detach_policies = true

}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  count = var.create_cluster ? 1:0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-control[0].name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {

  count = var.create_cluster ? 1:0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-control[0].name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceControllerPolicy" {

  count = var.create_cluster ? 1:0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-control[0].name
}

resource aws_iam_policy eks-controller-policy {
  count = var.create_cluster ? 1:0
  name        = "${var.prefix}-eks-controller-policy${local.suffix}"
  path        = "/"
  description = "My test policy"
  policy = file("${path.module}/policies/elb-controller-policy.json")

}

resource "aws_iam_role_policy_attachment" "cluster_eks-controller-policy" {

  count = var.create_cluster ? 1:0
  policy_arn = aws_iam_policy.eks-controller-policy[0].arn
  role       = aws_iam_role.eks-control[0].name
}