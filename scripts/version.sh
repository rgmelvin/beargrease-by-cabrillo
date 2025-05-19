#!/bin/bash
set -euo pipefail

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ Beargrease Version Info                 ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

VERSION="v1.0.0"
PROJECT_NAME="Beargrease"

# Optional: path to changelog
CHANGELOG_FILE="$(dirname "$0")/../CHANGELOG.md"

# Print version banner
echo "🔖 $PROJECT_NAME $vERSION"

# Print changelog if available
if [[ -f "$CHANGELOG_FILE" ]]; then
    echo "📝 Latest changes:"
    head -n 10 "$CHANGELOG_FILE" | sed 's/^/  /'
else
    echo "⚠️ No CHANGELOG.md found."
fi