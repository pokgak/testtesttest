# README

This repo contains the code required to setup to deploy an EKS cluster with Terraform and deploy and Apache Airflow cluster on it using ArgoCD.

- terraform: folder for terraform code
    * ./network: network setup includes vpc, subnets, security groups, routes
    * ./eks: the EKS cluster setup using EKS Auto mode
    * ./eks/iam: the IAM role required for components deployed into the cluster
- k8s: folder for all k8s manifests/argocd related setup
    * ./argocd-applications: folder for storing all ArgoCD Application CRD resources
    * ./manifests: contains one folder for each deployed component inside the cluster; uses kustomize to deploy Helm charts and manipulates it when needed
    * ./manifests/argocd: argocd configurations
    * ./manifests/airflow: airflow configurations
    * ./manifests/external-secrets: use external-secrets to fetch secrets from AWS Secrets Manager to avoid pushing secrets to the repo