#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BEARGREASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(pwd)"

# Determine program name from Anchor.toml
PROGRAM_NAME=$(grep -A1 '\[programs.localnet\]' "$PROJECT_ROOT/Anchor.toml" | grep -v '\[programs.localnet\]' | cut -d'=' -f1 | xargs)

if [[ -z "$PROGRAM_NAME" ]]; then
    echo "❌ Could not determine program name from Anchor.toml"
    exit 1
fi
# Path to keypair file
KEYPAIR_PATH="$PROJECT_ROOT/target/deploy/${PROGRAM_NAME}-keypair.json"
if [[ ! -f "$KEYPAIR_PATH" ]]; then
    echo "❌ Keypair file not found: $KEYPAIR_PATH"
    exit 1
fi
# Get deployed program ID
PROGRAM_ID=$(solana address -k "$KEYPAIR_PATH")

if [[ -z "$PROGRAM_ID" ]]; then
    echo "❌ Failed to retrieve program ID from keypair"
    exit 1
fi
# 🔁 Patch Anchor.toml with new program ID
echo "✏️ Updating Anchor.toml with program ID: $PROGRAM_ID"
sed -i.bak -E "s/^$PROGRAM_NAME\s*=\s*\".*\"/$PROGRAM_NAME = \"$PROGRAM_ID\"/" "$PROJECT_ROOT/Anchor.toml"

# 🔁 Patch declare_id! in lib.rs
LIB_PATH="$PROJECT_ROOT/programs/$PROGRAM_NAME/src/lib.rs"
if [[ -f "$LIB_PATH" ]]; then
    echo "✏️ Updating declare_id! in lib.rs"
    sed -i.bak -E "s/^declare_id!\(\".*\"\);/declare_id!(\"$PROGRAM_ID\");/" "$LIB_PATH"
else
    echo "⚠️ Could not find lib.rs at $LIB_PATH. Skipping declare_id! update."
fi
echo "✅ Program ID update complete: $PROGRAM_ID"