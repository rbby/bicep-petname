#!/usr/bin/env bash
# Deploys test-petname.bicep to a resource group and fails if any assert*
# output is false. Bicep outputs are only evaluated at deployment time, so a
# real (subscription-scoped) deployment is required to test values.
#
# Usage: ./test.sh <resource-group>
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <resource-group>" >&2
  exit 2
fi
rg="$1"

echo "Deploying test-petname.bicep to resource group '$rg'..."
outputs=$(az deployment group create \
  --resource-group "$rg" \
  --name "petname-test-$(date +%s)" \
  --template-file "$(dirname "$0")/test-petname.bicep" \
  --query 'properties.outputs' \
  --output json)

failures=$(echo "$outputs" | python3 -c '
import json, sys
outputs = json.load(sys.stdin)
failed = [k for k, v in outputs.items() if k.startswith("assert") and v["value"] is not True]
print("\n".join(failed))
')

echo
echo "Generated names:"
echo "$outputs" | python3 -c '
import json, sys
for k, v in sorted(json.load(sys.stdin).items()):
    if not k.startswith("assert"):
        print(f"  {k}: " + str(v["value"]))
'

if [[ -n "$failures" ]]; then
  echo
  echo "FAILED assertions:" >&2
  echo "$failures" >&2
  exit 1
fi

echo
echo "All assertions passed."
