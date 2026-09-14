# VM Latency Investigation

## Overview

During operation of BookingEasyApp on an Oracle Cloud VM, occasional latency was observed when accessing the application after a period of inactivity.

The application itself was running correctly, but the first request after inactivity was noticeably slower than subsequent requests.

## Initial observation

The application responded normally after the first request.

Typical behaviour:

    Application inactive
          ↓
    First request
          ↓
    Higher latency
          ↓
    Subsequent requests
          ↓
    Normal response time

This indicated that the problem was not necessarily related to the application being unavailable.

## Monitoring

The environment was monitored using the existing monitoring setup.

Relevant metrics included:

- CPU usage
- Container memory
- JVM heap
- API latency

The monitoring data was used to compare the behaviour during normal operation with the slower first request.

## Oracle Cloud Agent

The Oracle Cloud Agent and its updater were investigated as a possible source of background activity on the VM.

The agent updater service was temporarily disabled as part of the troubleshooting process.

This reduced some background activity and improved the situation, but it did not completely eliminate the initial latency.

## Further investigation

The investigation showed that the latency could still occur even without the Oracle Cloud Agent being responsible for the complete problem.

This was important because it prevented the troubleshooting from stopping at the first visible correlation.

The investigation was therefore continued through the application and container layers.

## BookingEasyApp startup behaviour

BookingEasyApp uses a PostgreSQL database and waits for the database to become reachable before starting the application.

The Kubernetes deployment contains an init container which waits for PostgreSQL:

    until nc -z postgresql-service 5432
    do
        ...
    done

This ensures that the application does not start before the database network endpoint is available.

## Lesson learned

A slower first request after inactivity does not automatically mean that the application itself is broken.

Troubleshooting should compare:

- application behaviour
- JVM behaviour
- container behaviour
- VM resources
- background services
- database availability
- network behaviour

Monitoring is useful not only for detecting failures, but also for identifying differences between the first request and subsequent requests.

The investigation also reinforced the importance of checking the complete system instead of assuming that the first suspected component is the root cause.
