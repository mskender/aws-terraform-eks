# Simple EKS Module for AWS

WARNING: Still in progress, so bound to change often! Do not use this in production!

## Description

This is a simple module for creating EKS cluster with all dependencies Currently supported features:

- create EKS Control node
- create EKS worker nodes (optional)
- create IAM roles
- create and dump local kube config to custom file (default ~/.kube/config-${cluster\_name})
- create and dump KUBECONFIG env var

## Notes

This module was written with cookie-cutter simplicity in mind.

It should get you going with experimenting with EKS fast with some sane defaults.

If you want every param of your EKS cluster fully customizable, there are plenty of such modules around.

## Examples

```
module "k8s" {
    # Creates EKS cluster and, optionally, an on-demand autoscaling node group.
    # Will dump kube config file to disk on location specified by kube_config_location var and optionally set KUBECONFIG env var in shellrc_file.
    region = "eu-west-1"
    source = "github.com/mskender/aws-terraform-eks.git?ref=v0.2.1"
    
    cluster_name = local.cluster_name
    eks_subnet_ids = module.network.public_subnets.*.id
    
    write_kube_config = true
    kube_config_location = ""~/.kube/config-${local.cluster_name}""

    export_kube_config = true
    shellrc_file = "~/.customization"
    
    create_node_group = true
    eks_worker_scaling = {
        max_size = 1
        min_size = 1
        desired_size =1
    }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.38.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=3.38.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_node_group"></a> [node\_group](#module\_node\_group) | github.com/mskender/aws-terraform-eks-node-group.git | v0.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_openid_connect_provider.oidc_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.eks-controller-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks-control](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceControllerPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_eks-controller-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.kubeconfig_path](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name. If ommited, defults to {prefix}-eks-{suffix} | `string` | `null` | no |
| <a name="input_create_cluster"></a> [create\_cluster](#input\_create\_cluster) | Enable/disable resource creation in EKS module. | `bool` | `true` | no |
| <a name="input_create_node_group"></a> [create\_node\_group](#input\_create\_node\_group) | Whether to create a default node group attached to EKS cluster. | `bool` | `false` | no |
| <a name="input_eks_admin_list"></a> [eks\_admin\_list](#input\_eks\_admin\_list) | A list of ARN roles to enable eks admins. | `list(string)` | <pre>[<br>  "m5.2xlarge"<br>]</pre> | no |
| <a name="input_eks_private_api_access"></a> [eks\_private\_api\_access](#input\_eks\_private\_api\_access) | Whether to enable K8S API from inside VPC | `bool` | `true` | no |
| <a name="input_eks_public_api_access"></a> [eks\_public\_api\_access](#input\_eks\_public\_api\_access) | Whether to enable K8S API from outside VPC | `bool` | `true` | no |
| <a name="input_eks_public_api_access_cidrs"></a> [eks\_public\_api\_access\_cidrs](#input\_eks\_public\_api\_access\_cidrs) | A list of CIDR's to allow public access from. Defaults to 0/0 | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_eks_security_group_ids"></a> [eks\_security\_group\_ids](#input\_eks\_security\_group\_ids) | A list of security group ID's to override default ones. | `list(string)` | `[]` | no |
| <a name="input_eks_service_cidr"></a> [eks\_service\_cidr](#input\_eks\_service\_cidr) | K8S service IP CIDR. Must not overlap with your existing VPC assignments. | `string` | `"10.253.253.0/24"` | no |
| <a name="input_eks_subnet_ids"></a> [eks\_subnet\_ids](#input\_eks\_subnet\_ids) | A list of subnet ID's to create EKS nodes in | `list(string)` | `[]` | no |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | Kubernetes version. If omitted, latest stable will be used. | `string` | `null` | no |
| <a name="input_eks_worker_scaling"></a> [eks\_worker\_scaling](#input\_eks\_worker\_scaling) | n/a | <pre>object({<br>        max_size = number<br>        min_size = number<br>        desired_size = number<br>    })</pre> | <pre>{<br>  "desired_size": 1,<br>  "max_size": 1,<br>  "min_size": 1<br>}</pre> | no |
| <a name="input_enable_oidc"></a> [enable\_oidc](#input\_enable\_oidc) | Whether to create OIDC connector. Primarily used for K8S ServiceAccount (and other API) authorization with IAM | `bool` | `true` | no |
| <a name="input_encryption_config"></a> [encryption\_config](#input\_encryption\_config) | KMS symmetrical encryption key to encrypt secrets | <pre>list(object({<br>    key_arn = string<br>    }))</pre> | `[]` | no |
| <a name="input_export_kube_config"></a> [export\_kube\_config](#input\_export\_kube\_config) | Whether to export kube config path to KUBECONFIG env var and write to shell RC file defined by { shell\_rc } file | `bool` | `false` | no |
| <a name="input_kube_config_location"></a> [kube\_config\_location](#input\_kube\_config\_location) | Where to store kube config file after eks creation | `string` | `"~/. kube/config"` | no |
| <a name="input_kubeconfig_cluster_friendly_name"></a> [kubeconfig\_cluster\_friendly\_name](#input\_kubeconfig\_cluster\_friendly\_name) | Friendly name of EKS cluster to write to kubeconfig as cluster and context values. If not specified, defaults to either {cluster\_name} or {prefix}-eks-{suffix}. | `string` | `null` | no |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | EKS node group name. If ommited, defults to {prefix}-eks-node-{suffix} | `string` | `null` | no |
| <a name="input_oidc_ca_thumbprint"></a> [oidc\_ca\_thumbprint](#input\_oidc\_ca\_thumbprint) | CA Thumbprint, valid for until 2030. Don't touch 'till then. | `string` | `"9e99a48a9960b14926bb7f3b02e22da2b0ab7280"` | no |
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
| <a name="output_certificate_authority"></a> [certificate\_authority](#output\_certificate\_authority) | CA data for the cluster. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | EKS cluster endpoint. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the cluster, whether constructed or explicit. |
| <a name="output_cluster_oidc_url"></a> [cluster\_oidc\_url](#output\_cluster\_oidc\_url) | Cluster's OIDC URL |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | kubectl config as generated by the module. |
| <a name="output_kubeconfig_context"></a> [kubeconfig\_context](#output\_kubeconfig\_context) | The cluster's default context |
| <a name="output_kubeconfig_location"></a> [kubeconfig\_location](#output\_kubeconfig\_location) | Where the kubeconfig file is stored |
