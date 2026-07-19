# Mission Control — Concierge STATUS

_Last updated: 2026-07-19 21:45 (re-sweep; prior entry 20:50)_

## Change since 20:50 sweep
- **Main:18 came back from the dead.** Was a 694d no-signal pane; ran `/memory-sync`
  (Mac→devbox) and finished: 4 memories merged from the Mac, 2 kept devbox-side,
  ~52 skipped (~50 Atly work-repo memories — no checkout on devbox — + 2 Mac-hardware).
  Notable merge: `syncthing_updatetime_conflicts` reclassified — 2026-07-12 saw **real
  content loss** via tail-append collision; conflict files are a merge queue, never
  bulk-delete. Its MEMORY.md hook was corrected (old one said "canonical always wins",
  which was dangerous).
  - **It has a question pending:** run `~/.claude/backup.sh` now, or let the hourly
    systemd timer commit the new memory files? (mc labels this pane "working"; it is
    actually idle awaiting an answer.)
  - Follow-up: this was one direction only. Several devbox-original memories are newer
    than the Mac's — run `/memory-sync` on the Mac for the reverse pass.
- Nothing else moved. Same 11 NEEDS-YOU, no gates, no new panes.

## Digest
- **Lanes:** Lane A — no real initiatives running (mc socket has only me + the two
  known phantom sessions `Main`/`claude`, still uncleaned since the Jul-9 blackout).
  Lane B — 19 claude panes on the default socket; **0 working**, 11 needing a decision,
  8 idle. Nothing is blocked on me; everything is blocked on Aviad.
- **Gates:** none pending.
- **Needs you:** 11 panes (see below). Two clusters: a fresh ~30–56 min batch of
  home-automation / access questions, and a stale 10-day batch (Immich, HDD, Kuma).

## Lane B — attention queue (from `mc next`)

### Fresh (< 1h) — today's threads
| # | Pane | Ask |
|---|------|-----|
| 1 | Main:12 | ⏸ sitting at an interactive prompt — needs a keypress |
| 2 | Main:10 | confirm receipt + decide whether to switch it |
| 3 | Main:13 | wants OK to run a one-unit on/off test on the salon |
| 4 | Main:14 | asks what you actually need it for |
| 5 | Main:15 | asks you to test whether your cylinder has an emergency function |
| 7 | Main:11 | five open access questions (ntfy, influxdb, n8n, paperless, grocery) |
| 11 | Main:7 | truncated ask ("tell me whether…") |

### Stale (10d) — carried from the blackout era
| # | Pane | Ask |
|---|------|-----|
| 6 | Main:1 | schedule the Immich cutover to retire the Pi |
| 8 | Main:2 | buy the external HDD for the 299 GB library backup |
| 9 | Main:4 | how to apply the Kuma writes (UI / creds / delegate) |
| 10 | Main:6 | let the other agent apply Kuma re-baseline + delete dead monitors 60-63 |

Note: the Kuma work (Main:4, Main:6) was put on **HOLD** by Aviad on Jul 9. Still held.

### Idle / no signal (8)
Main:3 (changedetection), Main:5 (dashy), Main:8 (review Mac Claude changes),
Main:9 (grocery list), Main:16 (atly tileserver access), Main:17 (Vaultwarden
registration check), Main:18 (dead, 694d), claude:1 (obsidian-helper).

## Lane A — mc socket
- No active initiatives. `mc-dev` and `shabbat-climate` worktrees still on disk
  (`~/mc/worktrees/`), sessions gone since the blackout.
- **Phantom sessions `Main` (7 win) + `claude` (1 win)** on the mc socket are still
  there — empty zsh shells from the Jul-9 restore. Killing them is gated → never got
  Aviad's OK. Harmless, just noise in `mc ls`.

## Open gates
none.

## Decisions awaiting Aviad
1. The 11 NEEDS-YOU panes above — mostly one-line answers he can give me to relay.
2. Clean the phantom mc sessions? (still open from Jul 9)
3. Relaunch Lane A `mc-dev`, or leave dormant? (still open from Jul 9)
4. Un-hold the Uptime Kuma cleanup? (held Jul 9)

## Next steps
- Waiting on Aviad. On his word, relay answers to specific panes via
  `tmux -L default send-keys`. Do not touch panes otherwise.
- Carried-over infra TODO: give the mc socket its own resurrect dir so a reboot
  stops stamping default-socket layout onto it.
- Carried-over: propagate the `~/.scripts/claude-session-map.py` fork-bug fix to the
  Mac + commit to yadm.
