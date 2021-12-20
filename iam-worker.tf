locals {

    eks_worker_iam_role_name = "${var.prefix}-eks-worker-role${local.suffix}"
}

resource "aws_iam_role" "eks-worker" {
  
  name                  = local.eks_worker_iam_role_name
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

resource "aws_iam_role_policy_attachment" "worker-AmazonEKSWorkerNodePolicy" {
  
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-worker.name
}

resource "aws_iam_role_policy_attachment" "worker-AmazonEKS_CNI_Policy" {
  
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-worker.name
}

resource "aws_iam_role_policy_attachment" "worker-AmazonEC2ContainerRegistryReadOnly" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-worker.name
}