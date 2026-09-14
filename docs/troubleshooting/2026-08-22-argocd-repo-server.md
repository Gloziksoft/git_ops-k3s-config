# ArgoCD repo-server troubleshooting

**Date:** 22. 8. 2026

## Problem

After starting the K3s environment, ArgoCD reported:

    Sync Status: Unknown
    Unknown: 3
    Healthy: 3

The applications were not synchronizing correctly even though the K3s cluster itself was running.

## Investigation

The investigation started by checking the ArgoCD Pods.

The problem was traced to the `argocd-repo-server` Pod.

The `repo-server` init container `copyutil` failed with:

    /bin/ln: Already exists

This indicated that the problem was inside the ArgoCD `repo-server` Pod rather than in the application manifests themselves.

## Fix

The affected `argocd-repo-server` Pod was recreated.

After the Pod restarted, the init container completed successfully and the ArgoCD repository server became operational again.

ArgoCD returned to:

    Synced
    Healthy

## Verification

The ArgoCD Pods and application status were checked again.

The applications returned to a healthy and synchronized state.

## Lesson learned

When ArgoCD reports `Sync Status: Unknown`, do not immediately assume that the application manifests are wrong.

Check the ArgoCD components themselves:

    ArgoCD Application
            ↓
       repo-server
            ↓
           Pod
            ↓
      Init containers
            ↓
          Logs

Useful commands include checking Pods, describing the affected Pod and checking container logs.

The important lesson was to troubleshoot the dependency chain and identify the actual failing component before changing application configuration.
