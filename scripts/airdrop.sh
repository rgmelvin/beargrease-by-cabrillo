#!/bin/bash
set -e

WALLET_ADDRESS=$1

# Validate wallet address input
if [[ -z "$WALLET_ADDRESS" ]]; then
    echo "❌ Error: No wallet address provided."
    echo "Usage: ./scripts/airdrop.sh <WALLET_ADDRESS> [AMOUNT_SOL]"
    exit 1
fi

# 🔁 Interactive prompt for SOL amount with validation
while true; do
    read -r -p "💰 How much SOL to airdrop? (default: 2): " AMOUNT_SOL_RAW
    AMOUNT_SOL="${AMOUNT_SOL_RAW:-2}"
    AMOUNT_SOL="$(echo "$AMOUNT_SOL" | xargs)"

    if [[ "$AMOUNT_SOL" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
        break
    fi

    echo "❌ '$AMOUNT_SOL' is not a valid number."
    echo "💡 Try again with a numeric value like 1, 2.5, or 100"
done

echo "🚁 Airdropping ${AMOUNT_SOL} SOL to wallet: $WALLET_ADDRESS"

# 🧠 Detect if container is running
if docker ps --format '{{.Names}}' | grep -q "^solana-test-vaidator$"; then
    # 🐳 Airdrop via container 
    docker exec solana-test-validator \
        solana airdrop "$AMOUNT_SOL" "$WALLET_ADDRESS" --url http://localhost:8899
else 
    # 💻 Local fallback airdrop
    solana airdrop "$AMOUNT_SOL" "$WALLET_ADDRESS" --url http://localhost:8899
fi

echo "✅ Airdrop complete."