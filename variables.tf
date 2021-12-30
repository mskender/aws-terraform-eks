variable region {

    description = "Region in which to create resources."
    type = string
    default = "eu-west-1"
}

variable create_cluster {
    type = bool
    default = true
    description = "Enable/disable resource creation in EKS module."
}

variable create_node_group {
    type = bool
    default = false
    description = "Whether to create a default node group attached to EKS cluster."
}

variable cluster_name {
    default = null
    type = string
    description = "EKS cluster name. If ommited, defults to {prefix}-eks-{suffix}"
}

variable node_group_name {
    default = null
    type = string
    description = "EKS node group name. If ommited, defults to {prefix}-eks-node-{suffix}"
}

variable tags {

    default = null
    description = "Tags to apply to all created objects (vpc, subnets, igw and natgw)"
}

variable prefix {
    type = string
    default = ""
    description = "A string to prefix all resource names for easier sorting"
}

variable suffix {
    type = string
    default = ""
    description = "A string to suffix all resource names."
}

variable eks_version {
    type=string
    default = null
    description = "Kubernetes version. If omitted, latest stable will be used."
}

variable encryption_config {
  
  description = "KMS symmetrical encryption key to encrypt secrets"
  type = list(object({
    key_arn = string
    }))
  default = []
}

variable eks_subnet_ids {
    type = list(string)
    default = [ ]
    description = "A list of subnet ID's to create EKS nodes in"
}

variable eks_private_api_access {
    type = bool
    default = true
    description = "Whether to enable K8S API from inside VPC"
}

variable eks_public_api_access {
    type = bool
    default = true
    description = "Whether to enable K8S API from outside VPC"
}

variable eks_public_api_access_cidrs {
    type = list(string)
    default = ["0.0.0.0/0"]
    description = "A list of CIDR's to allow public access from. Defaults to 0/0"
}

variable eks_security_group_ids {
    type = list(string)
    default = [  ]
    description = "A list of security group ID's to override default ones."
}

variable eks_service_cidr {
    type = string
    default = "10.253.253.0/24"
    description = "K8S service IP CIDR. Must not overlap with your existing VPC assignments."
}

variable eks_worker_scaling {
    type = object({
        max_size = number
        min_size = number
        desired_size = number 
    })
    default = {
        max_size = 1
        min_size = 1
        desired_size = 1
    }
}

variable worker_instance_types {
    type = list(string )
    default = ["t3.medium"]
    description = "Type of worker node instance"
}

variable kubeconfig_cluster_friendly_name {
    default = null
    type = string
    description = "Friendly name of EKS cluster to write to kubeconfig as cluster and context values. If not specified, defaults to either {cluster_name} or {prefix}-eks-{suffix}."

}

variable kube_config_location {
    description = "Where to store kube config file after eks creation"
    type = string
}

variable write_kube_config {
    type = bool
    default = false
    description = "Whether to write kube config file, to a location defined by { kube_config_location }"
}

variable export_kube_config {
    type = bool
    default = false
    description = "Whether to export kube config path to KUBECONFIG env var and write to shell RC file defined by { shell_rc } file"
}

variable shellrc_file {
    type = string
    default = "~/.bashrc"
}

variable enable_oidc {
    type = bool
    default = true
    description = "Whether to create OIDC connector. Primarily used for K8S ServiceAccount (and other API) authorization with IAM"
}

variable oidc_ca_thumbprint {
    type = string
    default = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
    description = "CA Thumbprint, valid for until 2030. Don't touch 'till then."
}