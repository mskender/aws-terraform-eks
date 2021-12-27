locals {

    oidc_url = aws_eks_cluster.main.identity[0].oidc[0].issuer
    oidc_ca_thumbprint = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [local.oidc_ca_thumbprint]
  url             = local.oidc_url

}