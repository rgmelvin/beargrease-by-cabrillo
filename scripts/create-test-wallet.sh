#!/bin/bash

set -e

WALLETS_DIR=".ledger/wallets"
mkdir -p "$WALLETS_DIR"

read -p "🔖 Enter a name for your test wallet (e.g. alice, test-user): " WALLET_NAME

KEYPAIR_FILE="$WALLETS_DIR/$WALLET_NAME.json"

if [[ -f "$KEYPAIR_FILE" ]]; then
    echo "⚠️ Wallet '$WALLET_NAME' already exists at $KEYPAIR_FILE"
    read -p "❓ Overwrite? [y/N]: " CONFIRM
    if [[ "$CONFIRM" != "y" ]]; then
        echo "❌ Aborted."
        exit 1
    fi
    rm -f "$KEYPAIR_FILE"
fi

# Check if solana-test-validator is running and decide whre to generate keypair
if docker ps --format '{{.Names}}' | grep -q "^solana-test-validator$"; then

    echo "🔐 Generating new keypair inside container..."
    docker exec solana-test-validator solana-keygen new --no-bip39-passphrase --outfile /root/.config/solana/$WALLET_NAME.json --force >/dev/null

    docker cp solana-test-validator:/root/.config/solana/$WALLET_NAME.json "$KEYPAIR_FILE"

    PUBKEY=$(docker exec solana-test-validator solana-keygen pubkey /root/.config/solana/$WALLET_NAME.json)
else
    echo "⚠️ Container not running. Falling back to local solana-keygen..."
    solana-keygen new --no-bip39-passphrase --outfile "$KEYPAIR_FILE" --force >/dev/null
    PUBKEY=$(solana-keygen pubkey "$KEYPAIR_FILE")
fi

echo "📬 Public Key: $PUBKEY"

read -r -p "💰 How much SOL to airdrop? (default: 2): " AMOUNT_SOL
AMOUNT_SOL=${AMOUNT_SOL:-2}

echo "🚁 Airdropping $AMOUNT_SOL SOL to wallet: $PUBKEY"
$(dirname "$0")/airdrop.sh "$PUBKEY" "$AMOUNT_SOL"

# Step: write .env
ENV_FILE=".env"
echo "📝 Writing wallet environment to $ENF_FILE..."

echo "BG_WALLET_NAME=$WALLET_NAME" > "$ENV_FILE"
echo "ANCHOR_WALLET=$(pwd)/$KEYPAIR_FILE" >> "$ENV_FILE"
echo "ANCHOR_PROVIDER_URL=http://localhost:8899" >> "$ENV_FILE"

echo ""
echo "✅ Wallet '$WALLET_NAME' created successfully."
echo "🔑 Path: $KEYPAIR_FILE"
echo "📬 Public Key: $PUBKEY"
echo "📁 .env configured for Anchor tests."