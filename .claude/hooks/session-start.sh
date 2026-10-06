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

# Start the OmniRoute server in the background (skip if already running)
health_url="http://localhost:20128/api/monitoring/health"
if ! curl -sf -o /dev/null "$health_url"; then
  omniroute serve --daemon --no-open >/dev/null 2>&1 || true
  for _ in $(seq 1 30); do
    curl -sf -o /dev/null "$health_url" && break
    sleep 1
  done
fi
