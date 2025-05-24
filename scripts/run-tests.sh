#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$(pwd)}"


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ BEARGREASE v1.0.0                                            ┃
# ┃ Solana Docker Validator Test Harness                         ┃
# ┃ Maintainer: Cabrillo Labs, Ltd.                              ┃
# ┃ License: MIT                                                 ┃
# ┃ Homepage: https://github.com/rgmelvin/beargrease-by-cabrillo ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

echo "🐻 Beargrease Version: v1.0.0"

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
BEARGREASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# already declared

echo "🐻 Beargrease Test Harness: Start → Validate → Test → Shutdown"

# ----------------------------------------------------------------------
# Step 1: Start Validator
# ----------------------------------------------------------------------
echo "🔧 Launching Solana validator container via Docker..."
"$BEARGREASE_ROOT/docker/start-validator.sh"

# ----------------------------------------------------------------------
# Step 2: Wait for health
# ----------------------------------------------------------------------
echo "⏳ Waiting for validator readiness..."
"$BEARGREASE_ROOT/scripts/wait-for-validator.sh"
echo "✅ Validator is healthy. Proceeding with tests..."

# Step 2.5: Decode CI Wallet secret before wallet selection.
"$BEARGREASE_ROOT/scripts/init-wallet.sh"

#----------------------------------------------------------------------
# Step 3A: Set ANCHOR_WALLET + PROVIDER_URL
# ----------------------------------------------------------------------
cd "$PROJECT_ROOT"

if [ -z "${ANCHOR_WALLET:-}" ]; then
  if [ -f ".wallet/id.json" ]; then
    export ANCHOR_WALLET="$PROJECT_ROOT/.wallet/id.json"
    echo "💼 Using injected or CI wallet: $ANCHOR_WALLET"
  elif [ -f ".ledger/wallets/test-user.json" ]; then
    export ANCHOR_WALLET="$PROJECT_ROOT/.ledger/wallets/test-user.json"
    echo "💼 Using local test wallet: $ANCHOR_WALLET"
  else
    echo "❌ No ANCHOR_WALLET set and no wallet found at .wallet/id.json or .ledger/wallets/test-user.json"
    exit 1
  fi
else
  echo "💼 ANCHOR_WALLET is set to: $ANCHOR_WALLET"
fi

# Ensure Anchor.toml reflects the correct wallet
ANCHOR_TOML_PATH="$PROJECT_ROOT/Anchor.toml"
if grep -qE '^wallet\s*=' "$ANCHOR_TOML_PATH"; then
  sed -i.bak -E "s|^wallet\s*=.*|wallet = \"${ANCHOR_WALLET}\"|" "$ANCHOR_TOML_PATH"
else
  echo "wallet = \"${ANCHOR_WALLET}\"" >> "$ANCHOR_TOML_PATH"
fi
echo "📝 Updated Anchor.toml to use wallet: $ANCHOR_WALLET"

export ANCHOR_PROVIDER_URL="http://localhost:8899"
echo "🔌 Anchor will use external validator at: $ANCHOR_PROVIDER_URL"


# ----------------------------------------------------------------------
# Step 3: Ensure deploy wallet is funded
# ----------------------------------------------------------------------
"$BEARGREASE_ROOT/scripts/fund-wallets.sh"



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

echo "🔁 Rebuilding after deploy to ensure fresh IDL output..."
anchor build

echo "📝 Updating Anchor.toml, lib.rs, and IDL metadata.address..."
"$BEARGREASE_ROOT/scripts/update-program-id.sh"

echo "🕒 Sleeping 10s to allow validator to begin indexing..."
sleep 10

# 📛 Determine program name again for confirmation step
PROGRAM_NAME=$(grep -A1 '\[programs.localnet\]' "$ANCHOR_TOML_PATH" | grep -v '\[programs.localnet\]' | cut -d'=' -f1 | xargs)

if [[ -z "$PROGRAM_NAME" ]]; then
  echo "❌ Could not determine program name from Anchor.toml for verification step"
  exit 1
fi

# 📦 Confirm program ID is embedded in rebuilt IDL
IDL_PATH="$PROJECT_ROOT/target/idl/${PROGRAM_NAME}.json"
EMBEDDED_ID=$(jq -r '.metadata.address // empty' "$IDL_PATH")

if [[ -z "$EMBEDDED_ID" ]]; then
  echo "❌ IDL metadata.address not set in: $IDL_PATH"
  exit 1
else
  echo "📦 Confirmed: Rebuilt IDL contains program ID: $EMBEDDED_ID"
fi

# 🕓 Wait for program to be indexed by validator before testing
echo "⏳ Waiting for validator to recognize deployed program ID..."
RETRIES=60
SLEEP=0.5
for i in $(seq 1 $RETRIES); do
  if solana program show "$EMBEDDED_ID" > /dev/null 2>&1; then
    echo "✅ Validator recognizes program ID: $EMBEDDED_ID"
    break
  else
    echo "⏳ Still waiting for validator to index program... ($i/$RETRIES)"
    sleep $SLEEP
  fi
done

if ! solana program show "$EMBEDDED_ID" > /dev/null 2>&1; then
  echo "⚠️ WARNING: Validator did not confirm program indexing. Proceeding anyway..."
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

# ----------------------------------------------------------------------
# Step 8: CI Wallet Cleanup
# ----------------------------------------------------------------------
if [ -f ".wallet/_was_injected" ]; then
  echo "🧹 Cleaning up injected wallet..."
  rm -f .wallet/id.json .wallet/_was_injected
  echo "🧼 Injected wallet file removed."
fi

echo "$(tput setaf 2)✅ Beargrease test run complete.$(tput sgr0)"