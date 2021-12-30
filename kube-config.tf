locals {
    #kubeconfig_final_loc  = var.kube_config_location == null ? pathexpand("~/.kube/config-${local.eks_cluster_name}") : pathexpand(var.kube_config_location)
    kubeconfig_final_loc = pathexpand(var.kube_config_location)
    config_cluster_name = var.kubeconfig_cluster_friendly_name == null ? local.eks_cluster_name : var.kubeconfig_cluster_friendly_name 
    kubeconfig = templatefile("${path.module}/templates/kubeconfig.tpl", 
    {
        kubeconfig_name                         = local.config_cluster_name
        eks_endpoint                             = var.create_cluster ? aws_eks_cluster.main[0].endpoint : ""
        cluster_auth_base64                     = var.create_cluster ? aws_eks_cluster.main[0].certificate_authority[0].data : ""
        aws_authenticator_kubeconfig_apiversion = "client.authentication.k8s.io/v1alpha1"
        aws_authenticator_command               = "aws" #"aws-iam-authenticator"
        aws_authenticator_command_args          = ["--region", var.region, "eks", "get-token", "--cluster-name", local.eks_cluster_name]
        aws_profile = "sbp"
    }) 

    kubeconfig_ENV_VAR = "export KUBECONFIG=$KUBECONFIG:${local.kubeconfig_final_loc}"
}


resource "local_file" "kubeconfig" {
  
  count = (var.write_kube_config && var.create_cluster) ? 1:0
  content              = local.kubeconfig
  filename             = local.kubeconfig_final_loc
  file_permission      = "0640"
  directory_permission = "0750"
}

resource "null_resource" "kubeconfig_path" {
  count = (var.export_kube_config && var.create_cluster)  ? 1:0
  provisioner "local-exec"  {
    
    command = "echo ${local.kubeconfig_ENV_VAR} >> ${pathexpand(var.shellrc_file)} && ${local.kubeconfig_ENV_VAR}"
  }
}
