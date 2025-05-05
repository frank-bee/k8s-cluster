<div align="center">

### My Home Operations Repository :octocat:

_... managed with Flux_ 🤖

</div>

### :wrench:&nbsp; Tools

| Tool                                                               | Purpose                                                             |
|--------------------------------------------------------------------|---------------------------------------------------------------------|
| [flux](https://toolkit.fluxcd.io/)                                 | Operator that manages your k8s cluster based on your Git repository |
|[external-secrets](https://github.com/external-secrets/external-secrets) | Kubernetes Operator for external secrets management |
|[cloudnative-pg](https://github.com/cloudnative-pg/cloudnative-pg) | Kubernetes Operator for PostgreSQL |

## 💻 Nodes
| Node                          | Hostname | RAM  | Storage                                            | Function    | Operating System |
|-------------------------------|----------|------|----------------------------------------------------|-------------|------------------|

## Storage
| Node         | Hostname | RAM  | Storage                                                                                  | Function   | Operating System |
|--------------|----------|------|------------------------------------------------------------------------------------------|------------|------------------|

## ☁️ Cloud Dependencies

While most of my infrastructure and workloads are self-hosted I do rely upon the cloud for certain key parts of my setup. This saves me from having to worry about two things. (1) Dealing with chicken/egg scenarios and (2) services I critically need whether my cluster is online or not.

| Service                       | Use                                                            | Cost    |
|-------------------------------|----------------------------------------------------------------|---------|
| AWS account (Free Tier)       | Domain(s), S3, SSM                                             | ~$10/yr |
| [GitHub](https://github.com/) | Hosting this repository and continuous integration/deployments | Free    |
