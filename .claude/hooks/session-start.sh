#!/bin/bash
set -euo pipefail

# Only run in Claude Code cloud sessions
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Install OmniRoute CLI globally (skip if already installed)
if ! command -v omniroute >/dev/null 2>&1; then
  npm install -g omniroute --no-fund --no-audit --loglevel=error
fi
