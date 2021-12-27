# Simple EKS Module for AWS

WARNING: Still in progress, so bound to change often! Do not use this in production!

## Description

This is a simple module for creating EKS cluster with all dependencies Currently supported features:

- create EKS Control node
- create EKS worker nodes
- create IAM roles
- create and dump local kube config to custom file (default ~/.kube/config-${cluster\_name})
- create and dump KUBECONFIG env var
- create common/essential deployments:
    - ingress-nginx
    - cert-manager
    - autoscaler
    - argocd

## Notes

This module was written with cookie-cutter simplicity in mind.
It should get you going with experimenting with EKS fast with some sane defaults and eseential deplotments already bundled.

If you want every param of your EKS cluster fully customizable, there are plenty of such modules around.

Requires kubernetes and helm provider configured via main project.

The helm charts will be possibly moved to separate module, so providers for these will have to be separated due to dpenedency EKS cluster -> K8s provider creds -> helm installs. Currently handled by setting:

```
provider kubernetes {
    config_path = local.kubeconfig_loc
}

provider helm {

    kubernetes{
        config_path = local.kubeconfig_location
    }
}
```

and also passing the same var to the module:
```
module "k8s" {

    write_kube_config = true
    kube_config_location = local.kubeconfig_location
}

The EKS cluster creation will dump the config to the location of `kubeconfig_location` which will also be used to create helm charts, thus the dependency.

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.38.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=3.38.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_policy.eks-controller-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks-control](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eks-worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceControllerPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_eks-controller-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker-AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker-AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker-AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.clusterissuer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.kubeconfig_path](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_fqdn"></a> [argocd\_fqdn](#input\_argocd\_fqdn) | ArgoCD FQDN to set on Ingress | `string` | `"argocd.example.com"` | no |
| <a name="input_argocd_version"></a> [argocd\_version](#input\_argocd\_version) | Version of ArgoCD to install | `string` | `""` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install | `string` | `"v1.6.1"` | no |
| <a name="input_certmanager_clusterissuer_type"></a> [certmanager\_clusterissuer\_type](#input\_certmanager\_clusterissuer\_type) | ClusterIssuer type to install (as per cert-manager docs) | `string` | `"ACME"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name. If ommited, defults to {prefix}-eks-{suffix} | `string` | `null` | no |
| <a name="input_create_cluster"></a> [create\_cluster](#input\_create\_cluster) | Disable resource creation in EKS module. | `bool` | `true` | no |
| <a name="input_eks_private_api_access"></a> [eks\_private\_api\_access](#input\_eks\_private\_api\_access) | Whether to enable K8S API from inside VPC | `bool` | `true` | no |
| <a name="input_eks_public_api_access"></a> [eks\_public\_api\_access](#input\_eks\_public\_api\_access) | Whether to enable K8S API from outside VPC | `bool` | `true` | no |
| <a name="input_eks_public_api_access_cidrs"></a> [eks\_public\_api\_access\_cidrs](#input\_eks\_public\_api\_access\_cidrs) | A list of CIDR's to allow public access from. Defaults to 0/0 | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_eks_security_group_ids"></a> [eks\_security\_group\_ids](#input\_eks\_security\_group\_ids) | A list of security group ID's to override default ones. | `list(string)` | `[]` | no |
| <a name="input_eks_service_cidr"></a> [eks\_service\_cidr](#input\_eks\_service\_cidr) | K8S service IP CIDR. Must not overlap with your existing VPC assignments. | `string` | `"10.253.253.0/24"` | no |
| <a name="input_eks_subnet_ids"></a> [eks\_subnet\_ids](#input\_eks\_subnet\_ids) | A list of subnet ID's to create EKS nodes in | `list(string)` | `[]` | no |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | Kubernetes version. If omitted, latest stable will be used. | `string` | `null` | no |
| <a name="input_eks_worker_scaling"></a> [eks\_worker\_scaling](#input\_eks\_worker\_scaling) | n/a | <pre>object({<br>        max_size = number<br>        min_size = number<br>        desired_size = number <br>    })</pre> | <pre>{<br>  "desired_size": 1,<br>  "max_size": 1,<br>  "min_size": 1<br>}</pre> | no |
| <a name="input_encryption_config"></a> [encryption\_config](#input\_encryption\_config) | KMS symmetrical encryption key to encrypt secrets | <pre>list(object({<br>    key_arn = string<br>    }))</pre> | `[]` | no |
| <a name="input_export_kube_config"></a> [export\_kube\_config](#input\_export\_kube\_config) | Whether to export kube config path to KUBECONFIG env var and write to shell RC file defined by { shell\_rc } file | `bool` | `false` | no |
| <a name="input_ingress_class"></a> [ingress\_class](#input\_ingress\_class) | Nginx class is a particular ingress controller identifier. Defaults to nginx. | `string` | `"nginx"` | no |
| <a name="input_install_argocd"></a> [install\_argocd](#input\_install\_argocd) | Whether to install ArgoCD CI/CD solution for K8S | `bool` | `false` | no |
| <a name="input_install_cert_manager"></a> [install\_cert\_manager](#input\_install\_cert\_manager) | Whether to install Cert-Manager on EKS cluster | `bool` | `false` | no |
| <a name="input_install_ingress_nginx"></a> [install\_ingress\_nginx](#input\_install\_ingress\_nginx) | Whether to install Nginx Ingress on EKS cluster. Helm release from https://github.com/kubernetes/ingress-nginx | `bool` | `false` | no |
| <a name="input_install_karpenter"></a> [install\_karpenter](#input\_install\_karpenter) | Whether to install Karpenter autoscaler for K8S | `bool` | `false` | no |
| <a name="input_kube_config_location"></a> [kube\_config\_location](#input\_kube\_config\_location) | Where to store kube config file after eks creation | `string` | n/a | yes |
| <a name="input_kubeconfig_cluster_friendly_name"></a> [kubeconfig\_cluster\_friendly\_name](#input\_kubeconfig\_cluster\_friendly\_name) | Friendly name of EKS cluster to write to kubeconfig as cluster and context values. If not specified, defaults to either {cluster\_name} or {prefix}-eks-{suffix}. | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A string to prefix all resource names for easier sorting | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Region in which to create resources. | `string` | `"eu-west-1"` | no |
| <a name="input_shellrc_file"></a> [shellrc\_file](#input\_shellrc\_file) | n/a | `string` | `"~/.bashrc"` | no |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | A string to suffix all resource names. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all created objects (vpc, subnets, igw and natgw) | `any` | `null` | no |
| <a name="input_worker_instance_types"></a> [worker\_instance\_types](#input\_worker\_instance\_types) | Type of worker node instance | `list(string )` | <pre>[<br>  "t3.medium"<br>]</pre> | no |
| <a name="input_write_kube_config"></a> [write\_kube\_config](#input\_write\_kube\_config) | Whether to write kube config file, to a location defined by { kube\_config\_location } | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | kubectl config as generated by the module. |
| <a name="output_kubeconfig_context"></a> [kubeconfig\_context](#output\_kubeconfig\_context) | The cluster's default context |
| <a name="output_kubeconfig_location"></a> [kubeconfig\_location](#output\_kubeconfig\_location) | Where the kubeconfig file is stored |
