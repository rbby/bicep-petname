#!/bin/bash
set -e

APP_ID=$(az ad app list --display-name "PetName" --query "[0].appId" -o tsv)
SP_OBJECT_ID=$(az ad sp show --id "$APP_ID" --query "id" -o tsv)
GRAPH_SP_ID=$(az ad sp list --filter "appId eq '00000003-0000-0000-c000-000000000000'" --query "[0].id" -o tsv)
ROLE_ID="62a82d76-70ea-41e2-9197-370581804d09"

echo "Service Principal Object ID: $SP_OBJECT_ID"
echo "Graph Service Principal ID: $GRAPH_SP_ID"
echo "Assigning Group.ReadWrite.All role to service principal..."

az rest --method POST \
  --uri "https://graph.microsoft.com/v1.0/servicePrincipals/$SP_OBJECT_ID/appRoleAssignments" \
  --body "{\"principalId\":\"$SP_OBJECT_ID\",\"resourceId\":\"$GRAPH_SP_ID\",\"appRoleId\":\"$ROLE_ID\"}" \
  --headers "Content-Type=application/json"

echo ""
echo "Role assignment completed successfully!"
