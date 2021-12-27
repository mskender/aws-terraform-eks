# Simple EKS Module for AWS

WARNING: Still in progress, so bound to change often! Do not use this in production!


## Description

This is a simple module for creating EKS cluster with all dependencies Currently supported features:

- create EKS Control node
- create EKS worker nodes
- create IAM roles
- create and dump local kube config to custom file (default ~/.kube/config-${cluster_name})
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

```
The EKS cluster creation will dump the config to the location of `kubeconfig_location` which will also be used to create helm charts, thus the dependency.


