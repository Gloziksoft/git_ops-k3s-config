# Kubernetes Secrets

Sensitive credentials are intentionally not stored in Git.

The Booking application uses a Kubernetes Secret named:

`booking-mail-credentials`

## Required Secret keys

The Secret contains the SMTP credentials:

- `SPRING_MAIL_USERNAME`
- `SPRING_MAIL_PASSWORD`

The remaining SMTP configuration is currently provided by the existing
`booking-mail-secret` and will be separated later.

## Create the Secret

Create the Secret directly in the target Kubernetes cluster.

The password should not be written into Git or into a file tracked by Git.

Example:

```bash
read -rsp "SMTP password: " SMTP_PASSWORD
echo

kubectl -n booking-app create secret generic booking-mail-credentials \
  --from-literal=SPRING_MAIL_USERNAME='YOUR_SMTP_USERNAME' \
  --from-literal=SPRING_MAIL_PASSWORD="$SMTP_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -

unset SMTP_PASSWORD

## Application configuration

The Booking Deployment consumes the credentials using:

```yaml
env:
  - name: SPRING_MAIL_USERNAME
    valueFrom:
      secretKeyRef:
        name: booking-mail-credentials
        key: SPRING_MAIL_USERNAME

  - name: SPRING_MAIL_PASSWORD
    valueFrom:
      secretKeyRef:
        name: booking-mail-credentials
        key: SPRING_MAIL_PASSWORD

The Secret values are exposed to the Booking container as environment variables.

## GitOps

Sensitive credentials are intentionally not managed by ArgoCD or stored in Git.

The Kubernetes Secret is created directly in the target Kubernetes cluster.

Application manifests remain managed through Git and ArgoCD.

## Deployment procedure

1. Create the `booking-mail-credentials` Secret in the target Kubernetes cluster.
2. Verify that the Secret exists and contains the required keys.
3. Reference the Secret from the Booking Deployment.
4. Validate the Kustomize configuration.
5. Commit and push the Git changes.
6. Let ArgoCD synchronize the application.
7. Verify that the Booking pod receives the credentials.
8. Test the `forgot-password` functionality.
9. Verify email delivery through the configured SMTP server.

## Security notes

Never commit real SMTP credentials to Git.

Kubernetes Secrets are intended for sensitive data, but base64 encoding is not encryption.

Access to Secrets should therefore be restricted using Kubernetes RBAC and appropriate cluster security controls.

For larger production environments, consider using a dedicated external secret management solution.
