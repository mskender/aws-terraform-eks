# Simple EKS Module for AWS

WARNING: Still in progress, so bound to change often! Do not use this in production!


## Description

This is a simple module for creating EKS cluster with all dependencies Currently supported features:

- create EKS Control node
- create EKS worker nodes (optional)
- create IAM roles
- create and dump local kube config to custom file (default ~/.kube/config-${cluster_name})
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


