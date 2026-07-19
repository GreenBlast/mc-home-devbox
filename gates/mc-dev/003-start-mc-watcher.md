# Gate: first activation of mc-watcher.service (notifications for gates / MC-BLOCKED / silence)

- **What:** `systemctl --user enable --now mc-watcher.service` — starts the notification
  watcher (`~/mc/worktrees/mc-dev/watcher/mc-watcher.py`) and enables it at boot.
- **Why:** Pushes when a gate is filed, an `MC-BLOCKED:` line appears, or a live agent is
  silent >30 min — the "Aviad doesn't have to poll tmux" half of Phase 1.
- **Blast radius:** Read-only over ~/mc except its own state file/markers. Until
  `~/mc/notify.conf` has a working NTFY_URL (blocked on you — ntfy-home is behind Authelia)
  it runs LOG-ONLY: events go to journald, nothing is pushed anywhere. With a conf it POSTs
  event titles + one-line summaries to your ntfy topic. Worst case: notification spam →
  stop the service.
- **Rollback:** `systemctl --user disable --now mc-watcher.service`.
- **Allow:** `^systemctl --user (enable( --now)?|start|restart) mc-watcher(\.service)?$`
- **Allow:** `^systemctl --user (disable( --now)?|stop) mc-watcher(\.service)?$`
