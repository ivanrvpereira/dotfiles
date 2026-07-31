# Handoff — pi/tmux rendering & slowness investigation

Date: 2026-07-04. Machine: macOS 26 (Darwin 25.5.0), Apple Silicon, Ghostty, fish, tmux via Homebrew.

## Primary artifact (read first)

`~/.agents/docs/pi-tmux-rendering-notes.md` — full investigation log with two
dated follow-up sections (2026-07-03 and 2026-07-04). Everything below assumes
that file; this handoff only adds session state not captured there.

## TL;DR of where things stand

Two distinct problems were untangled:

1. **Original rendering glitch** (pre-Jul-3, old tmux build): typed pi
   `/commands` invisible + history scrolling; cured only by `tmux kill-server`.
   Suspected = upstream tmux grid corruption on macOS ARM,
   **tmux/tmux#5267** (open; lineage #4777 → #5159 → #4888 → #5174 → #4962 →
   #5140). Still UNPROVEN — pi's output was verified byte-clean via a
   pipe-pane recording, but the corruption was never caught in the act.
2. **"Impossible slow"** (post-Jul-3): caused by the Homebrew `--HEAD` build
   containing nicm's `#ifdef __APPLE__` O(n²)-per-newline `grid_check_lines`
   diagnostic (master commits ad74c5ed/928c7a97). Confirmed via `sample` of
   the server. Fixed by swapping back to stable.

## Current system state (verify before acting)

- `brew` now has **stable tmux 3.7b linked** (`tmux -V` → 3.7b). The old
  `HEAD-6ad86eb` keg is still in the Cellar (uninstall blocked by dependents
  agent-deck, tmuxinator; `brew cleanup` won't remove it).
- **The user's running tmux server may still be the old slow HEAD binary** —
  it only switches at next server start. Ask whether they've done the
  resurrect-save → `kill-server` → restore cycle yet. After that, the HEAD keg
  can be deleted: `rm -rf /opt/homebrew/Cellar/tmux/HEAD-6ad86eb`.
- **Bug-hunting rig built and smoke-tested**: `tmux-hunt`
  (`~/.local/bin/tmux-hunt`) → ASAN build of tmux master (`next-3.8`) at
  `~/.local/tmux-asan/bin/tmux`, own socket `-L hunt`, reports to
  `~/tmux-traces/asan.<pid>`. Source: `~/code/contrib/tmux`, branch
  `bughunt`, one local commit `73c39877` (empties `grid_check_lines` body;
  keeps `grid_check_is_clear` + asserts). Rebuild: `git fetch && git rebase
  origin/master && make -j8 && make install`.
- Local repos: `~/code/contrib/tmux` (bughunt branch checked out),
  `~/code/contrib/tmux-debug` (older instrumented tree, has uncommitted
  grid.c/tmux.h debug diff), `~/code/contrib/pi-mono` (pi source).
- Raw pi output recording (2 MB+, from the /perplexity-config repro) and the
  analyzer script live in the previous session's scratchpad:
  `/private/tmp/claude-501/-Users-ivanpereira--dotfiles/42b525eb-de5a-4773-a224-1e20b3facc7a/scratchpad/`
  (`pi-pane1-raw.log`, `analyze_pane_log.py`, `pane1-before.txt`,
  `pane1-after.txt`). May be cleaned by the OS; not precious.

## Key technical facts a fresh agent needs

- pi renders in the **normal screen buffer** (no alt-screen), scrolls via raw
  `\r\n`, and appends an OSC 8 reset to every rendered line every frame
  (~10k OSC 8 / 15 min / pane) — extended-cell (`extddata`) heavy, i.e. a
  worst-case load for the suspect tmux grid paths.
- pi's emitted frames were verified well-formed (zero over-wide lines,
  balanced `?2026h/l` sync pairs) — analysis method in the scratchpad script.
- Stable 3.7/3.7a/3.7b do NOT contain the quadratic checks (verified against
  git tags). Master does, always-on for macOS.
- The #4777 fix (`7582888`) never fully landed on master; maintainer (nicm)
  has no macOS/ARM hardware and wants reports from master builds only.

## Next actions (in likely order)

1. Confirm the user restarted their tmux server onto 3.7b; then delete the
   leftover HEAD keg.
2. Encourage running pi inside `tmux-hunt` sessions to catch the corruption.
   If ASAN fires: attach `~/tmux-traces/asan.<pid>` to tmux/tmux#5267,
   disclosing the build = master + local commit 73c39877 (diagnostic no-op)
   + ASAN.
3. If the original glitch reappears on stable 3.7b: do NOT kill the server.
   First restart pi alone in the same pane (discriminates pi-state vs
   tmux-state), try detach/reattach (`refresh-client -S`), and test a fresh
   window. Optionally re-attach a pipe-pane recorder (method in notes doc /
   scratchpad script) to capture the glitch bytes.
4. Consider a weekly launchd job (resurrect-save + kill-server) if the user
   wants preventive restarts — was offered, not yet requested.

## Suggested skills

- `github` — all tmux/tmux issue reading and any upstream reporting (`gh issue
  view 5267 --repo tmux/tmux`, comments via `gh api`). Never scrape GitHub.
- `tmux` — remote-controlling panes for diagnostics (send-keys, capture-pane)
  if reproducing/observing the glitch interactively.
- `git-commit` — read before committing anything (e.g., if the user wants the
  tmux.conf `history-limit` change or a launchd job added to dotfiles; note
  the dotfiles repo has unrelated uncommitted changes — don't sweep them in).
- `update-config` / `schedule` — only if the user asks for the automated
  weekly restart or crash-report watcher.

## Constraints / user preferences observed

- Dotfiles repo conventions: conventional commits, no secrets, `bin/sync
  --dry-run` before sync in ~/.agents. Fish shell — avoid zsh-isms in
  suggested commands (`echo ===` unquoted caused noise; quote such args).
- The user's Claude Code session itself runs inside the tmux server being
  debugged — never `kill-server` or kill panes yourself; let the user do it.
- User is technical but concise; leads with outcome, minimal ceremony.
