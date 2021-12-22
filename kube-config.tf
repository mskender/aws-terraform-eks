locals {
    #kubeconfig_final_loc  = var.kube_config_location == null ? pathexpand("~/.kube/config-${local.eks_cluster_name}") : pathexpand(var.kube_config_location)
    kubeconfig_final_loc = pathexpand(var.kube_config_location)
    kubeconfig = templatefile("${path.module}/templates/kubeconfig.tpl", 
    {
        kubeconfig_name                         = local.eks_cluster_name
        eks_endpoint                                = aws_eks_cluster.main.endpoint
        cluster_auth_base64                     = aws_eks_cluster.main.certificate_authority[0].data
        aws_authenticator_kubeconfig_apiversion = "client.authentication.k8s.io/v1alpha1"
        aws_authenticator_command               = "aws" #"aws-iam-authenticator"
        aws_authenticator_command_args          = ["--region", var.region, "eks", "get-token", "--cluster-name", local.eks_cluster_name]
        aws_profile = "sbp"
    }) 
}


resource "local_file" "kubeconfig" {
  

  content              = local.kubeconfig
  filename             = local.kubeconfig_final_loc
  file_permission      = "0640"
  directory_permission = "0750"
}

