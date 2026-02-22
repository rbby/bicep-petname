#!/bin/bash
set -e

# Assign Groups Administrator role to the service principal
APP_ID=$(az ad app list --display-name "PetName" --query "[0].appId" -o tsv)
SP_OBJECT_ID=$(az ad sp show --id "$APP_ID" --query "id" -o tsv)

# Get Groups Administrator role template ID
ROLE_ID="fdd7a751-b60b-444a-984c-02652fe8fa1c"

echo "Assigning Groups Administrator directory role to service principal..."
echo "Service Principal Object ID: $SP_OBJECT_ID"

az rest --method POST \
  --uri "https://graph.microsoft.com/v1.0/roleManagement/directory/roleAssignments" \
  --body "{\"principalId\":\"$SP_OBJECT_ID\",\"roleDefinitionId\":\"$ROLE_ID\",\"directoryScopeId\":\"/\"}" \
  --headers "Content-Type=application/json"

echo ""
echo "Groups Administrator role assigned successfully!"
