**Dátum:** 22. 8. 2026

# 🛠️ K3s / ArgoCD / InsuranceApp – Troubleshooting

---

# 🚨 ArgoCD — `repo-server` CrashLoopBackOff po štarte K3s

**Dátum:** 22. 8. 2026

## Problém

Po štarte K3s zobrazovalo ArgoCD:

```text
Sync Status: Unknown
Unknown: 3
Healthy: 3
```

Aplikácie boli pritom Kubernetesovo zdravé, ale ArgoCD nevedelo
synchronizovať stav z Git repozitára.

## Príčina

Používaná verzia:

```text
ArgoCD v3.3.6
```

Problém bol v `argocd-repo-server` Pod-e, konkrétne v init kontajneri
`copyutil`.

Kontrola:

```bash
kubectl -n argocd get pods -o wide | grep repo-server
```

Pri probléme:

```text
argocd-repo-server-...   0/1   Completed
```

Service nemal endpoint:

```bash
kubectl -n argocd get endpoints argocd-repo-server
```

Výsledok:

```text
ENDPOINTS
```

prázdny.

### Root cause

```bash
kubectl -n argocd logs <repo-server-pod> -c copyutil
```

vrátilo:

```text
/bin/ln: Already exists
```

`copyutil` sa pokúšal vytvoriť symlink:

```text
/var/run/argocd/argocd-cmp-server
```

Init container skončil s:

```text
Exit Code: 1
CrashLoopBackOff
```

a `argocd-repo-server` sa nestal Ready.

## Dôsledok

```text
copyutil
   ↓
Already exists
   ↓
CrashLoopBackOff
   ↓
repo-server 0/1
   ↓
Service bez Endpoint
   ↓
ArgoCD controller sa nemá kam pripojiť
   ↓
Sync = Unknown
```

ArgoCD pritom mohlo stále zobrazovať `Healthy` pre samotné Kubernetes resources.

## Fix / workaround

Zmazanie problémového `repo-server` Pod-u:

```bash
kubectl -n argocd delete pod <repo-server-pod>
```

Deployment automaticky vytvoril nový Pod.

Overenie:

```bash
kubectl -n argocd get pods -l app.kubernetes.io/name=argocd-repo-server -w
kubectl -n argocd get endpoints argocd-repo-server
```

Po vytvorení čistého Pod-u sa `repo-server` spustil správne a ArgoCD
sa vrátilo do stavu:

```text
Synced
Healthy
```

## Existujúci alias

Na tento workaround je pripravený alias:

```text
k3s-fix-argocd
```

Používať ho ako praktický workaround po štarte, kým nebude problém
odstránený aktualizáciou ArgoCD.

## Dôležité

Problém nebol spôsobený:

- BookingApp
- InsuranceApp
- GitOps repozitárom
- PostgreSQL
- MariaDB
- Kubernetes resources

Problém bol v inicializácii `argocd-repo-server`.

### Lesson learned

Pri `ArgoCD = Unknown` nekontrolovať iba samotné aplikácie.

Najprv overiť:

```bash
kubectl -n argocd get pods
kubectl -n argocd get endpoints argocd-repo-server
kubectl -n argocd describe pod <repo-server-pod>
kubectl -n argocd logs <repo-server-pod> -c copyutil
```

Najdôležitejšia stopa bola:

```text
/bin/ln: Already exists
```

Následné vytvorenie nového `repo-server` Pod-u problém odstránilo.

---

# 🚨 InsuranceApp — MariaDB credentials a reinitializácia DB v K3s

**Dátum:** 24. 8. 2026

## Problém

InsuranceApp bola `Running`, MariaDB Pod bol `Ready` a Service aj PVC
boli `Healthy`, ale prihlasovanie do aplikácie nefungovalo.

Spring Boot používal správnu JDBC URL:

```text
jdbc:mariadb://mariadb-service:3306/insurance_db
```

## Root cause

Problém bol v Kubernetes Secret-e a existujúcom PVC.

Secret mal v `data:` nesprávne hodnoty:

```yaml
mariadb-root-password: root
mariadb-user: root
mariadb-password: root
```

`data:` vyžaduje Base64, preto boli hodnoty opravené:

```yaml
mariadb-root-password: cm9vdA==
mariadb-user: cm9vdA==
mariadb-password: cm9vdA==
```

`cm9vdA==` je Base64 reprezentácia textu `root`.

Samotná zmena Secretu však nestačila, pretože MariaDB už bola
inicializovaná na existujúcom PVC.

## Fix

Pre lokálne demo prostredie bol odstránený starý PVC a vytvorený nový.

SQL dump:

```text
base/insurance-app/db-init-scripts/init.sql
```

bol pridaný do GitOps repozitára a pomocou Kustomize vytvorený ako
ConfigMap:

```text
ConfigMap
   ↓
/docker-entrypoint-initdb.d/init.sql
   ↓
MariaDB initialization
```

MariaDB následne pri novej inicializácii vytvorila `insurance_db`
a automaticky vykonala `init.sql`.

## Overenie

MariaDB log potvrdil:

```text
Creating database insurance_db
Creating user root
running /docker-entrypoint-initdb.d/init.sql
MariaDB init process done. Ready for start up.
```

Po reinitializácii:

```text
MariaDB      ✅
PVC          ✅
InsuranceApp ✅
Login        ✅
DB data      ✅
ArgoCD       Synced / Healthy
```

### Lesson learned

Pri probléme s DB nestačí kontrolovať iba Pod a Service.

Treba overiť celý chain:

```text
Secret
 ↓
Environment variables
 ↓
Service / JDBC
 ↓
PersistentVolume
 ↓
Database initialization
 ↓
Application
```

Dôležité: zmena Kubernetes Secretu automaticky nezmení credentials
už inicializovanej databázy na existujúcom PVC.

### Security note

Použitý Base64 Secret je vhodný iba pre lokálne demo.

Base64 ≠ encryption.

Pre production GitOps by bolo vhodné použiť napr.:

```text
Sealed Secrets
External Secrets
Secret Manager / Vault
```
