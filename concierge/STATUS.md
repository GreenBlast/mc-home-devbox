# Mission Control — Concierge STATUS

_Last updated: 2026-07-09 09:2x (post-blackout resume sweep)_

## Digest
- **Lanes:** Blackout has passed; both sockets restarted ~09:25–09:28 today. Default
  fleet restored (10 Main windows + obsidian-helper) but **3 panes stuck at a
  "Resume from summary" prompt** awaiting a keypress. mc socket is **polluted with
  phantom shell sessions** from the restore. Lane A initiatives not auto-restored
  (worktrees safe on disk).
- **Gates:** none pending.
- **Needs you:** 3 decisions below (clean phantom mc sessions / press-resume on the 3
  stalled fleet panes / whether to relaunch Lane A mc-dev).

## Post-blackout reconcile (this sweep)
### Lane B — current-work fleet (`tmux -L default`) — RESTORED
- **Main** now 10 windows (was 7); **claude**=obsidian-helper.
  - 1 minisforum-migration, 4 Uptime Kuma, 6 complot, 7–10 (bare "claude"), claude:1
    obsidian-helper → all resumed, idle at auto-mode prompts.
  - **Main:2 (Plan split infra), Main:3 (changedetection), Main:5 (dashy) → STUCK at
    "Resume from summary (recommended)" prompt.** Need a keypress (option 1) to finish
    resuming. Did NOT touch — awaiting Aviad's go to send Enter/"1".
- dashy(5), changedetection(3), Uptime Kuma(4), Plan-split(2) = the mini migration work.

### Lane A — mc-socket initiatives (`tmux -L mc`) — NOT auto-restored
- `mc ls` now shows only **Main (7 win)**, **claude (1)**, **concierge** (me).
- **Main + claude on the mc socket are PHANTOM junk:** empty zsh shells in
  `~/Projects/ObsidianVaults/Aviad`; a claude launched in each during restore then
  exited back to shell. These are the resurrect layout of the DEFAULT socket stamped
  onto the mc socket (mc socket shares the resurrect dir — flagged as a gap pre-blackout).
  They are NOT real initiatives. Safe to kill (empty shells) but killing sessions is
  gated → awaiting Aviad.
- **Real initiatives mc-dev & shabbat-climate: tmux sessions gone, but worktrees SURVIVE**
  on disk (`~/mc/worktrees/mc-dev`, `~/mc/worktrees/shabbat-climate`). mc-dev transcript
  resumable. shabbat-climate was only ever a shell — nothing lost. Recover via
  `mc attach <slug>` + relaunch claude if wanted.

## Open gates
none.

## Active dispatch
- **Main:5 dashy/Authelia — RUNNING (dispatched 09:xx).** Aviad gave go-ahead. Agent is
  executing the recommended plan: re-point dashy/influxdb/metabase tunnel rules through
  SWAG (localhost:44445, Host preserved) so Authelia gates all three; InfluxDB uses
  write-path bypass (/api/v2/write open, rest gated) so metric pushes don't break; remove
  the open bare dashy.aviad.cloud rule; KEEP metabase (do not delete) and gate it. Watch
  for completion + verify report.

## Decisions — status
1. **Finish 3 stalled fleet resumes — DONE.** Sent option 2 (resume full, not summary,
   per [[resume-full-not-summary]]) to Main:2/3/5; all resumed clean.
2. **Uptime Kuma cleanup (Main:4) — HOLD.** Aviad: don't continue with Kuma for now.
   Paperless repoints + orphaned id31/id32 + complot's dead monitors 60-63 all remain
   deferred behind this. Pane idle awaiting his method choice later.
3. **Clean phantom mc sessions?** Kill `Main` + `claude` on the mc socket (empty junk
   shells). — still needs your OK (session kill).
4. **Relaunch Lane A mc-dev?** Recreate its mc session + resume, or leave dormant. — pending.

## Backup readiness notes (carried over — still valid)
- Auto-capture systemd units refresh `~/.claude-restore.tsv` every 15 min (DEFAULT socket).
- resolver fork-bug fix in `~/.scripts/claude-session-map.py` (backup `.bak-20260707`) —
  still TODO: propagate to the Mac + commit to yadm.
- **Confirmed gap materialized:** mc socket not covered by resurrect → produced the phantom
  sessions above on restore. Future: give mc socket its own resurrect dir, or exclude it.

## Next steps
- Hold for Aviad's answers on the 3 decisions above; do not touch fleet/sessions until then.
- After cleanup: consider isolating the mc socket's resurrect dir to prevent recurrence.
