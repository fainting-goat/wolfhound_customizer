#!/usr/bin/env bash

set -euo pipefail

docker-compose down  # Verify environment is fresh

docker-compose run --rm app bash -c "mix do deps.get, deps.compile"
