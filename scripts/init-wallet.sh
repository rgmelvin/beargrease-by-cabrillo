#!/bin/bash
set -euo pipefail

echo "🐻 [init-wallet.sh] Initializing Beargrease Wallet..."

if [ -n "${CI:-}" ]; then
    echo "👷 Detected CI mode (CI=true)"
else
    echo "🧑‍💻 Running in local mode (CI not set)"
fi

if [ -n "${BEARGREASE_WALLET_SECRET:-}" ]; then
    echo "🔐 Decoding wallet from BEARGREASE_WALLET_SECRET..."
    mkdir -p .wallet
    echo "$BEARGREASE_WALLET_SECRET" | base64 -d > .wallet/id.json
    chmod 600 .wallet/id.json
    export ANCHOR_WALLET=".wallet/id.json"
    export BEARGREASE_WALLET_WAS_INJECTED=true
    echo "true" > .wallet/_was_injected
    echo "✅ Wallet written to: $ANCHOR_WALLET"
else
    echo "ℹ️ No wallet secret provided. Skipping wallet injection."
    echo "📂 Will fall back to local wallet detection in run-tests.sh"
fi
