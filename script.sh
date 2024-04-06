#!/bin/sh

# Enable Kubernetes authentication in Vault
kubectl exec vault-0 -- vault auth enable kubernetes

# Configure Vault with Kubernetes service account token and CA cert
kubectl exec vault-0 -- sh -c 'vault write auth/kubernetes/config \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_host=https://kubernetes.default.svc.cluster.local \
    kubernetes_ca_cert="$(cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt)"'

# Create a Vault policy for the myapp service
kubectl exec vault-0 -- sh -c 'echo "path \"secret/data/myapp\" { capabilities = [\"read\"] }" > /tmp/myapp-policy.hcl'
kubectl exec vault-0 -- vault policy write myapp /tmp/myapp-policy.hcl

# Create a Vault role for the myapp service
kubectl exec vault-0 -- vault write auth/kubernetes/role/myapp \
    bound_service_account_names=nginx \
    bound_service_account_namespaces=default \
    policies=myapp \
    ttl=24h

# Store the myapp service credentials in Vault
kubectl exec vault-0 -- vault kv put secret/myapp daniel=password1 robin=password2