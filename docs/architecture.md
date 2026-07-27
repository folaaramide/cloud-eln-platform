# Cloud ELN Platform Architecture

## Overview

The Cloud ELN Platform is a production-style cloud application designed to demonstrate modern AWS infrastructure, DevOps automation and cloud-native deployment practices.

The platform is built around a Flask web application running inside a Docker container on Amazon ECS Fargate. User traffic is securely routed through an Application Load Balancer, application data is stored in Amazon RDS PostgreSQL, and operational logs are streamed to Amazon CloudWatch.

Rather than focusing solely on application development, this project demonstrates how a complete production workload can be designed, deployed, monitored and maintained using Infrastructure as Code and continuous delivery.

---

## Runtime Architecture

```
                    User (Browser)
                           │
                        HTTPS
                           │
                           ▼
             Application Load Balancer
                           │
                           ▼
                 Amazon ECS Fargate
               Flask Docker Container
                    │             │
                    │             │
                    ▼             ▼
          Amazon RDS         Amazon CloudWatch
           PostgreSQL        Logs & Monitoring
```

### Request Flow

1. Users access the application through HTTPS.
2. The Application Load Balancer routes incoming requests to ECS Fargate.
3. The Flask application processes each request.
4. Application data is stored in Amazon RDS PostgreSQL.
5. Application and container logs are continuously streamed to Amazon CloudWatch.

---

## Infrastructure Components

| Component | Purpose |
|-----------|---------|
| Amazon VPC | Provides isolated networking for the application |
| Public Subnets | Host the Application Load Balancer and NAT Gateway |
| Private Subnets | Host ECS tasks and Amazon RDS |
| Internet Gateway | Allows inbound public traffic |
| NAT Gateway | Allows private resources outbound internet access |
| Security Groups | Control network access between resources |
| Application Load Balancer | Distributes incoming HTTPS traffic |
| Amazon ECS Fargate | Runs the containerised Flask application |
| Amazon RDS PostgreSQL | Persistent relational database |
| Amazon CloudWatch | Centralised logging and monitoring |
| Amazon ECR | Stores Docker container images |
| IAM Roles | Secure permissions for AWS services |

---

## Design Principles

The architecture was designed around several core engineering principles.

### High Availability

Resources are deployed across two Availability Zones using separate public and private subnets.

### Security

The application runs inside private subnets and is not directly accessible from the internet. Only the Application Load Balancer accepts inbound traffic.

Security Groups restrict communication between the load balancer, ECS service and database.

### Scalability

Using ECS Fargate removes the need to manage EC2 instances and allows the application to scale more easily in future.

### Observability

Application logs are collected centrally using Amazon CloudWatch, allowing production issues to be investigated without logging directly into infrastructure.

### Automation

All infrastructure is provisioned using Terraform, ensuring deployments are repeatable, version controlled and easy to recreate.

---

## Architecture Decisions

Several design decisions were made to better reflect real production environments.

- ECS Fargate was selected to eliminate server management.
- PostgreSQL on Amazon RDS provides managed, persistent storage.
- Terraform provisions all AWS resources from code.
- GitHub Actions automates build, testing and deployment.
- Docker ensures identical runtime environments between development and production.
- CloudWatch provides centralised operational visibility.

---

## Technologies

- Python
- Flask
- PostgreSQL
- Docker
- Amazon ECS Fargate
- Amazon RDS
- Amazon ECR
- Application Load Balancer
- Amazon CloudWatch
- Terraform
- GitHub Actions
- AWS IAM
- Amazon VPC

---

## Related Documentation

- [Deployment Guide](deployment.md)
- [Architecture Decisions](decisions.md)
- [Troubleshooting Guide](troubleshooting.md)
