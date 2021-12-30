locals {

    oidc_url = var.create_cluster ? aws_eks_cluster.main[0].identity[0].oidc[0].issuer : null
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  
  count = (var.enable_oidc && var.create_cluster) ? 1:0
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.oidc_ca_thumbprint]
  url             = local.oidc_url

}