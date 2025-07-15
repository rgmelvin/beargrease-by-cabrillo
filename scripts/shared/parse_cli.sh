#!/usr/bin/env bash
# ----------------------------------------------------------------------
# 🐻 parse_cli.sh - Beargrease Shared CLI Flag Parsing
# ----------------------------------------------------------------------
# Provides a standard function to parse common CLI flags (--verbose, --help, non-interactive).
# Automatically builds ARGS array of positional parameters excluding standard flags.
# Call parse_standard_cli_flags "$@" after sourcing this script.
# ----------------------------------------------------------------------
#
# Usage:
#   source scripts/shared/logging.sh
#   source scripts/shared/parse_cli.sh
#   parse_standard_cli_flags "$@"
#
# Notes:
#   Designed for standard Beargrease scripts that source logging.sh.
#   After calling, use "${ARGS[@]}" to access positional arguments.
#
# ----------------------------------------------------------------------
#
# Exit Code Reference:
#  0    - Success or --help displayed
#  1    - Unknown option encountered
#
# ----------------------------------------------------------------------

VERBOSE=false
NON_INTERACTIVE=false
ARGS=()

parse_standard_cli_flags() {
  for arg in "$@"; do
    case "$arg" in
      --verbose)
        VERBOSE=true
        ;;
      --non-interactive)
        NON_INTERACTIVE=true
        ;;
      --help)
        grep '^#' "$0" | sed 's/^# \{0,1\}//'
        exit 0
        ;;
      -*)
        # Uses logging.sh functions if sourced, else fallback echo
        if command -v log_ts >/dev/null 2>&1; then
          log_ts "❌ Unknown option: $arg"
          log "Use --help to see available options."
        else
          echo "❌ Unknown option: $arg"
          echo "Use --help to see available options."
        fi
        exit 1
        ;;
      *)
        ARGS+=("$arg")
        ;;
    esac
  done

  export VERBOSE NON_INTERACTIVE ARGS
}