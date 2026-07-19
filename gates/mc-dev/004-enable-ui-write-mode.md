# Gate: enable mc-ui WRITE mode (composer + gate approve/deny from the web)

- **What:** Add `Environment=MC_UI_WRITE=1` to mc-ui.service (drop-in), then
  `systemctl --user daemon-reload && systemctl --user restart mc-ui.service`.
  Presupposes gate 002 (running the UI at all) is approved.
- **Why:** Phase 2: send messages to any agent (writes a file into
  `~/mc/inbox/<slug>/` for the router to deliver) and answer gates
  (approve/deny buttons writing `.answer` files) from any tailnet device.
- **Blast radius:** Anyone on the tailnet can then message agents and answer
  gates without a password — the tailnet-is-the-auth model now covers WRITES,
  including gate approvals. If any non-Aviad person/device ever joins the
  tailnet, this is the gate to reconsider. Writes are limited by construction
  to inbox files and `.answer` files (slug/filename validated, no clobbering
  of existing answers).
- **Rollback:** Remove the drop-in, `systemctl --user daemon-reload && systemctl
  --user restart mc-ui.service` — endpoints return 403 again.
- **Allow:** `^systemctl --user (daemon-reload|restart mc-ui(\.service)?)$`
- **Allow:** `^mkdir -p .*/mc-ui\.service\.d$`
