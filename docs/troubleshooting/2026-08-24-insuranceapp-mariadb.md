# InsuranceApp MariaDB troubleshooting

**Date:** 24. 8. 2026

## Problem

InsuranceApp login failed even though the application and MariaDB Pods were running correctly.

## Investigation

The investigation focused on the connection between InsuranceApp and the MariaDB database.

The problem was related to incorrect MariaDB credentials in the Kubernetes Secret and an already initialized database on the existing PersistentVolume.

The application configuration and Kubernetes resources were checked to determine whether the problem was caused by the application, the Secret or the existing database state.

## Root cause

The MariaDB database had already been initialized on the existing PersistentVolume.

Changing the Kubernetes Secret did not change the credentials that were already stored in the initialized database.

This caused a mismatch between the credentials used by InsuranceApp and the credentials configured in the existing MariaDB database.

## Fix

For the local demonstration environment, the MariaDB database was reinitialized.

The initialization script was executed again during MariaDB initialization.

After the database was reinitialized with the correct configuration, InsuranceApp was able to authenticate against MariaDB correctly.

## Verification

The MariaDB Pod and InsuranceApp Pod were checked again.

The application was tested after the database reinitialization and the login problem was resolved.

## Troubleshooting flow

The investigation demonstrated the importance of checking the complete dependency chain:

    InsuranceApp
          ↓
    Kubernetes Secret
          ↓
    Application configuration
          ↓
    MariaDB Service
          ↓
    MariaDB Pod
          ↓
    PersistentVolume
          ↓
    Existing database state

## Lesson learned

Changing a Kubernetes Secret does not automatically change credentials that are already stored in an initialized database.

When troubleshooting database authentication, it is necessary to check both the Kubernetes configuration and the existing database state.

Persistent storage can preserve the old database state even when Kubernetes configuration is changed.
