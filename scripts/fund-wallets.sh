#!/bin/bash
set -euo pipefail

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

# Resolve relative to absolute path
if [[ "$WALLET_PATH" != /* ]]; then
    WALLET_PATH="$PROJECT_ROOT/$WALLET_PATH"
fi

export ANCHOR_WALLET="$WALLET_PATH"

# Ensure wallet exists
if ! [ -f "$WALLET_PATH" ]; then
    echo "❌ Wallet file does not exist at: $WALLET_PATH"
    ls -l "$WALLET_PATH" || echo "(ls failed)"
    exit 1
fi

# Validate wallet
if ! solana address -k "$WALLET_PATH" >/dev/null 2>&1; then
    echo "❌ Wallet is invalid or unreadable"
    exit 1
fi

DEPLOY_PUBKEY=$(solana address -k "$WALLET_PATH")
BALANCE_SOL=$(solana balance -k "$WALLET_PATH" | awk '{print $1}')
REQUIRED_BALANCE=1.5

echo "💼 Checking deploy wallet: $DEPLOY_PUBKEY (Current: ${BALANCE_SOL} SOL)"

# Airdrop if balance is too low
if (( $(echo "$BALANCE_SOL < $REQUIRED_BALANCE" | bc -l) )); then
    echo "🌉 Airdropping 2 SOL to $DEPLOY_PUBKEY..."

    MAX_RETRIES=5
    for ((i=1; i<=MAX_RETRIES; i++)); do
        if solana airdrop 2 "$DEPLOY_PUBKEY"; then
            echo "🎉 Airdrop successful."
            sleep 2
            break
        else
            echo "⚠️ Airdrop attempt $i failed."
            if [[ $i -eq $MAX_RETRIES ]]; then
                echo "❌ Airdrop failed after $MAX_RETRIES attempts."
                if [[ "${CI:-}" == "true" ]]; then
                    exit 1
                else
                    echo "ℹ️ Running locally, continuing despite airdrop failure."
                fi
            else
                echo "⏳ Retrying in 3 seconds..."
                sleep 3
            fi
        fi
    done

    echo "📦 New balance:"
    solana balance -k "$WALLET_PATH"
else
    echo "✅ Wallet already has sufficient balance: ${BALANCE_SOL} SOL"
fi
