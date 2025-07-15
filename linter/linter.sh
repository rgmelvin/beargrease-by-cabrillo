#!/usr/bin/env bash
set -euo pipefail

# ----------------------------------------------------------------------
# 🧪 Beargrease Linter Orchestrator
# ----------------------------------------------------------------------
#
# Runs all Beargrease linter rules against a target script.
#
# Maintainer: Cabrillo Labs, Ltd.2025
# License: MIT
# Version: 0.1.0 (MVP realease)
#
# ----------------------------------------------------------------------
#
# Exit Code Reference:
#   0   - Success
#   81  - Missing target script argument
#   82  - Target script not found or not readable
#   83  - Linter rule failure (non-aero exit from rule)
#
# ----------------------------------------------------------------------
#
# Usage:
#   ./linter.sh <path-to-target-script>
#
# Options:
#   -h, --help   Show this help message.
#
# ----------------------------------------------------------------------

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/linter-env.sh"

# ----------------------------------------------------------------------
# 📝 Help and Usage
# ----------------------------------------------------------------------

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  log_block <<EOF
Beargrease Linter

Usage:
   ./linter.sh <path-to-target-script>

Runs Beargrease shell script linting rules on the specified script.
EOF
  exit 0
fi

# ----------------------------------------------------------------------
# 🗂️ Argument Check
# ----------------------------------------------------------------------

if [[ $# -ne 1 ]]; then
  log_ts "❌ No target script specified."
  log_block <<EOF
💡 NEXT STEPS:
  1. Provide the path to the script you want to lint.

     Example;

        ./linter.sh /path/to/my-script.sh
EOF
  exit 81
fi

TARGET_SCRIPT="$1"

if [[ ! -r "$TARGET_SCRIPT" ]]; then
  log_ts "❌ Target script not found or not readable: $TARGET_SCRIPT"
  exit 82
fi

log_ts "🚦 Starting Beargrease Linter on: $TARGET_SCRIPT"

# ----------------------------------------------------------------------
# 🔍 Run All Rule Scripts
# ----------------------------------------------------------------------

FAILED=false

RULES=(
    "shebang.rule"
    "header-block.rule"
    "shared-sourcing.rule"
    "cli-parsing.rule"
    "constants.rule"
    "initialization.rule"
    "procedure-steps.rule"
    "ci-guard.rule"
    "dependency-check.rule"
    "exit-codes.rule"
    "completion.rule"
)

for RULE in "${RULES[@]}"; do
  export TARGET_FILE="$TARGET_SCRIPT"

  case "$RULE" in
    "cli-parsing.rule" | "constants.rule" | "initialization.rule" | "procedure-steps.rule")
      log_ts "⚙️ [$RULE] Placeholder only. This check will be implemented in a future version."
      ;;
    *)
      log_ts "▶️ Running $RULE"
      if ! bash "$LINTER_DIR/rules/$RULE"; then
       FAILED=true
      fi
      ;;
  esac
done

# ----------------------------------------------------------------------
# ✅ Completion
# ----------------------------------------------------------------------

if [[ "$FAILED" == true ]]; then
  log_ts "❌ Linting failed. One or more rules did not pass."
  log_block <<EOF
💡 NEXT STEPS:
  1. Review the output above. Each failed rule has provided guidance.

  2. Fix all issues before re-running the linter.

  3. Refer to the Beargrease Shell Script Protocol and Style Guide for details.
EOF
  exit 83
fi
log_ts "✅ [linter.sh] completed successfully."