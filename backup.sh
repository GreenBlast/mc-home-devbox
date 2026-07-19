#!/bin/bash
# mc-home auto-backup (devbox) — commits ~/mc durable runtime state, pushes to origin.
# Offline-safe: local commit always succeeds; push is best-effort, next run retries.
# Runs hourly via systemd user timer mc-home-backup.timer.
set -u
MC_DIR="$HOME/mc"
GIT=$(command -v git)
cd "$MC_DIR" || exit 0
$GIT add -A
$GIT diff --cached --quiet || $GIT commit -q -m "auto-backup: $(date "+%Y-%m-%d %H:%M")"
if [ -n "$($GIT log --branches --not --remotes --oneline 2>/dev/null)" ]; then
  GIT_SSH_COMMAND="ssh -o ConnectTimeout=15 -o BatchMode=yes" $GIT push -q 2>/dev/null || true
fi
