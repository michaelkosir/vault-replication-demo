#!/bin/bash

cd "$(dirname $0)"

# init and unseal all the clusters
./init-unseal.sh
sleep 2

# enabling replication wipes the secondary clusters
# and syncs data over. This operation can take a bit
./enable-replication.sh
sleep 3

# since replication wiped the secondary cluster,
# we need to regenerate a root token
./regenerate-root.sh 
sleep 1
