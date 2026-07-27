# Architecture Decisions

## Purpose

This document explains the key technical decisions made during the development of the Cloud ELN Platform and the reasoning behind each choice.

The project was designed to mirror a modern production AWS deployment rather than simply hosting a Flask application. Every technology was selected to demonstrate cloud engineering, automation and operational best practices.

---

# Decision 1 – Amazon ECS Fargate instead of EC2

## Decision

Deploy the application on Amazon ECS Fargate.

## Reason

Running containers on Fargate removes the need to provision, patch and maintain EC2 instances.

This allowed the project to focus on container orchestration, deployments and application management instead of server administration.

## Benefits

- Serverless container platform
- Simplified operations
- Easier future scaling
- Production-style deployment model

---

# Decision 2 – Docker for Application Packaging

## Decision

Package the Flask application inside a Docker container.

## Reason

Docker provides a consistent runtime environment across development, testing and production.

Instead of configuring software manually on servers, the application and all dependencies are defined in a single Docker image.

## Benefits

- Consistent deployments
- Environment reproducibility
- Easier CI/CD integration
- Faster deployments

---

# Decision 3 – PostgreSQL on Amazon RDS

## Decision

Use Amazon RDS PostgreSQL as the application database.

## Reason

A managed relational database provides automatic backups, high reliability and removes the need to manage database servers.

PostgreSQL was selected because it integrates well with Flask and SQLAlchemy.

## Benefits

- Managed database service
- Persistent storage
- Automatic maintenance
- Production-ready architecture

---

# Decision 4 – GitHub Actions for CI/CD

## Decision

Use GitHub Actions to automate application deployment.

## Reason

Every push to the main branch automatically builds, validates and deploys the application without manual intervention.

The workflow performs:

- Code checkout
- Python setup
- Flake8 linting
- Trivy vulnerability scanning
- Docker image build
- Push to Amazon ECR
- ECS service deployment

## Benefits

- Automated deployments
- Reduced human error
- Faster release process
- Version-controlled pipeline

---

# Decision 5 – Terraform for Infrastructure

## Decision

Provision AWS infrastructure using Terraform.

## Reason

Instead of creating resources manually in the AWS Console, every infrastructure component is defined as code.

This makes the environment reproducible and suitable for collaboration.

Resources managed include:

- VPC
- Public subnets
- Private subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- ECS Cluster
- ECS Service
- Application Load Balancer
- Amazon RDS
- IAM Roles

## Benefits

- Repeatable deployments
- Infrastructure version control
- Easier maintenance
- Reduced configuration drift

---

# Decision 6 – Application Load Balancer

## Decision

Place an Application Load Balancer in front of ECS.

## Reason

The load balancer provides a single entry point for users and distributes requests to healthy containers.

This reflects how production web applications are commonly deployed on AWS.

## Benefits

- Central entry point
- Health checks
- Improved availability
- Supports future scaling

---

# Decision 7 – CloudWatch for Monitoring

## Decision

Use Amazon CloudWatch for application logging.

## Reason

Application logs are streamed directly from ECS into CloudWatch.

During development this proved invaluable for diagnosing deployment failures, migration problems and application startup errors.

## Benefits

- Centralised logging
- Easier troubleshooting
- Operational visibility
- Supports production monitoring

---

# Decision 8 – Private Networking

## Decision

Deploy compute and database resources inside private subnets.

## Reason

The ECS tasks and PostgreSQL database should not be directly accessible from the public internet.

Only the Application Load Balancer is publicly reachable.

## Benefits

- Improved security
- Reduced attack surface
- Production-style network design

---

# Summary

Each architectural decision was made with one objective:

> Build a cloud platform that demonstrates modern AWS engineering practices rather than simply deploying a Flask application.

The resulting platform combines Infrastructure as Code, containerisation, managed services, CI/CD automation and monitoring into a production-style AWS deployment.
