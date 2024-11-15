#!/bin/bash

VAULT_ADDRESS="-e VAULT_ADDR=http://localhost:8200"

VAULT_PRIMARY_TOKEN="-e VAULT_TOKEN=$(jq -r .root_token ./clusters/primary/init.json)"
VAULT_DR_TOKEN="-e VAULT_TOKEN=$(jq -r .root_token ./clusters/dr/init.json)"
VAULT_PERFORMANCE_TOKEN="-e VAULT_TOKEN=$(jq -r .root_token ./clusters/performance/init.json)"

alias v1="docker exec $VAULT_ADDRESS $VAULT_PRIMARY_TOKEN vault-primary vault"
alias v2="docker exec $VAULT_ADDRESS $VAULT_DR_TOKEN vault-dr vault"
alias v3="docker exec $VAULT_ADDRESS $VAULT_PERFORMANCE_TOKEN vault-performance vault"
