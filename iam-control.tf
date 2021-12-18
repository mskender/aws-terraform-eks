locals {

    eks_iam_role_name = "${var.prefix}-eks-control-role${local.suffix}"
}

resource "aws_iam_role" "eks-control" {
  
  name                  = local.eks_iam_role_name
  assume_role_policy    = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  #permissions_boundary  = var.permissions_boundary
  force_detach_policies = true
  
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-control.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-control.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceControllerPolicy" {
  

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-control.name
}