# Gate: first activation of mc-router.service (injects keystrokes into live agent sessions)

- **What:** `systemctl --user enable --now mc-router.service` — starts the inbox/gate-answer
  router (`~/mc/worktrees/mc-dev/router/mc-router.py`) as a systemd user service and enables
  it at boot.
- **Why:** Replaces Phase 0 polling: mail in `~/mc/inbox/<slug>/` and gate answers get typed
  into the matching `tmux -L mc` session as pokes. Unblocks the event-driven wake model for
  every initiative (including gate-answer delivery to me).
- **Blast radius:** The router types text into live agent panes. Safety: it only delivers when
  the pane's foreground command is `claude`/`node` (never a bare shell, where text would
  execute), targets only the `mc` socket, and writes only rename/marker files under `~/mc`.
  Worst case: a stray poke line lands in an agent's input box — an annoyance, not damage.
  Tested end-to-end against a scratch session (see docs/router.md, LOG.md).
- **Rollback:** `systemctl --user disable --now mc-router.service` — full stop, no residue
  beyond `.delivered` renames/markers already made.
- **Allow:** `^systemctl --user (enable( --now)?|start|restart) mc-router(\.service)?$`
- **Allow:** `^systemctl --user (disable( --now)?|stop) mc-router(\.service)?$`
