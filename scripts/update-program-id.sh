#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(pwd)"

ANCHOR_TOML="$PROJECT_ROOT/Anchor.toml"

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ Step 1: Determine program name from Anchor.toml              ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
PROGRAM_NAME=$(grep -A1 '^\[programs\.localnet\]' "$ANCHOR_TOML" | grep -v '\[' | cut -d'=' -f1 | xargs)

if [[ -z "$PROGRAM_NAME" ]]; then
  echo "❌ Could not determine program name from [programs.localnet] in Anchor.toml"
  exit 1
fi

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ Step 2: Resolve deployed program ID                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
KEYPAIR_PATH="$PROJECT_ROOT/target/deploy/${PROGRAM_NAME}-keypair.json"

if [[ ! -f "$KEYPAIR_PATH" ]]; then
  echo "❌ Keypair file not found: $KEYPAIR_PATH"
  exit 1
fi

PROGRAM_ID=$(solana address -k "$KEYPAIR_PATH")

if [[ -z "$PROGRAM_ID" ]]; then
  echo "❌ Failed to retrieve program ID from keypair file"
  exit 1
fi

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ Step 3: Patch Anchor.toml                                    ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo "✏️ Updating Anchor.toml with program ID: $PROGRAM_ID"
sed -i.bak -E "s|^$PROGRAM_NAME\s*=\s*\"[^\"]+\"|$PROGRAM_NAME = \"$PROGRAM_ID\"|" "$ANCHOR_TOML"

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ Step 4: Patch declare_id! in lib.rs                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
LIB_RS_PATH="$PROJECT_ROOT/programs/$PROGRAM_NAME/src/lib.rs"

if [[ -f "$LIB_RS_PATH" ]]; then
  echo "✏️ Updating declare_id! in lib.rs"
  sed -i.bak -E "s|^declare_id!\(\"[^\"]+\"\);|declare_id!(\"$PROGRAM_ID\");|" "$LIB_RS_PATH"
else
  echo "⚠️ lib.rs not found at $LIB_RS_PATH. Skipping declare_id! update."
fi

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ Step 5: Patch IDL metadata.address for Anchor compatibility  ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
IDL_PATH="$PROJECT_ROOT/target/idl/${PROGRAM_NAME}.json"

if [[ -f "$IDL_PATH" ]]; then
  echo "✏️ Updating metadata.address in IDL: $IDL_PATH"
  tmpfile=$(mktemp)
  jq --arg addr "$PROGRAM_ID" '.metadata.address = $addr' "$IDL_PATH" > "$tmpfile" && mv "$tmpfile" "$IDL_PATH"
else
  echo "⚠️ IDL not found at $IDL_PATH. Skipping metadata.address update."
fi

echo "✅ Program ID update complete: $PROGRAM_ID"
