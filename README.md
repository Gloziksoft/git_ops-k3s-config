# git_ops-k3s-config

## Purpose

This repository contains the **GitOps configuration for the local K3s environment** used for development, testing, deployment experiments and operational troubleshooting of the applications.

The repository contains Kubernetes manifests managed through **Kustomize** and synchronized by **ArgoCD**.

## Scope

This repository includes:

- Kubernetes application manifests
- Kustomize base and production-like overlays
- ArgoCD Application and Project configuration
- application Services
- PostgreSQL and MariaDB StatefulSets
- Kubernetes Secrets and related documentation
- Ingress configuration
- MetalLB configuration
- K3s deployment and operational documentation
- GitOps-related troubleshooting and experience notes

## Applications

The repository currently contains configuration for:

- **BookingEasyApp**
- **InsuranceApp**

## Architecture overview

The local environment follows this deployment flow:

```text
Git repository
      ↓
   ArgoCD
      ↓
   Kustomize
      ↓
     K3s
      ↓
┌───────────────┬────────────────┐
│ BookingEasyApp│  InsuranceApp  │
│   Spring Boot │   Spring Boot  │
└───────┬───────┴───────┬────────┘
        ↓               ↓
   PostgreSQL         MariaDB
