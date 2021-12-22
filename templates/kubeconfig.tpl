apiVersion: v1
preferences: {}
kind: Config

clusters:
- cluster:
    server: ${eks_endpoint}
    certificate-authority-data: ${cluster_auth_base64}
  name: ${kubeconfig_name}

contexts:
- context:
    cluster: ${kubeconfig_name}
    user: ${kubeconfig_name}
  name: ${kubeconfig_name}

current-context: ${kubeconfig_name}

users:
- name: ${kubeconfig_name}
  user:
    exec:
      apiVersion: ${aws_authenticator_kubeconfig_apiversion}
      command: ${aws_authenticator_command}
      args:
%{~ for i in aws_authenticator_command_args }
        - "${i}"
%{~ endfor ~}
      
      env:
        - name: AWS_PROFILE
          value: ${aws_profile}
