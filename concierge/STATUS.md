# Mission Control — Concierge STATUS

_Last updated: 2026-07-30 11:30 (fresh session after 11-day gap; prior entry 2026-07-19 21:45)_

## READ THIS FIRST — the previous STATUS.md was 11 days stale

The Jul-19 entry described a ~19-pane Lane B fleet and 11 NEEDS-YOU panes. **All of
that is gone and its content was never captured.** Do not act on the old entry; it has
been replaced wholesale. What actually happened between Jul 19 and Jul 30 is below.

## Digest
- **Lanes:** Lane A — no live initiatives on the mc socket (only me + the two known
  phantom sessions). Lane B — **0 claude panes**; the fleet is empty.
- **Gates:** none pending for concierge.
- **Needs you:** 3 items — the dead notification channel (fix ready), the
  pr-tiles-350 production ramp ESCALATE, and what to do about the emptied fleet.

## Finding 1 — mc-watcher notifications have NEVER worked (since Jul 6)

**This is the most operationally important item.** `mc-watcher` is the daemon that
pushes to the phone on: new gate filed, `MC-BLOCKED:` lines, silent agents. Every
single push since **Jul 6 20:22** has failed `403 Forbidden` — **127,824 failures**,
zero successes.

Root cause (bisected 2026-07-30):
- The topic itself is healthy — plain `curl -d t https://ntfy-home.aviad.cloud/notifyopen` → **200**.
- Adding the `Title` / `Priority` headers the watcher sends → still **200**.
- Setting `User-Agent: Python-urllib/3.11` → **403**.
- The reverse proxy / Authelia in front of ntfy **blocks the `Python-urllib/*`
  User-Agent**. `push_ntfy()` uses stdlib `urllib` and never sets a UA.

Fix (one line, reversible), in `/home/aviad/mc/worktrees/mc-dev/watcher/mc-watcher.py`
`push_ntfy()` (~line 78) — add alongside the existing `add_header` calls:
```python
req.add_header("User-Agent", "mc-watcher/1.0")
```
then `systemctl --user restart mc-watcher`.

**Backlog is safe:** only **2** distinct events are pending (`mc blocked: mc-dev`,
`mc silent: concierge`) — the 127k is the same 2 events retried every 30s. Fixing it
sends 2 pushes, not a flood.

**STATUS: awaiting Aviad's go-ahead.** Not yet applied (touches a shared daemon).

## Finding 2 — the Lane B fleet drained, mostly on Jul 20

Pane count over time, from `~/mc/fleet/stats.log`:

| When | Panes |
|------|-------|
| Jul 19 18:48 (last STATUS) | 18–20 |
| Jul 20 13:31 → 14:54 → 15:10 | 14 → 8 → **2** |
| Jul 21 – Jul 29 | hovered 2–6 |
| Jul 29 18:37 | 1 |
| Jul 30 09:00 | 1 |
| Jul 30 11:25 (now) | **0** |

The Jul-20 collapse was a gradual drain over ~100 min (19→14→13→8→2), which reads as a
deliberate teardown rather than a crash. The Jul 23 18:58 reboot did **not** cause it —
counts were already low and survived that boundary.

The **last surviving pane** (`rereview-pr-1961:1`, %1) had recap
_"Check for missing tmux and Claude sessions"_ / next step _"dispatching it to another
agent"_ — i.e. it was itself investigating disappearing sessions, and is now gone too.
Cached in `~/mc/fleet/census.v3.cache`. **Worth asking Aviad whether the Jul-20 drain
was him.**

The 11 NEEDS-YOU asks from the Jul-19 entry (Immich cutover, external HDD, Kuma
re-baseline, the home-automation batch) were **never answered and their panes are
gone**. Only the one-line summaries in the old STATUS survive — preserved in git
history of this repo.

## Finding 3 — a whole PR-review subsystem was built since Jul 19

Not mentioned anywhere in the old STATUS. Autonomous PR review loops:
- **117 trace dirs** in `~/mc/traces/` — 73 `pr-server-*`, 25 `pr-ios-*`, 15 `pr-tiles-*`.
- **3 worktrees** created Jul 27: `pr-ios-3457`, `pr-server-1955`, `pr-tiles-350`.
- Reviewer agents run under a strict charter (zero GitHub writes, never execute PR
  branch code, invoke the `aviad-review` skill).
- **None have live sessions now.**

Round-1 results (all Jul 27, none advanced since):

| Initiative | Verdict |
|---|---|
| `pr-tiles-350` | **ESCALATE** — 5 findings |
| `pr-server-1955` | FINDINGS — 5 findings |
| `pr-ios-3457` | **FAILED / TOO_BIG** — 212 files, +22852/−1873; GitHub refuses diffs >20k lines (HTTP 406), so collection came back empty |

### pr-tiles-350 needs Aviad (real pending decision)
`stepscode/atly-tileserver#350` flips `CARDS_ROLLOUT_PCT` **25 → 100** in
`infra/prod.env` — full production traffic on the tileLocationCards read model across
four tile routes. The reviewer confirmed the ramp *mechanism* is sound but escalated
because **every gating criterion exists only as prose in the PR body** (zero errors both
cohorts, cards p50 101ms/p95 237ms vs legacy p50 104ms/p95 391ms, 160 reqs/80 buckets,
backfill delta-0, drift fallback active) — **no dashboard link, log excerpt, or probe
output attached**. Aviad should verify those numbers against real prod dashboards /
morgan logs before approving. Traces: `~/mc/traces/pr-tiles-350/iter-1.json`.

## Finding 4 — mc-dev is MC-BLOCKED and has no session

`mc-watcher` reports `mc blocked: mc-dev` continuously. mc-dev's STATUS carries an
`MC-BLOCKED:` awaiting a **URL/token from Aviad** (appears related to the notification
channel / Telegram fallback). Its tmux session is gone; only the worktree remains at
`~/mc/worktrees/mc-dev`.

## Services (all healthy except the notify path)

| Unit | State |
|---|---|
| `mc-router` | active — running since Jul 23 reboot |
| `mc-ui` | active — http://100.64.0.6:3010 (tailnet, read-only) |
| `mc-watcher` | active but **notifications 100% failing** (Finding 1) |
| `mc-broker` | active — bridges devbox to the Mac fleet's mc |
| `syncthing` | active |
| Timers | mc-stats-sampler, claude-session-map, hermes-config-backup, pkm-commit, claude-dotfiles-backup, mc-home-backup — all firing normally |

## Lane A — mc socket
- No real initiatives. `mc ls` shows `concierge` (me) + phantom `Main` (7 win) and
  `claude` (1 win).
- **The phantoms are reproducible, not leftovers:** they were recreated at 11:24:57 —
  the same second the mc server started this session. Confirms the carried-over
  infra bug: tmux-resurrect stamps default-socket layout onto the mc socket on start.
  Killing them is still gated / never approved.
- Worktrees on disk: `mc-dev`, `shabbat-climate`, `pr-ios-3457`, `pr-server-1955`,
  `pr-tiles-350`.

## Decisions awaiting Aviad
1. **Apply the mc-watcher User-Agent fix?** (Finding 1 — one line + restart, reversible)
2. **pr-tiles-350** — verify the prod numbers and decide the 25→100 ramp (Finding 3)
3. **Was the Jul-20 fleet drain intentional?** If not, worth a root-cause pass
4. `pr-ios-3457` — PR too big to diff via GitHub API; want a local-clone diff path instead?
5. Carried over: clean the phantom mc sessions? relaunch mc-dev? un-hold Uptime Kuma?

## Next steps
- Waiting on Aviad. Nothing is blocked on me.
- Carried-over infra TODO: give the mc socket its own resurrect dir (now confirmed
  reproducing every start — see Lane A).
- Carried-over: propagate the `~/.scripts/claude-session-map.py` fork-bug fix to the
  Mac + commit to yadm.
