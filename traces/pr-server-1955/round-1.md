# Round 1 — full review of stepscode/steps-server#1955

First round on this PR. Do a **complete** pass; later rounds are deltas and
they inherit whatever you get wrong here.

- PR: https://github.com/stepscode/steps-server/pull/1955 — author `8Gaston8`, mode `full_loop`
- Head SHA: `85b03fd04cdca283c489f7ce8f055b80134ffa02` — base branch `develop`
- Collected facts: `/home/aviad/mc/traces/pr-server-1955/collect/85b03fd04cdc/collect.json`
- Diff and collector output: `/home/aviad/mc/traces/pr-server-1955/collect/85b03fd04cdc`
- Local clone for surrounding context (read-only, do not fetch or checkout):
  `/home/aviad/Projects/monorepo/steps-server`

## What to do

1. **Read `/home/aviad/mc/traces/pr-server-1955/collect/85b03fd04cdc/collect.json`.** It carries `meta`, `review_threads`,
   `diff_file` and `signals`. The `signals` are *heuristics* — every one of
   them is a hypothesis to verify against the diff, never a finding on its own.
   Its "secret" and "telemetry" hits are frequently false positives.
2. **Read the diff at `diff_file` in full.** Not a summary of it. If it is too
   large to read in full, stop and emit `"verdict": "TOO_BIG"` — a shallow pass
   reported as clean is the one outcome that is worse than no review.
3. **Invoke the `aviad-review` skill** and run its single-PR pipeline against
   this PR. Follow it as written:
   - Layer 1 — open-ended review first, from first principles, no priors.
   - Layer 1b — anything a strong generic reviewer would raise that is *not*
     in the taxonomy, listed separately so calibration cannot bury it.
   - Layer 2 — the Aviad lens on top. It annotates Layer 1; it may never
     delete a Layer-1 finding.
   - Bucket = the more conservative of the two.
   Single-PR mode means **always full Layer 1**, never triage depth.
4. **Dedupe against the bots.** `review_threads` holds the open
   `baz-reviewer` / `chatgpt-codex-connector` threads. Anything they already
   raised gets `already_raised_by_bots: true` — it is endorsed in the briefing,
   not restated on the PR.
5. **Classify every finding** into the class vocabulary below. The class, not
   the prose, is what decides whether it can ever be posted.

## Finding classes

| class | means | what the loop does with it |
|---|---|---|
| `gate` | a deterministic hard gate fired: secret-as-literal, scope creep into CI/build/fastlane, index-from-code, Lambda removed, backward-compat break, unhardened authless/paid endpoint, un-awaited telemetry, bundled refactor/migration, large not-a-clean-rename code move, merge conflicts | drafted, veto window, posted |
| `high` | Layer-1 High **with a concrete failure path** — `file:line` plus how it actually breaks | drafted, veto window, posted |
| `medium` | Layer-1 Medium; a real concern without a proven failure path | drafted, veto window, posted |
| `judgment` | "is this the right approach" — architecture, naming, design taste | posted **as a question**, never a verdict, never `high` |
| `low` | cleanup, optional | briefing only |
| `protected` | protected zone: purchases/subscriptions, `serverless.yml` function add/remove, index/migration, prod-infra | **escalates. never posted.** |

`high` requires the failure path. A suspicion without one is `medium`.

## Then write the verdict file

**Last action. Write `/home/aviad/mc/traces/pr-server-1955/iter-1.json`, then stop.**

```json
{
  "iteration": 1,
  "head_sha": "85b03fd04cdca283c489f7ce8f055b80134ffa02",
  "verdict": "FINDINGS",
  "one_liner": "One sentence: what this PR does.",
  "findings": [
    {
      "id": "f1",
      "class": "high",
      "gate": null,
      "file": "src/tiles/lookup.ts",
      "line": 88,
      "body": "The comment as it would be posted on that line.",
      "failure_path": "Concretely how it breaks, and when.",
      "already_raised_by_bots": false
    }
  ],
  "verified_fixed": [],
  "regressions": [],
  "escalate": null,
  "briefing": null
}
```

Rules the supervisor validates and will reject the file over:

- `verdict` is one of `FINDINGS`, `CONVERGED`, `ESCALATE`, `TOO_BIG`.
- `head_sha` must be `85b03fd04cdca283c489f7ce8f055b80134ffa02`. If the PR has moved under you, say so via
  `ESCALATE` rather than answering for a SHA you did not read.
- `FINDINGS` requires at least one finding. `CONVERGED` requires **zero**
  findings and a `briefing`. `ESCALATE` requires an `escalate` object with a
  `reason`.
- Finding ids are unique and stable; you will be asked about them by id in
  later rounds. Start at `f1`.
- Every finding needs a non-empty `body`. `file`/`line` may be null when the
  finding is not anchorable — say so in the body; it degrades to a file-level
  or body-level comment rather than being dropped.

If the PR is genuinely clean, use `CONVERGED` and fill the briefing:

```json
{
  "verdict": "CONVERGED",
  "findings": [],
  "briefing": {
    "what_it_does": "...",
    "red_flags": [],
    "core_files": ["..."],
    "loop_history": "Round 1, clean on first pass.",
    "ci": "green (sensitive-scope-approval-gate red = Aviad's approval)",
    "aviad_risk_label": null
  }
}
```
