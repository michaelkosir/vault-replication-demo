#!/bin/bash

cd "$(dirname $0)"

VAULT_ADDRESS="-e VAULT_ADDR=http://localhost:8200"

# configure replication
declare -a arr=("dr" "performance")

for name in "${arr[@]}"; do
    echo "configuring replication for vault-${name}..."

    primary="docker exec $VAULT_ADDRESS -e VAULT_TOKEN=$(jq -r .root_token ../clusters/primary/init.json) vault-primary vault"
    secondary="docker exec $VAULT_ADDRESS -e VAULT_TOKEN=$(jq -r .root_token ../clusters/$name/init.json) vault-$name vault"

    $primary write -f sys/replication/$name/primary/enable > /dev/null 2>&1
    sleep 1
    token=$($primary write -field=wrapping_token sys/replication/$name/primary/secondary-token id="${name}-secondary")

    $secondary write sys/replication/$name/secondary/enable token=$token > /dev/null 2>&1
done
