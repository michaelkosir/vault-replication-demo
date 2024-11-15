# Vault Enterprise Replication Demo

This repository will spin up three Vault clusters, and configure them together using Enterprise Replication. This is helpful when performing demos, practicing failovers, or debugging purposes with Vault Enterprise Replication.

# Usage
### Settings
A Vault Enterprise license is required for this demo. Add the license in the `.env` file under `VAULT_LICENSE`. You can also select a specific version of Vault using `VAULT_VERSION`.
```shell
vim .env
```

### Vault
Create the Vault clusters in Docker. Enable and configure enterprise replication with the included scripts.
```shell
docker compose up -d

# all in one setup
./scripts/setup.sh

# source the aliases
source ./scripts/aliases.sh

# now interact with the clusters
#  v1 - primary
#  v2 - dr
#  v3 - performance
v1 secrets list 
v2 status
v3 secrets list
```

### Postgres
If you want to add a Postgres database and configure it with Vault, run the `postgres.sh` script.
```shell
./scripts/postgres.sh
```

### Cleanup
Stop vault clusters, stop postgres and remove init files.
```shell
./scripts/cleanup.sh
```
