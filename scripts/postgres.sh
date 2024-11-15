#!/bin/bash

cd "$(dirname $0)"

POSTGRES_VERSION="16"
POSTGRES_PASSWORD=$(uuidgen)

echo "Creating postgres container..."

# postgres
docker run \
  --name=postgres \
  -p 5432:5432 \
  -e "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" \
  --net="vault-replication-demo_bridge" \
  --detach \
  --rm \
  postgres:$POSTGRES_VERSION-alpine > /dev/null

sleep 1

POSTGRES_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' postgres)

echo "Enabling and configuring database (postgres) secrets engine..."

VAULT_PRIMARY="docker exec -e VAULT_ADDR=http://localhost:8200 -e VAULT_TOKEN=$(jq -r .root_token ../clusters/primary/init.json) vault-primary vault"
VAULT_PERF="docker exec -e VAULT_ADDR=http://localhost:8200 -e VAULT_TOKEN=$(jq -r .token ../clusters/performance/init.json) vault-performance vault"

$VAULT_PRIMARY secrets enable -path=postgres database > /dev/null

$VAULT_PRIMARY write postgres/config/example \
    plugin_name="postgresql-database-plugin" \
    allowed_roles="example" \
    connection_url="postgresql://{{username}}:{{password}}@$POSTGRES_IP:5432/postgres?sslmode=disable" \
    username="postgres" \
    password="$POSTGRES_PASSWORD" > /dev/null

$VAULT_PRIMARY write postgres/roles/example \
    db_name="example" \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="24h" \
    max_ttl="24h" > /dev/null

echo "Generate creds with: read postgres/creds/example"
