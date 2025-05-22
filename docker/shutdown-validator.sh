#!/bin/bash
set -e

# Get the absolute path of the directory this script lives in
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yml"
LEDGER_dIR="$SCRIPT_DIR/ledger"
CONTAINER_NAME="solana-test-validator"

echo "🛑 Attempting to shut down validator conatainer.."

# Graceful shutdown if running
if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    docker compose -f "$COMPOSE_FILE" down --remove-orphans
    echo "✅ Validator container stopped and removed via docker compose."
else
    echo "⚠️ Validator container '$CONTAINER_NAME' not running."
fi

# Clean up the ledger directory if it exists
LEDGER_DIR="./docker/ledger"
if [ -d "$LEDGER_DIR" ]; then
    echo "🧹 Cleaning up ledger directory at $LEDGER_DIR..."
    rm -rf "$LEDGER_DIR"
    echo "✅ Ledger directory cleaned."
fi

echo "🧼 Cleanup complete."