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

### Add a Service Mesh

To optionally add the Linkerd service mesh to the cluster run the following commands:

```shell
linkerd install --crds | kubectl apply -f -
linkerd install | kubectl apply -f -
linkerd check
```

Install and start the Linkerd dashboard with the following commands:

```shell
linkerd viz install | kubectl apply -f -
linkerd check
linkerd viz dashboard &
```

### Observability

To access the Grafana dashboard, you need to forward traffic to the Grafana server. To do so, run the following commands:

```shell
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3001:80
```

To log in to your Grafana Dashboard, you should use the default credentials for the kube-Prometheus-stack.

```text
Username: admin
Password: prom-operator 
```

To view the Flux Cluster Stats browse to <http://127.0.0.1:3001/d/flux-cluster/flux-cluster-stats>

### Cleanup

To clean up the environment run ```k3d cluster delete```
