# K3D Flux CD Developer Lab

Demo of Flux CD maintaining a local [K3D](https://k3d.io/) cluster for developer environments.

## Pre-Requisites

The following tools need to be install on your machine:

* [Docker](https://www.docker.com/)
* [jq]
* [kubectl](https://kubernetes.io/docs/reference/kubectl/)
* [Homebrew](https://brew.sh/)

### Install CLI Tools

From a terminal run the following commands to install the CLI tools required for working with this repo:

```shell
brew install k3d                # Install K3D CLI
brew install fluxcd/tap/flux    # Install Flux CLI
brew install jq                 # Install jq
```

## Getting Started

```shell
# Create k3d cluster
k3d cluster create --config .github/workflows/assets/config.yaml
kubectl cluster-info

# Install Flux
flux check --pre
flux install
flux check

# Apply cluster manifests
kubectl apply -k ./k8s/cluster/flux-system

# Wait for cluster reconciliation
kubectl -n flux-system wait kustomization/flux-system --for=condition=ready --timeout=5m
kubectl -n flux-system wait kustomization/infrastructure --for=condition=ready --timeout=5m
kubectl -n flux-system wait kustomization/apps --for=condition=ready --timeout=5m
kubectl -n flux-system wait kustomization/tools --for=condition=ready --timeout=5m
kubectl -n podinfo wait kustomization/podinfo --for=condition=ready --timeout=5m

# View cluster structure
flux tree kustomization flux-system --compact

IP=$(kubectl get svc traefik -n kube-system -o json | jq -j '.status.loadBalancer.ingress[].ip')
echo "http://$IP"

```
