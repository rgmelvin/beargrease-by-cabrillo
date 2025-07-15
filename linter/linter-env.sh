#!/usr/bin/env bash
set -euo pipefail

# ----------------------------------------------------------------------
# 🧪 Beargrease Linter Environment Loader
# ----------------------------------------------------------------------
#
# Sets up shared environment variables and logging for Beargrease linter rules.
# All linter rule scripts source this file to ensure consistent paths and functions.
#
# Maintainer: Cabrillo Labs, Ltd. 2025
# License: MIT
# Version: 0.1.0
#
# ----------------------------------------------------------------------
#
# Exit Code Reference:
#   0   - Success (environment loaded)
#
# ----------------------------------------------------------------------
#
# Usage:
#   source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/linter-env.sh"
#
# Options:
#   None.
#
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# 📁 Environment Paths
# ----------------------------------------------------------------------

LINTER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$LINTER_DIR/.." && pwd)"
SHARED_DIR="$ROOT_DIR/scripts/shared"

# ----------------------------------------------------------------------
# 📦 Load Shared Modules
# ----------------------------------------------------------------------

source "$SHARED_DIR/logging.sh"

# ----------------------------------------------------------------------
# ✅ Environment Loaded
# ----------------------------------------------------------------------