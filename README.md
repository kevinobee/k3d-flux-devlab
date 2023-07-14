# K3D Flux CD Developer Lab

| Demo of Flux CD maintaining a local [K3D](https://k3d.io/) cluster for developer environments.

## Getting Started

To deploy the Kubernetes manifests to a new cluster run the following commands:

```shell
k3d cluster create
flux install
kubectl apply -k ./k8s/cluster/flux-system
kubectl cluster-info
flux reconcile kustomization flux-system --with-source
flux tree kustomization flux-system
```

To get the load balancer ingress IP run the following command:

```shell
echo "http://$(kubectl get svc traefik -n kube-system -o json | jq -j '.status.loadBalancer.ingress[].ip')"
```
```


### Cleanup

To clean up the environment run ```k3d cluster delete```
