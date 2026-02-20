#!/bin/bash

set -ex

# create the AD application + service principal
APP_ID=$(az ad sp create-for-rbac --name "PetName" --skip-assignment --query appId -o tsv)

# add identifier URI using the app ID
az ad app update --id "$APP_ID" --identifier-uris "api://$APP_ID"

# https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust?pivots=identity-wif-apps-methods-azcli
az ad app federated-credential create --id "$APP_ID" --parameters credential.json

echo "APP_ID=$APP_ID"
