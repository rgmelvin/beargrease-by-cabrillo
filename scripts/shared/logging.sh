#!/usr/bin/env bash
# ----------------------------------------------------------------------
# 🐻 logging.sh - Beargrease Shared Logging Functions
# ----------------------------------------------------------------------
# Provides standardized logging functions for all Beargrease scripts.
# Designed for modular sourcing to keep scripts clean and maintainable.
#
# Beargrease Logging Directive (2025-07-10)
# ----------------------------------------------------------------------
#
# Usage:
#   source scripts/shared/logging.sh
#
# Notes:
#   This script is intended to be sourced, not executed directly.
#
# ----------------------------------------------------------------------

# Timestamp function (always prints, no newline)
timestamp() {
    echo -n "$(date '+%Y-%m-%d %H:%M:%S')"
}

# Standard log (no timestamp by default for clarity)
log() {
    echo "$@"
}

# Timestamped log
log_ts() {
    echo "$(timestamp) $@"
}

# Verbose log (prints only if VERBOSE=true)
log_verbose() {
    if [[ "$VERBOSE" == true ]]; then
      log "$@"
    fi
}

# Verbose log with timestamp
log_verbose_ts() {
    if [[ "$VERBOSE" == true ]]; then
      log_ts "$@"
    fi
}

# Multi-line block log (no timestamp to keep clean)
log_block() {
  cat -
}

# Multi-line block log with timestamp prefix on each line
log_block_ts() {
    while IFS= read -r line; do
      log_ts "$line"
    done
}

# Verbose multi-line block log
log_block_verbose() {
    if [[ "$VERBOSE" == true ]]; then
      cat -
    fi
}

# Verbose multi-line block log with timestamp
log_block_verbose_ts() {
    if [[ "$VERBOSE" == true ]]; then
      while IFS= read -r line; do
        log_ts "$line"
      done
    fi
}