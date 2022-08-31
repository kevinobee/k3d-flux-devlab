#!/bin/bash
# install.sh - create k8s cluster and install GitOps applications using Flux CLI

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

echo
echo "Create k3d cluster ..."
k3d cluster create --config .github/workflows/assets/config.yaml
kubectl wait node --all --for condition=ready
kubectl cluster-info

echo
echo "Install Flux ..."
flux check --pre
flux install
flux check

echo
echo "Apply cluster manifests ..."
kubectl apply -k ./k8s/cluster/flux-system

echo
echo "Wait for cluster reconciliation ..."
kubectl -n flux-system wait kustomization/flux-system --for=condition=ready --timeout=5m
kubectl -n flux-system wait kustomization/infrastructure --for=condition=ready --timeout=5m
kubectl -n flux-system wait kustomization/apps --for=condition=ready --timeout=5m
kubectl -n flux-system wait kustomization/tools --for=condition=ready --timeout=5m
kubectl -n podinfo wait kustomization/podinfo --for=condition=ready --timeout=5m

echo
flux tree kustomization flux-system --compact