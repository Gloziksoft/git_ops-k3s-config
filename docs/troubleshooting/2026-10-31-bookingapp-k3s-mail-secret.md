# BookingApp – K3s SMTP Secret Configuration

**Date:** 2026-10-31  
**Environment:** Local K3s  
**GitOps:** Argo CD / Kustomize  
**Application:** BookingApp

## Problem

BookingApp was failing during Spring Boot startup because the required environment variable `MAIL_FROM` was missing.

Observed error:

```text
Could not resolve placeholder 'MAIL_FROM'
```

## Investigation

The Deployment referenced two Kubernetes Secrets:

- `booking-mail-secret` – SMTP configuration and application email settings.
- `booking-mail-credentials` – SMTP username and password.

The Git-managed Secret did not contain `MAIL_FROM` in the live Kubernetes cluster.

The local Git manifest had been modified, but the changes had not yet been committed and pushed. Argo CD was therefore still following the previous version from the remote `main` branch.

## Changes implemented

Updated:

`base/booking-app/secrets/mail-secret.yaml`

- Removed duplicate `SPRING_MAIL_USERNAME`.
- Removed duplicate `SPRING_MAIL_PASSWORD`.
- Added `MAIL_FROM`.
- Updated `APP_ADMIN_EMAIL`.

SMTP credentials remain referenced through `booking-mail-credentials` in the Deployment.

## GitOps deployment

- Validated Kustomize output successfully.
- Committed and pushed the changes to GitHub.
- Argo CD detected commit `26bca18`.
- Argo CD synchronized `booking-mail-secret`.

## Verification

The live Kubernetes Secret contains the `MAIL_FROM` key.

Argo CD UI subsequently showed:

- `booking-app-prod` – Healthy / Synced
- `insurance-app-prod` – Healthy / Synced
- `infra-ingress` – Healthy / Synced

## Remaining tasks

- Verify current BookingApp startup logs.
- Verify actual SMTP credentials without exposing them.
- Investigate obsolete SMTP username/password keys remaining in the live Secret.
- Test email delivery.
- Complete InsuranceApp K3s verification.

## Security notes

SMTP passwords and other sensitive credentials must not be committed to Git.

The `booking-mail-credentials` Secret is maintained separately in Kubernetes.

No actual credentials should be included in this troubleshooting document.
