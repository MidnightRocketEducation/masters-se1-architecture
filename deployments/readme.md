# Deployments

This folder contains Kubernetes ressource manifests for various components of the system, including services, monitoring tools and load testing setups.

## Apply folders

- To deploy all components within a specific folder, use the following command
- Non `.yaml` files will be ignored by kubectl

  ```zsh
  kubectl apply -f ./deployments/<folder-name>
  ```
