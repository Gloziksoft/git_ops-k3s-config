# BookingApp – K3s PostgreSQL troubleshooting

**Date:** 2026-11-01

## Problem
- Duplicate PostgreSQL schemas: `booking_db` and `booking_app`.
- Flyway contained only the baseline record.
- The old `booking_app` schema contained outdated application tables.

## Resolution
1. Created backup: `booking_app_backup.sql`.
2. Confirmed `booking_db` as the correct application schema.
3. Removed duplicate schema `booking_app` using `DROP SCHEMA CASCADE`.
4. Preserved the standard PostgreSQL `public` schema.
5. Verified `booking_db.users` structure, including `email_verified`.

## Verification
- Booking application: Running.
- PostgreSQL: Running.
- Application schema: `booking_db`.
- Users: 5.
- `email_verified`: Present.
- Duplicate schema: Removed.

**Status:** Completed successfully.
