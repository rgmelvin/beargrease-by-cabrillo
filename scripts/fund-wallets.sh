#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(pwd)"

# Extract wallet path from Anchor.toml
WALLET_PATH=$(grep -E '^wallet\s*=\s*"' "$PROJECT_ROOT/Anchor.toml" | sed -E 's/wallet\s*=\s*"(.*)"/\1/')

if [[ -z "$WALLET_PATH" ]]; then
    echo "❌ No wallet found in Anchor.toml. Cannot fund deploy authority."
    exit 1
fi

# Resolve to absolute path if relative
if [[ "$WALLET_PATH" != /* ]]; then
    WALLET_PATH="$PROJECT_ROOT/$WALLET_PATH"
fi

echo "💼 Checking deploy wallet: $WALLET_PATH"
DEPLOY_PUBKEY=$(solana address -k "$WALLET_PATH")
BALANCE_SOL=$(solana balance -k "$WALLET_PATH" | awk '{print $1}')
REQUIRED_BALANCE=1.5

# ✅ FIXED LINE — tested and safe
if [ "$(echo "$BALANCE_SOL < $REQUIRED_BALANCE" | bc -l)" = "1" ]; then
    echo "🌉 Airdropping SOL to deploy wallet: $DEPLOY_PUBKEY (current: ${BALANCE_SOL} SOL)"
    solana airdrop 2 "$DEPLOY_PUBKEY"
    sleep 2
    echo "🎉 Done. New balance:"
    solana balance -k "$WALLET_PATH"
else
    echo "✅ Wallet already has sufficient funds: ${BALANCE_SOL} SOL"
fi
