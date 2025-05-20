#!/bin/bash

set -euo pipefail

echo "🐻 [init-wallet.sh] Checking for BEARGREASE_WALLET_SECRET..."

if [ -n "${BEARGREASE_WALLET_SECRET:-}" ]; then
    echo "🔐 Decoding wallet from BEARGREASE_WALLET_SECRET..."
    if [ ! -d /wallet ]; then
        echo "❌ /wallet does not exist. Did the Docker volume fail to mount?"
        exit 1
    fi
    echo "$BEARGREASE_WALLET_SECRET" | base64 -d > /wallet/id.json
    chmod 600 /wallet/id.json
    export ANCHOR_WALLET="/wallet/id.json"
    echo "✅ Wallet written to: $ANCHOR_WALLET"
else
    echo "ℹ️ No wallet secret provided. Skipping wallet injection."
fi