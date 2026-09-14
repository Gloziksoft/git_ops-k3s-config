# JUnit, Docker and K3s

**Date:** 2. 9. 2026

## Overview

This period included practical work with Spring Boot testing, Docker containerization and deployment to the local K3s environment.

The work was performed on the BookingEasyApp and InsuranceApp projects.

## JUnit and Mockito

Unit testing was implemented for Spring Boot service classes using JUnit and Mockito.

The tests focused on service-layer behaviour and used mocked dependencies such as:

- Repositories
- Mappers
- Email services

The purpose was to test the service logic independently from the real database and external infrastructure.

## BookingEasyApp tests

The `ReservationServiceImplTest` covered important reservation scenarios.

Examples included:

- Successful reservation creation
- Invalid reservation dates
- Finding an existing reservation by ID

Mockito was used to mock dependencies and verify interactions with the service layer.

The reservation creation test also verified that the reservation was saved and that the expected service behaviour was executed.

## InsuranceApp tests

The InsuranceApp service layer was also tested using JUnit and Mockito.

Tests were created for `InsuranceServiceImpl`.

The tests helped verify service behaviour without requiring the complete application infrastructure.

## Docker

The applications were containerized and tested using Docker.

Docker Compose was also used to run application dependencies locally.

The practical workflow included:

    Spring Boot application
            ↓
          Maven
            ↓
        Docker image
            ↓
      Docker container

## K3s deployment

The Docker images were deployed into the local K3s environment.

Kubernetes resources used by the applications included:

- Deployments
- Services
- StatefulSets
- PersistentVolumes
- PersistentVolumeClaims
- Secrets
- ConfigMaps
- Ingress

## Deployment workflow

The practical deployment flow was:

    Source code
         ↓
       Maven
         ↓
     Docker image
         ↓
       K3s
         ↓
    Kubernetes Pod
         ↓
     Application

The environment was used to test the complete path from application development through containerization to Kubernetes deployment.

## Troubleshooting approach

Testing and deployment problems were investigated by checking the individual layers rather than changing multiple components at once.

The general approach was:

    Application
         ↓
       Tests
         ↓
       Docker
         ↓
        K3s
         ↓
    Kubernetes resources
         ↓
      Application

## Lesson learned

Unit tests make it possible to isolate service-layer logic from infrastructure.

Docker provides a consistent way to package and run the applications, while K3s makes it possible to test Kubernetes deployment and operational behaviour in a local environment.

The combination of JUnit, Mockito, Docker and K3s provides practical experience across both application development and deployment.
