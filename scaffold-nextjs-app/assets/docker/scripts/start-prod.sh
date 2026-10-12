#!/bin/bash
set -e

# Run Compose from the project root so it finds the same .env from any directory.
SCRIPT_DIR="$(CDPATH= cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

docker compose --profile prod up --build
