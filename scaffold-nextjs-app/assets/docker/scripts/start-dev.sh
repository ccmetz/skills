#!/bin/bash
set -e

# cd to the directory of this script
# Run Compose from the project root so it finds the same .env from any directory.
SCRIPT_DIR="$(CDPATH= cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

# Set DB UID/GID to match host user in case we are mounting the pg data volume
# to the host machine.
DB_UID=$(id -u)
DB_GID=$(id -g)
export DB_UID DB_GID

# Run local dev with environment file to ensure docker compose can take the desired port
"$SCRIPT_DIR/build-dev.sh" "$@"
docker compose --profile dev up
