# BookingEasyApp SMTP Troubleshooting

**Date:** 14. 9. 2026

## Overview

The password recovery functionality of BookingEasyApp worked in the production environment running on an Oracle Cloud VM, but email sending failed in the local K3s environment.

The problem was investigated across the application, Kubernetes configuration, Docker image, network connectivity and SMTP authentication.

## Initial symptom

The password recovery endpoint was called:

    http://booking.localhost/account/forgot-password

The application attempted to send the password recovery email, but the operation failed with:

    Authentication failed

The application itself was running correctly.

## Production comparison

The production VM used the FORPSI SMTP server:

    smtp.forpsi.com

SMTP configuration included:

    Port: 587
    STARTTLS: enabled
    SMTP authentication: enabled
    Username: test@gloziksoft.sk

The same SMTP server was also required by the K3s deployment.

Comparing the production and K3s configurations helped establish that the expected SMTP settings were known and working in production.

## Kubernetes configuration investigation

The initial Kubernetes mail configuration contained incorrect SMTP values.

The Kubernetes Secret was corrected and the deployment was changed so that the SMTP username and password were obtained from a separate Kubernetes Secret.

The application therefore received:

    SPRING_MAIL_USERNAME
    SPRING_MAIL_PASSWORD

from:

    booking-mail-credentials

Non-sensitive SMTP configuration remained separately managed.

## ArgoCD investigation

ArgoCD was also checked during the investigation.

The live ArgoCD Application was using an outdated Git repository URL.

The repository reference was corrected and ArgoCD was synchronized with the current GitOps repository.

The application then showed:

    Synced
    Healthy

## Kubernetes Secret behaviour

Updating a Kubernetes Secret does not automatically restart existing Pods when the Secret is consumed as environment variables.

After changing the SMTP configuration, the BookingEasyApp Pod therefore had to be recreated so that the new environment variables were loaded.

This was verified by checking the environment inside the new Pod.

## SMTP connectivity

Network connectivity from the K3s environment to the SMTP server was tested.

The SMTP endpoint was reachable on port 587.

A TLS connection using STARTTLS was also successfully established.

The SMTP server advertised authentication mechanisms including:

    AUTH LOGIN
    AUTH PLAIN

This confirmed that basic network connectivity and TLS negotiation were working.

## Docker image investigation

The production VM and K3s environment were also compared at the container image level.

The deployment used:

    :prod

with:

    imagePullPolicy: IfNotPresent

The K3s node had an older cached image.

The production VM was running a newer image.

The deployment was changed to:

    imagePullPolicy: Always

After synchronization, K3s pulled the current image.

The image digest was then compared with the production environment to verify that both environments were running the same application image.

## Final root cause

The remaining authentication problem was caused by the SMTP password being transported through the shell incorrectly.

The password contained consecutive:

    $$

In Bash, `$$` has a special meaning: it expands to the current shell process ID.

As a result, the password was changed when it was inserted through the shell instead of being passed literally.

After correcting the password value, password recovery email sending worked successfully.

## Important lesson

A password can contain characters that have a special meaning to a shell.

The characters themselves are not necessarily invalid for the SMTP server.

The problem is how the value is transported or interpreted before it reaches the application.

Examples of shell-sensitive syntax include:

    $VAR
    $$
    $(command)
    backticks

For credentials, values should be handled carefully and should not be inserted into shell commands without considering shell expansion and quoting.

## Security lesson

During troubleshooting, credentials must never be stored in Git or unnecessarily printed to logs or terminals.

The Kubernetes Secret containing the SMTP username and password is intentionally kept outside the Git repository.

Because the SMTP password was exposed during troubleshooting, the password should be rotated after the investigation.

## Troubleshooting flow

The investigation followed the complete dependency chain:

    Browser
       ↓
    BookingEasyApp
       ↓
    Kubernetes Pod
       ↓
    Environment variables
       ↓
    Kubernetes Secret
       ↓
    Docker image
       ↓
    K3s networking
       ↓
    SMTP server
       ↓
    SMTP authentication

The final fix was found only after checking the complete chain.

## Result

After correcting the SMTP password handling:

    Password recovery
          ↓
    BookingEasyApp
          ↓
    SMTP authentication
          ↓
    FORPSI SMTP
          ↓
    Password recovery email
          ↓
        SUCCESS

This troubleshooting case provided practical experience with Kubernetes Secrets, ArgoCD, Docker image versions, SMTP, TLS, shell expansion and production-versus-local environment comparison.
