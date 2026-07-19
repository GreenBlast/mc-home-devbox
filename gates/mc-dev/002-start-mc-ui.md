# Gate: first activation of mc-ui.service (opens port 3010 on the tailnet IP)

- **What:** `systemctl --user enable --now mc-ui.service` — starts the read-only web UI
  (`~/mc/worktrees/mc-dev/ui/mc-ui.py`) bound to **100.64.0.6:3010** and enables it at boot.
- **Why:** Phase 1 cockpit: initiative statuses (working / MC-BLOCKED / gate-pending / idle),
  pending gate bodies, and live transcript tails from any tailnet device (phone included).
- **Blast radius:** Opens one new listening port, tailnet-only (3010 verified free; existing
  services untouched — 3000 obsidian-snippets, 3001/9119 reserved). The process is read-only
  by construction: no write endpoints exist; it only reads ~/mc and runs tmux
  list-panes/capture-pane. Anyone on the tailnet can view agent transcripts — same trust
  model as existing devbox services, no password by design.
- **Rollback:** `systemctl --user disable --now mc-ui.service` — port closes, no residue.
- **Allow:** `^systemctl --user (enable( --now)?|start|restart) mc-ui(\.service)?$`
- **Allow:** `^systemctl --user (disable( --now)?|stop) mc-ui(\.service)?$`
