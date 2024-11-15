#!/bin/bash

cd "$(dirname $0)"

docker stop postgres > /dev/null 2>&1

docker compose down -v

rm -rf ../clusters/
