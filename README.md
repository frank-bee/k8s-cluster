<div align="center">

### My Home Operations Repository :octocat:

_... managed with Flux_ 🤖

</div>

## 🔍 Overview

This repository contains the configuration for my home Kubernetes cluster. It uses GitOps principles to manage infrastructure and applications.

### :wrench:&nbsp; Tools

| Tool                                                               | Purpose                                                             |
|--------------------------------------------------------------------|---------------------------------------------------------------------|
| [flux](https://toolkit.fluxcd.io/)                                 | Operator that manages your k8s cluster based on your Git repository |
| [traefik](https://traefik.io/)                                     | Ingress controller with Let's Encrypt ACME integration for HTTPS    |
| [external-secrets](https://github.com/external-secrets/external-secrets) | Kubernetes Operator for external secrets management |
| [cloudnative-pg](https://github.com/cloudnative-pg/cloudnative-pg) | Kubernetes Operator for PostgreSQL |

## 💻 Nodes
| Node                          | RAM     | Storage            | Function       | Operating System |
|-------------------------------|---------|-------------------|----------------|------------------|
| k8smaster                     | 4GB     | ~15GB             | Control Plane  | Ubuntu 24.04.2 LTS |
| k3s-node1                     | 8GB     | ~101GB            | Worker         | Ubuntu 24.04.2 LTS |
| k3s-node2                     | 8GB     | ~101GB            | Worker         | Ubuntu 24.04.2 LTS |

## Storage
The cluster uses the following storage providers:

| Storage Provider       | Description                                    |
|------------------------|------------------------------------------------|
| Local Path Provisioner | Default k3s storage provisioner                |

Container runtime: containerd 2.0.4-k3s2

## 🌐 Applications

| Application                    | URL                                       | Description                                 |
|--------------------------------|-------------------------------------------|---------------------------------------------|
| Paperless                      | *domain redacted*                          | Document management system                 |
| Nginx Test App                 | *domain redacted*                          | Test application                           |

## 🔒 HTTPS Configuration

This cluster uses Traefik's built-in Let's Encrypt ACME integration for HTTPS certificates instead of cert-manager.

## 🔐 Security Practices

This repository implements security best practices to protect sensitive information:

### Pre-commit Hooks

Git pre-commit hooks automatically scan for sensitive information before allowing commits.

Installation:
```bash
./scripts/install-hooks.sh
```

The hooks check for:
- Passwords and API keys
- Private keys and certificates
- Kubernetes secrets
- Personal identifiers
- Email addresses and domains

## ☁️ Cloud Dependencies

While most of my infrastructure and workloads are self-hosted I do rely upon the cloud for certain key parts of my setup. This saves me from having to worry about two things. (1) Dealing with chicken/egg scenarios and (2) services I critically need whether my cluster is online or not.

| Service                       | Use                                                            | Cost    |
|-------------------------------|----------------------------------------------------------------|---------|
| AWS account (Free Tier)       | Domain(s), S3, SSM                                             | ~$10/yr |
| [GitHub](https://github.com/) | Hosting this repository and continuous integration/deployments | Free    |
| Let's Encrypt                 | SSL certificate provider                                       | Free    |
