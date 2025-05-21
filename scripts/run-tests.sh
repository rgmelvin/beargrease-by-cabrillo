#!/usr/bin/env bash
set -euo pipefail

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ BEARGREASE v1.0.26                                           ┃
# ┃ Solana Docker Validator Test Harness                         ┃
# ┃ Maintainer: Cabrillo Labs, Ltd.                              ┃
# ┃ License: MIT                                                 ┃
# ┃ Homepage: https://github.com/rgmelvin/beargrease-by-cabrillo ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

echo "🐻 Beargrease Version: v1.0.26"

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
BEARGREASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(pwd)"

echo "🐻 Beargrease Test Harness: Start → Validate → Test → Shutdown"

# ----------------------------------------------------------------------
# Step 1: Start Validator
# ----------------------------------------------------------------------
echo "🔧 Launching Solana validator container via Docker..."
echo "🔧 Mounting wallet volume for CI..."
export BEARGREASE_WALLET_MOUNT="$(realpath "$PROJECT_ROOT/.wallet-volume")"
export BEARGREASE_WALLET_SECRET="${BEARGREASE_WALLET_SECRET:-}"

BEARGREASE_WALLET_SECRET="$BEARGREASE_WALLET_SECRET" docker run \
  --rm \
  -d \
  --name solana-test-validator \
  -p 8899:8899 \
  -p 8900:8900 \
  -v "$PROJECT_ROOT/ledger:/root/ledger" \
  -v "$BEARGREASE_WALLET_MOUNT:/wallet" \
  -e BEARGREASE_WALLET_SECRET="$BEARGREASE_WALLET_SECRET" \
  solanalabs/solana:v1.18.11 \
  solana-test-validator \
    --ledger /root/ledger \
    --reset \
    --quiet \
    --no-untrusted-rpc \
    --rpc-port 8899 \
    --allow-unlimited-airdrops


# ----------------------------------------------------------------------
# Step 2: Wait for health
# ----------------------------------------------------------------------
echo "⏳ Waiting for validator readiness..."
"$BEARGREASE_ROOT/scripts/wait-for-validator.sh"
echo "✅ Validator is healthy. Proceeding with tests..."

# ----------------------------------------------------------------------
# Step 2.5 Decode wallet if runnin in CI
# ----------------------------------------------------------------------
"$BEARGREASE_ROOT/scripts/init-wallet.sh"

# ----------------------------------------------------------------------
# Step 3: Ensure deploy wallet is funded
# ----------------------------------------------------------------------
"$BEARGREASE_ROOT/scripts/fund-wallets.sh"

#----------------------------------------------------------------------
# Step 4: Set ANCHOR_WALLET + PROVIDER_URL
# ----------------------------------------------------------------------
cd "$PROJECT_ROOT"

if [ -z "${ANCHOR_WALLET:-}" ]; then
  if [ -f ".ledger/wallets/test-user.json" ]; then
    export ANCHOR_WALLET="$PROJECT_ROOT/.ledger/wallets/test-user.json"
    echo "💼 No ANCHOR_WALLET set. Using default: $ANCHOR_WALLET"
  else
    echo "❌ No ANCHOR_WALLET  set and no fallback wallet found at .ledger/wallets/test-user.json"
    exit 1
  fi
else
  echo "💼 ANCHOR_WALLET is set to: $ANCHOR_WALLET"
fi

export ANCHOR_PROVIDER_URL="http://localhost:8899"
echo "🔌 Anchor will use external validator at: $ANCHOR_PROVIDER_URL"

# ----------------------------------------------------------------------
# Step 5: Build, Deploy, and Update Program ID
# ----------------------------------------------------------------------
echo "🔨 Building Anchor program..."
echo "🚀 Running: anchor build"
anchor build

# 🚀 Deploying program to Docker-based Solana validator
# ----------------------------------------------------------------------
# IMPORTANT:  Although the script informs "local validator", it is actually deploying 
# to the Docker container started via Beargrease (solana-test-validator).
# We ensure this by explicitly setting ANCHOR_PROVIDER_URL to:
# -> http://localhost:8899
# This tells Anchor to send all deploy and test traffic to the Docker instance,
# NOT to devnet/mainnet or any other cluster configured in Anchor.toml.
# ----------------------------------------------------------------------

echo "🚀 Deploying program to local validator"
echo "🚀 Running: anchor deploy"
anchor deploy

echo "📝 Updating Anchor.toml and lib.rs with deployed program ID..."
"$BEARGREASE_ROOT/scripts/update-program-id.sh"

# 🔁 Regenerate client bindings after program ID patch (in CI only)
if [[ "${CI:-}" == "true" ]]; then
  echo "📥 Regenerating client bindings from updated IDL..."

  PROGRAM_NAME=$(grep -A1 '\[programs.localnet\]' Anchor.toml | grep -v '\[' | cut -d= -f1 | xargs)
  PROGRAM_ID=$(grep "$PROGRAM_NAME" Anchor.toml | cut -d'"' -f2)

  echo "🧬 Generating fresh local IDL..."
  anchor idl parse > target/idl/${PROGRAM_NAME}.json

  anchor client gen target/idl/${PROGRAM_NAME}.json \
    --program-id "$PROGRAM_ID" \
    --output target/types/${PROGRAM_NAME}.ts \
    --provider.wallet "$ANCHOR_WALLET"

  echo "🔄 Cleaning and rebuilding after IDL + binding regeneration..."
  anchor clean
  anchor build
fi

# ---------------------------------------------------------------
# Step 6: Determine and run test strategy
# ---------------------------------------------------------------
if [ "${TEST_RUNNER:-}" = "anchor" ]; then
  echo "🔹 TEST_RUNNER=anchor specified. Running anchor test..."
  anchor test --skip-local-validator

elif [ "${TEST_RUNNER:-}" = "yarn" ]; then
  echo "🔹 TEST_RUNNER=yarn specified. Running yarn test..."
  yarn test

elif [ -f "package.json" ] && [ "$(jq -r '.scripts.test // empty' < package.json)" != "" ]; then
  echo "🔹 Detected test script in package.json. Running yarn test..."
  yarn test

else
  echo "🔹 Defaulting to anchor test..."
  anchor test --skip-local-validator
fi

# ---------------------------------------------------------------
# Step 7: Shut down validator
# ---------------------------------------------------------------
echo "🚹 Shutting down validator..."
"$BEARGREASE_ROOT/docker/shutdown-validator.sh"

echo "$(tput setaf 2)✅ Beargrease test run complete.$(tput sgr0)"