variable region {

    description = "Region in which to create resources."
    type = string
    default = "eu-west-1"
}

variable create_cluster {
    type = bool
    default = true
    description = "Disable resource creation in EKS module."
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

variable kube_config_location {
    description = "Where to store kube config file after eks creation"
    type = string
    
}