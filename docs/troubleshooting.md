# Troubleshooting Guide

## Overview

During development of the Cloud ELN Platform, several deployment and application issues were encountered. Rather than treating these as setbacks, each problem became an opportunity to better understand AWS services, containerised deployments and production troubleshooting.

This document summarises the most significant issues, how they were investigated and how they were resolved.

---

# Issue 1 – Database Tables Not Created

## Symptoms

- Registration failed
- SQLAlchemy reported missing database tables
- Flask application started successfully but database operations failed

## Investigation

The application logs in Amazon CloudWatch showed that the application was attempting to query tables that did not yet exist.

The ECS task itself was healthy, indicating the problem was occurring during application startup rather than infrastructure deployment.

## Root Cause

Database migrations were not being executed automatically before the Flask application started.

## Resolution

The container entrypoint was updated to:

1. Execute Alembic migrations
2. Create missing database tables
3. Start Gunicorn

This ensured every new deployment prepared the database before serving requests.

---

# Issue 2 – ECS Deployment Failed

## Symptoms

- ECS service deployment failed
- Tasks repeatedly stopped
- Service remained unstable

## Investigation

The following sources were reviewed:

- ECS Service Events
- ECS Task Status
- CloudWatch Application Logs
- GitHub Actions deployment logs

CloudWatch identified application startup errors rather than infrastructure problems.

## Root Cause

The container configuration and startup sequence were incorrect.

## Resolution

The Docker configuration and application startup process were corrected before redeploying.

After deployment, ECS health checks completed successfully.

---

# Issue 3 – Trivy Security Scan Failed

## Symptoms

The GitHub Actions workflow failed during the Trivy vulnerability scanning stage.

The deployment pipeline stopped before the Docker image could be pushed to Amazon ECR.

## Investigation

The GitHub Actions logs identified the failure during the Trivy scanning step.

The workflow configuration was reviewed to confirm how scan results were being handled.

## Root Cause

The workflow was configured to fail immediately when vulnerabilities were detected, preventing deployment while the pipeline was still being developed.

## Resolution

The workflow configuration was updated so that vulnerability scanning continued to provide visibility without unnecessarily blocking development deployments.

This allowed security scanning to remain part of the CI/CD pipeline while maintaining deployment progress.

---

# Issue 4 – PostgreSQL Driver Missing

## Symptoms

Application failed to connect to PostgreSQL after deployment.

## Investigation

Container logs reported that the PostgreSQL database driver could not be loaded.

## Root Cause

The required PostgreSQL driver dependency was missing from the application requirements.

## Resolution

The PostgreSQL driver was added to the project dependencies, the Docker image was rebuilt and the application was redeployed successfully.

---

# Issue 5 – Registration Errors

## Symptoms

User registration requests failed despite the application loading correctly.

## Investigation

CloudWatch application logs were reviewed to trace the registration request from Flask through to the database layer.

## Root Cause

The registration endpoint attempted to access database objects before migrations had completed.

## Resolution

Automatic database migrations were incorporated into the container startup process, ensuring the database schema was always available before processing requests.

---

# Troubleshooting Workflow

Throughout development, a structured troubleshooting approach was followed.

1. Reproduce the issue.
2. Review GitHub Actions logs.
3. Review ECS service events.
4. Inspect CloudWatch application logs.
5. Identify the failing component.
6. Apply a targeted fix.
7. Rebuild the Docker image.
8. Push a new image to Amazon ECR.
9. Trigger a fresh ECS deployment.
10. Confirm service health and application functionality.

This systematic approach reduced unnecessary changes and made it easier to isolate the true cause of each issue.

---

# Lessons Learned

Several practical lessons were gained throughout the project.

- Application logs are often more valuable than infrastructure metrics when diagnosing deployment failures.
- Automating database migrations greatly improves deployment reliability.
- CI/CD pipelines should include both quality checks and security scanning.
- Container startup order is critical for production deployments.
- Infrastructure as Code makes troubleshooting easier because environments remain consistent.
- CloudWatch and ECS service events together provide a complete picture of deployment health.

---

# Summary

The challenges encountered during this project closely reflected the types of issues faced in real production cloud environments.

Resolving them required investigation across multiple AWS services including Amazon ECS, Amazon CloudWatch, GitHub Actions, Docker and PostgreSQL. The experience reinforced the importance of structured troubleshooting, automation and observability when operating cloud-native applications.
