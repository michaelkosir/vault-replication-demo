#!/bin/bash

cd "$(dirname $0)"

echo "regenerating root token for performance cluster..."

VAULT_ADDRESS="-e VAULT_ADDR=http://localhost:8200"

VAULT_PERF="docker exec $VAULT_ADDRESS -e VAULT_TOKEN=$(jq -r .root_token ../clusters/performance/init.json) vault-performance vault"

init=$($VAULT_PERF operator generate-root -format=json -init)

otp=$(jq -r .otp <<< $init)

nonce=$(jq -r .nonce <<< $init)

unseal_key=$(jq -r .unseal_keys_b64[0] ../clusters/primary/init.json)

encoded_token=$($VAULT_PERF operator generate-root -format=json -nonce=$nonce $unseal_key)

token=$($VAULT_PERF operator generate-root -format=json -decode=$(jq -r .encoded_token <<< $encoded_token) -otp=$otp | jq -r .token)

jq ".root_token = \"$token\"" ../clusters/performance/init.json > ../clusters/performance/tmp.json
mv ../clusters/performance/tmp.json ../clusters/performance/init.json
