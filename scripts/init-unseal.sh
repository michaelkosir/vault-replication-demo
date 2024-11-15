#!/bin/bash

cd "$(dirname $0)"

declare -a arr=("primary" "dr" "performance")

for name in "${arr[@]}"; do
    echo "initializing and unsealing vault-${name}..."
    mkdir -p ../clusters/$name > /dev/null 2>&1
    vault="docker exec -e VAULT_ADDR=http://localhost:8200 vault-$name vault"
    $vault operator init -key-shares=1 -key-threshold=1 -format=json > ../clusters/$name/init.json
    $vault operator unseal $(jq -r .unseal_keys_b64[0] ../clusters/$name/init.json) > /dev/null 2>&1
done
