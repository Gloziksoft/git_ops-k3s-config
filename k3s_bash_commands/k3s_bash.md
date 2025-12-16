🧾 GitOps / K3s / Argo CD – PRÍKAZY + KOMENTÁRE
🔹 Kubernetes – základné informácie
kubectl get nodes


➡️ Zobrazí všetky uzly (VM / server) v Kubernetes clustri

kubectl get ns


➡️ Zobrazí všetky namespace (logické oddelenie aplikácií)

kubectl get pods -A


➡️ Zobrazí všetky pody vo všetkých namespace

kubectl get svc -A


➡️ Zobrazí všetky služby (Service) v clustri

🔹 Namespace (správa prostredia)
kubectl create namespace argocd


➡️ Vytvorí namespace argocd

kubectl delete namespace argocd


➡️ Zmaže celý namespace (POZOR – zmaže všetko v ňom)

kubectl get ns argocd -o yaml


➡️ Detailná YAML definícia namespace (debug / finalizers)

🔹 Argo CD – inštalácia
kubectl create namespace argocd


➡️ Namespace pre Argo CD

kubectl apply -n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


➡️ Nainštaluje Argo CD do clusteru

🔹 Argo CD – prístup do web UI
kubectl port-forward svc/argocd-server -n argocd 8080:443


➡️ Sprístupní Argo CD web na https://localhost:8080

🔹 Argo CD – admin heslo (iba prvýkrát)
kubectl -n argocd get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" | base64 --decode


➡️ Získa počiatočné heslo pre používateľa admin

🔹 Argo CD – CLI prihlásenie
argocd login localhost:8080 --insecure


➡️ Prihlási Argo CD CLI na lokálny Argo CD server

🔹 Argo CD – informácie o účte
argocd account get-user-info


➡️ Zobrazí prihláseného používateľa

argocd account list


➡️ Zoznam účtov v Argo CD

🔹 Argo CD – aplikácie
argocd app list


➡️ Zoznam všetkých aplikácií spravovaných Argo CD

argocd app get booking-app-prod


➡️ Detailný stav aplikácie booking-app-prod

argocd app get insurance-app-prod


➡️ Detailný stav aplikácie insurance-app-prod

🔹 Argo CD – vytvorenie aplikácií
argocd app create -f argocd/booking-app.yaml


➡️ Vytvorí Argo CD aplikáciu z YAML súboru

argocd app create -f argocd/insurance-app.yaml


➡️ Vytvorí druhú aplikáciu

🔹 Argo CD – synchronizácia (deploy)
argocd app sync booking-app-prod


➡️ Nasadí aplikáciu podľa GitHub repozitára

argocd app sync insurance-app-prod


➡️ Nasadí insurance aplikáciu

🔹 Argo CD – mazanie aplikácií
argocd app delete booking-app-prod


➡️ Odstráni aplikáciu z Argo CD aj z Kubernetes

argocd app delete insurance-app-prod


➡️ Odstráni druhú aplikáciu

🔹 Kubernetes – stav aplikácií
kubectl get all -n booking-app


➡️ Zobrazí všetky objekty v namespace booking-app

kubectl get all -n insurance-app


➡️ Zobrazí všetky objekty v namespace insurance-app

🔹 Port-forward aplikácií (lokálny prístup)
kubectl port-forward svc/booking-app-service -n booking-app 8081:80


➡️ Aplikácia dostupná na http://localhost:8081

kubectl port-forward svc/insurance-app-service -n insurance-app 8082:80


➡️ Aplikácia dostupná na http://localhost:8082

🔹 Debug podov
kubectl describe pod <pod-name> -n booking-app


➡️ Detailný popis podu (image, env, events)

kubectl logs <pod-name> -n booking-app


➡️ Logy kontajnera (chyby aplikácie)

🔹 Problémy s image
kubectl get events -n booking-app


➡️ Zobrazí chyby typu ImagePullBackOff, ErrImagePull

🔹 Secrets
kubectl get secrets -n booking-app


➡️ Zobrazí všetky secrets v namespace

kubectl describe secret <secret-name> -n booking-app


➡️ Detail secretu (bez dekódovania)

Ak chceš, ďalší krok vieme:

🔜 pridať GitHub Actions (GHCR) príkazy

🔜 spraviť Oracle Cloud verziu

🔜 alebo to celé pretvoriť na PDF / učebnicu

Stačí povedať 👌
