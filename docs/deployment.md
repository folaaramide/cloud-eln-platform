# Deployment Guide

## Overview

The Cloud ELN Platform is deployed using a fully automated CI/CD pipeline built with GitHub Actions.

The application source code is stored in GitHub, packaged as a Docker container, pushed to Amazon Elastic Container Registry (ECR), and deployed automatically to Amazon ECS Fargate. All AWS infrastructure is provisioned using Terraform.

This approach ensures deployments are repeatable, consistent and require minimal manual intervention.

---

# Deployment Architecture

```
Developer
    │
    ▼
Git Push (main)
    │
    ▼
GitHub Actions
    │
    ├── Checkout Repository
    ├── Install Python
    ├── Install Dependencies
    ├── Run Flake8
    ├── Run Trivy Security Scan
    ├── Build Docker Image
    ├── Push Image to Amazon ECR
    └── Force ECS Deployment
                 │
                 ▼
          Amazon ECS Fargate
```

---

# Infrastructure Provisioning

All AWS resources are created using Terraform.

The Terraform configuration provisions:

- Amazon VPC
- Public and Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- IAM Roles
- Application Load Balancer
- Amazon ECS Cluster
- Amazon ECS Service
- Amazon ECR Repository
- Amazon RDS PostgreSQL
- CloudWatch Log Groups

Because every resource is defined in code, the entire environment can be recreated consistently.

---

# Continuous Integration

Every push to the **main** branch automatically starts the GitHub Actions workflow.

The workflow performs the following steps:

1. Checkout the repository
2. Configure Python
3. Install project dependencies
4. Run Flake8 code quality checks
5. Run Trivy vulnerability scan
6. Build the Docker image
7. Authenticate with Amazon ECR
8. Push the Docker image to Amazon ECR
9. Trigger a new ECS deployment
10. Wait for the ECS service to become healthy

No manual deployment steps are required.

---

# Docker Deployment

The application is packaged using Docker before deployment.

The Docker image contains:

- Flask application
- Python runtime
- Project dependencies
- Gunicorn application server
- Database migration script

Packaging the application inside a container ensures identical environments across development and production.

---

# Database Initialisation

When a new container starts, the application automatically performs database migrations before the Flask application begins serving requests.

The container startup process is:

1. Start container
2. Run Alembic database migrations
3. Create any missing database tables
4. Start Gunicorn
5. Begin accepting user requests

Automating migrations prevents deployment failures caused by missing database tables.

---

# Logging and Monitoring

Application logs are automatically streamed from ECS to Amazon CloudWatch.

CloudWatch provides visibility into:

- Application startup
- Flask errors
- Database connection issues
- Container events
- ECS task lifecycle

This greatly simplifies troubleshooting and operational monitoring.

---

# Security

Several security practices were incorporated into the deployment.

- Infrastructure deployed inside a dedicated VPC
- ECS tasks run within private subnets
- Amazon RDS is not publicly accessible
- Security Groups restrict network communication
- IAM roles provide least-privilege permissions
- Docker images are scanned using Trivy before deployment

---

# Deployment Outcome

The completed deployment delivers:

- Fully automated CI/CD
- Containerised application hosting
- Managed PostgreSQL database
- Infrastructure as Code
- Centralised logging
- Secure networking
- Production-style AWS architecture

The result is a repeatable cloud deployment process that closely reflects modern AWS engineering practices.
