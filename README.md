# K3D Flux CD Developer Lab

| Demo of Flux CD maintaining a local [K3D](https://k3d.io/) cluster for developer environments.

## Getting Started

```shell
k3d cluster create
flux install
kubectl apply -k ./k8s/cluster/flux-system
flux reconcile kustomization flux-system
flux tree kustomization flux-system
kubectl cluster-info
```

To clean up the environment run ```k3d cluster delete```
