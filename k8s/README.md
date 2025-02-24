# Cluster Setup

## Bootstrapping

```
kubectl apply -f manifests/nodes
kubectl apply -f manifests/storageclass
kustomize build --enable-helm --load-restrictor LoadRestrictionsNone  manifests/argocd/ | kubectl apply -f -
```