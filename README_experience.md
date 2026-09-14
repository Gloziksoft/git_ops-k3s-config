# 🛠️ Practical Experience

This document summarizes practical experience gained while building,
deploying and troubleshooting the local K3s / GitOps environment.

---

## K3s / ArgoCD Troubleshooting

### 🚨 22. 8. 2026 — ArgoCD `repo-server` after K3s startup

After starting K3s, ArgoCD reported:

```text
Sync Status: Unknown
Unknown: 3
Healthy: 3
```

The investigation traced the problem to the `argocd-repo-server`
init container `copyutil`, which failed with:

```text
/bin/ln: Already exists
```

The `repo-server` Pod was recreated and ArgoCD returned to:

```text
Synced
Healthy
```

**Lesson learned:** When ArgoCD reports `Unknown`, check the ArgoCD
components themselves, including Pods, Services, Endpoints and logs.

Detailed troubleshooting:

`docs/troubleshooting/2026-08-22-argocd-repo-server.md`

---

### 🚨 24. 8. 2026 — InsuranceApp MariaDB credentials

InsuranceApp login failed even though the application and MariaDB Pods
were running correctly.

The investigation revealed incorrect MariaDB credentials in the
Kubernetes Secret and an already initialized database on the existing
PVC.

For the local demo environment, the database was reinitialized and
`init.sql` was executed during MariaDB initialization.

**Lesson learned:** Changing a Kubernetes Secret does not automatically
change credentials already stored in an initialized database.

Detailed troubleshooting:

`docs/troubleshooting/2026-08-24-insuranceapp-mariadb.md`

---

## Deployment and GitOps

Practical experience includes working with:

- K3s
- Kubernetes Deployments and Services
- StatefulSets
- PersistentVolumes and PersistentVolumeClaims
- ConfigMaps
- Kubernetes Secrets
- Kustomize
- ArgoCD
- GitOps workflows
- Ingress
- MetalLB
- Docker and Docker Compose

The environment is used to simulate a realistic application deployment
workflow from source configuration in Git through ArgoCD and K3s to the
running applications.

---

## Application Infrastructure

The environment contains two Spring Boot applications:

- **BookingEasyApp**
- **InsuranceApp**

The applications use separate databases:

- PostgreSQL for BookingEasyApp
- MariaDB for InsuranceApp

The infrastructure also includes application Services, persistent
storage, Ingress routing and supporting Kubernetes resources.

---

## Troubleshooting Approach

When a problem occurs, the investigation follows the dependency chain
instead of checking only the application itself.

Typical troubleshooting flow:

```text
Application
     ↓
Pod
     ↓
Container
     ↓
Environment / Configuration
     ↓
Service
     ↓
Storage / Database
     ↓
Kubernetes / K3s
     ↓
ArgoCD / GitOps
```

The goal is to identify the actual root cause instead of only fixing
the visible symptom.

---

## Documentation

Detailed troubleshooting cases are stored separately in:

```text
docs/troubleshooting/
```

This keeps this document focused on the overall practical experience
while individual incidents can contain detailed commands, logs,
root-cause analysis, fixes and lessons learned.
