#!/bin/bash
set -e

RPC_URL="http://localhost:8899"
MAX_RETRIES=60
SLEEP_INTERVAL=0.5

echo "⏳ Waiting for Solana validator at $RPC_URL ..."

sleep 2

for ((i=1; i<=MAX_RETRIES;i++)); do
  RESPONSE=$(curl --silent --show-error \
    --header "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0", "id":1, "method":"getHealth"}' \
    "$RPC_URL")

  echo "🔍 Attempt $i/$MAX_RETRIES - Raw response: $RESPONSE"

  if echo "$RESPONSE" \ grep -q '"result":"ok"'; then
    echo "✅ Validator is healthy (attempt $i/$MAX_RETRIES)"
    exit 0
  fi
  if curl --silent --fail "$RPC_URL" >/dev/null; then
    echo "⚠️ Validator RPC responding (not healthy yet) - continuing anyway"
    exit 0
  fi

  sleep "$SLEEP_INTERVAL"
done

echo "❌ Validator did not become healthy after  $MAX_RETRIES attempts."
exit 1