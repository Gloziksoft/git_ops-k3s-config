# 🚨 ArgoCD -- `repo-server` CrashLoopBackOff po štarte K3s

## Problém

Po štarte K3s môže ArgoCD zobraziť:

``` text
Sync Status: Unknown
Unknown: 3
Healthy: 3
```

Aplikácie sú pritom Kubernetesovo zdravé, ale ArgoCD nevie
synchronizovať stav z Git repozitára.

## Príčina

Používaná verzia:

``` text
ArgoCD v3.3.6
```

Problém je v `argocd-repo-server` Pod-e, konkrétne v init kontajneri
`copyutil`.

Kontrola:

``` bash
kubectl -n argocd get pods -o wide | grep repo-server
```

Pri probléme:

``` text
argocd-repo-server-...   0/1   Completed
```

Service nemá endpoint:

``` bash
kubectl -n argocd get endpoints argocd-repo-server
```

Výsledok:

``` text
ENDPOINTS
```

prázdny.

### Root cause

``` bash
kubectl -n argocd logs <repo-server-pod> -c copyutil
```

vráti:

``` text
/bin/ln: Already exists
```

`copyutil` sa pokúša vytvoriť symlink:

``` text
/var/run/argocd/argocd-cmp-server
```

Init container následne skončí s:

``` text
Exit Code: 1
CrashLoopBackOff
```

a `argocd-repo-server` sa nestane Ready.

## Dôsledok

``` text
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

ArgoCD môže pritom stále zobrazovať:

``` text
Healthy
```

pre samotné Kubernetes resources.

## Overenie

Deployment má stále požadovanú jednu repliku:

``` bash
kubectl -n argocd get deployment argocd-repo-server -o wide
```

Typicky:

``` text
READY   0/1
UP-TO-DATE  1
AVAILABLE   0
```

ReplicaSet:

``` bash
kubectl -n argocd get rs -l app.kubernetes.io/name=argocd-repo-server
```

Aktívny ReplicaSet môže mať:

``` text
DESIRED  1
CURRENT  1
READY    0
```

## Fix / workaround

Zmazať problémový `repo-server` Pod:

``` bash
kubectl -n argocd delete pod <repo-server-pod>
```

Deployment automaticky vytvorí nový Pod.

Sledovanie:

``` bash
kubectl -n argocd get pods -l app.kubernetes.io/name=argocd-repo-server -w
```

Očakávaný stav:

``` text
0/1 Running
1/1 Running
```

Po vytvorení čistého Pod-u sa `/var/run/argocd` vytvorí nanovo a
`copyutil` prebehne správne.

Overenie:

``` bash
kubectl -n argocd get endpoints argocd-repo-server
```

Endpoint už nie je prázdny.

ArgoCD následne:

``` text
Unknown  0
Synced   3
OutOfSync 0
Healthy  3
```

## Existujúci alias

Na tento workaround je už pripravený alias:

``` text
k3s-fix-argocd -> Fixing ArgoCD...
```

Používať ho ako praktický workaround po štarte, kým nebude ArgoCD
aktualizované na verziu, ktorá tento problém rieši.

## Dôležité

Tento problém nebol spôsobený:

-   BookingApp
-   InsuranceApp
-   GitOps repozitárom
-   PostgreSQL
-   MariaDB
-   Kubernetes resources

Problém bol v inicializácii `argocd-repo-server`.

### Lesson learned

Pri `ArgoCD = Unknown` nekontrolovať iba samotné aplikácie.

Najprv:

``` bash
kubectl -n argocd get pods
kubectl -n argocd get endpoints argocd-repo-server
kubectl -n argocd describe pod <repo-server-pod>
kubectl -n argocd logs <repo-server-pod> -c copyutil
```

**Najdôležitejšia stopa bola:**

``` text
/bin/ln: Already exists
```

a následne nový `repo-server` Pod problém odstránil.
