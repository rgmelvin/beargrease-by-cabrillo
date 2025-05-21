#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(pwd)"

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ FUND-WALLETS.SH (Beargrease Utility)                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

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

export ANCHOR_WALLET="$WALLET_PATH"

# Validate Solana CLI
if ! command -v solana >/dev/null 2>&1; then
    echo "❌ solana CLI is not installed or not in PATH"
    exit 1
fi

if ! [ -f "$WALLET_PATH" ]; then
    echo "❌ Wallet file does not exist at: $WALLET_PATH"
    ls -l "$WALLET_PATH" || echo "(ls failed)"
    exit 1
fi

if ! solana address -k "$WALLET_PATH" >/dev/null 2>&1; then
    echo "❌ Wallet file is invalid or unreadable by solana CLI"
    exit 1
fi

DEPLOY_PUBKEY=$(solana address -k "$WALLET_PATH")
REQUIRED_BALANCE=1.5

# Get current balance from host CLI (still valid)
BALANCE_SOL=$(solana balance -k "$WALLET_PATH" | awk '{print $1}')
echo "💼 Checking deploy wallet: $DEPLOY_PUBKEY (Current: $BALANCE_SOL SOL)"

# Only airdrop if needed
if [ "$(echo "$BALANCE_SOL < $REQUIRED_BALANCE" | bc -l)" = "1" ]; then
    echo "🌉 Airdropping 2 SOL to $DEPLOY_PUBKEY..."

    for attempt in {1..5}; do
        echo "🔁 Airdrop attempt $attempt..."
        if docker exec solana-test-validator solana airdrop 2 "$DEPLOY_PUBKEY"; then
            echo "🎉 Airdrop successful inside container."
            sleep 2
            docker exec solana-test-validator solana balance "$DEPLOY_PUBKEY"
            break
        else
            echo "⚠️ Airdrop attempt $attempt failed."
            if [ "$attempt" -lt 5 ]; then
                echo "⏳ Retrying in 3 seconds..."
                sleep 3
            else
                echo "❌ Airdrop failed after 5 attempts."
                exit 1
            fi
        fi
    done
else
    echo "✅ Wallet already has sufficient funds: ${BALANCE_SOL} SOL"
fi
