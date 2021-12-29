locals {

    oidc_url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  
  count = var.enable_oidc ? 1:0
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.oidc_ca_thumbprint]
  url             = local.oidc_url

}