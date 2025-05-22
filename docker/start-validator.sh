#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
COMPOSE_FILE="$PROJECT_ROOT/docker/docker-compose.yml"
WAIT_SCRIPT="$PROJECT_ROOT/scripts/wait-for-validator.sh"

echo "🛑 Shutting down and removing any existing validator container..."
docker compose -f "$COMPOSE_FILE" down --remove-orphans

echo "🚀 Starting new validator using docker compose..."
docker compose -f "$COMPOSE_FILE" up -d

echo "⏳ Waiting for validator to pass healthcheck..."
"$WAIT_SCRIPT"