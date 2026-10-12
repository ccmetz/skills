#!/bin/bash
set -e

# Run Compose from the project root so it finds the same .env from any directory.
SCRIPT_DIR="$(CDPATH= cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

# Build docker images with build args set
# Usage: ./scripts/build.dev.sh [--no-cache] [--pull]

NO_CACHE=""
PULL=""

for arg in "$@"; do
  case $arg in
    --no-cache)
      NO_CACHE="--no-cache"
      ;;
    --pull)
      PULL="--pull"
      ;;
  esac
done

# Build docker images and set DB UID/GID to match host user in case we are mounting the pg data volume
# to the host machine. LOCAL_UID/GID are used in the application Dockerfile to set permissions of directories
# to the host user.
docker compose --profile dev build $NO_CACHE $PULL --build-arg LOCAL_UID="$(id -u)" --build-arg LOCAL_GID="$(id -g)"
