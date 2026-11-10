# Booking application – K3s startup and health probes

**Date:** 10. 11. 2026

## Problem

During a K3s environment startup, ArgoCD showed the Booking application as:

    Sync Status: Synced
    Health Status: Progressing

The Booking application eventually started successfully, but its startup appeared slower than Insurance.

## Investigation

### 1. Pod status

Checked the Booking application and PostgreSQL Pods:

    kubectl get pods -n booking-app -o wide

Both Pods were running and ready:

- `booking-app-deployment`: Running, READY 1/1
- `postgresql-booking-app-0`: Running, READY 1/1

### 2. Spring Boot startup time

Inspected application logs:

    kubectl logs -n booking-app deployment/booking-app-deployment --since=30m

Spring Boot reported:

    Started BookingAppApplication in 27.205 seconds

The PostgreSQL connection was established successfully. Flyway validated the migrations, and no database migration was necessary.

### 3. Comparison with Insurance

Checked the Insurance application startup time:

    kubectl logs -n insurance-app deployment/insurance-app-deployment | grep "Started"

Result:

    Started InsuranceAppApplication in 37.743 seconds

Booking actually started approximately 10.5 seconds faster than Insurance.

### 4. Kubernetes health probes

Inspected the Booking Deployment configuration.

The application has:

- Readiness probe: `/actuator/health/readiness`
- Liveness probe: `/actuator/health/liveness`
- `initialDelaySeconds: 60`
- `periodSeconds: 10`

Both probes have a 60-second initial delay.

This means Kubernetes delays the first health check. It does not mean Spring Boot itself needs 60 seconds to start.

### 5. Git history investigation

The Git history identified two relevant changes.

**26 December 2025 – commit `febe323`**

    optimize booking-app for single-node k3s (replicas=1, remove affinity)

Changes included:

- Reduced replicas from 2 to 1.
- Removed pod anti-affinity for the single-node K3s environment.
- Added the `wait-for-postgres` init container.

The init container waits until PostgreSQL accepts connections on port 5432 before starting the application container.

**12 January 2026 – commit `97849ff`**

    base/booking-app/deployment.yaml

Added:

- Readiness probe with `initialDelaySeconds: 60`.
- Liveness probe with `initialDelaySeconds: 60`.

The exact original reason for choosing 60 seconds could not be confirmed from the Git commit history.

## Root cause / Findings

No current application startup failure was identified.

The investigation confirmed:

- Booking starts successfully.
- PostgreSQL connectivity works.
- Database migrations complete successfully.
- Spring Boot startup takes approximately 27.2 seconds.
- The 60-second initial delay postpones Kubernetes health checks.
- The original reason for selecting this delay remains unconfirmed.

The `wait-for-postgres` init container and health probes solve different problems and should not be treated as interchangeable.

## Resolution

No configuration changes were made.

The existing startup protection was retained because the application previously experienced startup failures when PostgreSQL was not ready.

## Verification

- [x] Booking Pod is Running and READY 1/1.
- [x] PostgreSQL Pod is Running and READY 1/1.
- [x] PostgreSQL connection established successfully.
- [x] Flyway migrations validated successfully.
- [x] Spring Boot started successfully.
- [x] Booking startup time compared with Insurance.
- [x] Git history reviewed.
- [x] Existing Kubernetes configuration retained.

## Lesson learned

When an application appears slow to start in ArgoCD, distinguish between:

1. Spring Boot application startup.
2. Database availability.
3. Kubernetes readiness and liveness checks.
4. ArgoCD health assessment.

A delayed readiness check does not necessarily mean the application itself is slow.

The `wait-for-postgres` init container protects Booking from starting before PostgreSQL accepts connections. Readiness and liveness probes provide separate health monitoring.

Historical configuration changes should be documented together with their reasons whenever possible. When the original reason cannot be established, record that uncertainty rather than assuming a cause.
