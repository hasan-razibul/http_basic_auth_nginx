# Kubernetes, Vault, and NGINX Deployment

This project demonstrates deploying an NGINX server on a local Kubernetes cluster using Helm, with HTTP basic authentication using credentials stored in Vault.

## Prerequisites

- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/): A tool for running local Kubernetes clusters using Docker container "nodes".
- [Helm](https://helm.sh/docs/intro/install/): A package manager for Kubernetes.

## Setup

### Step 1: Create a Local Kubernetes Cluster

Create a local Kubernetes cluster using kind:

```
kind create cluster
```

### Step 2: Deploy Vault
Deploy Vault on your local Kubernetes cluster using Helm:

```
helm install vault hashicorp/vault --set "server.dev.enabled=true"
```
Before proceeding to the next step, ensure that the Vault server is fully deployed and running. You can check the status of the Vault server with the following command:

```
kubectl get all
```

### Step 3: Run the Setup Script
Run the provided setup script. This script configures Vault and creates the necessary Kubernetes resources:

```
sh script.sh
```
### Step 4: Deploy the Application
Deploy the NGINX server using the provided Helm chart:
```
helm install nginx ./nginx
```
Before proceeding to the next step, ensure that the Vault server is fully deployed and running. You can check the status of the Vault server with the following command:

```
kubectl get all
```
### Step 5: Set Up Port Forwarding

Set up port forwarding from your local machine to the NGINX service:

```
kubectl port-forward service/nginx 8080:80
```

## Testing
Start a new terminal. Test the setup by making HTTP requests to the NGINX server with cURL. The server is configured to require HTTP basic authentication.
```
curl -I -u daniel:password1 http://127.0.0.1:8080/
curl -I -u robin:password2 http://127.0.0.1:8080/ 
curl -I -u robin:demo http://127.0.0.1:8080/
```
The first two requests should succeed (HTTP 200), while the third request should fail (HTTP 401 Unauthorized).