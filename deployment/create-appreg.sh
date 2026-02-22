#!/bin/bash

set -ex

# create the AD application + service principal
APP_ID=$(az ad sp create-for-rbac --name "PetName" --skip-assignment --query appId -o tsv)

# add identifier URI using the app ID
az ad app update --id "$APP_ID" --identifier-uris "api://$APP_ID"

# https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust?pivots=identity-wif-apps-methods-azcli
az ad app federated-credential create --id "$APP_ID" --parameters credential.json

# Add Microsoft Graph API permissions for Group management
# Group.ReadWrite.All: 62a82d76-70ea-41e2-9197-370581804d09
GRAPH_API_ID="00000003-0000-0000-c000-000000000000"
GROUP_READWRITE_ALL="62a82d76-70ea-41e2-9197-370581804d09"

az ad app permission add \
  --id "$APP_ID" \
  --api "$GRAPH_API_ID" \
  --api-permissions "${GROUP_READWRITE_ALL}=Role"

# Grant admin consent (requires Global Administrator or Privileged Role Administrator)
echo "Granting admin consent for Microsoft Graph permissions..."
az ad app permission admin-consent --id "$APP_ID" || echo "Warning: Could not grant admin consent automatically. You may need to grant it manually in Azure Portal."

TENANT_ID=$(az account show --query tenantId -o tsv)
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

az role assignment create \
  --assignee "$APP_ID"  \
  --role Contributor \
  --scope "/subscriptions/$SUBSCRIPTION_ID"

echo "Add following as secrets to your GitHub repository:"
echo "AZURE_CLIENT_ID: $APP_ID"
echo "AZURE_TENANT_ID: $TENANT_ID"
echo "AZURE_SUBSCRIPTION_ID: $SUBSCRIPTION_ID"