# Cluster Setup

## Bootstrapping

```
kubectl apply -f manifests/nodes
kubectl apply -f manifests/storageclass
kustomize build --enable-helm --load-restrictor LoadRestrictionsNone  manifests/argocd/ | kubectl apply -f -

# fetch argocd admin password
kubectl -nargocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d | pbcopy

# port-forward argocd to local port
kubectl -nargocd port-forward svc/argocd-server 8080:80
```