# Setup modularization plan

Refactor the monolithic `bootstrap.sh` into **per-domain** scripts under `setup/`, so:

- `bootstrap.sh` stays the single end-to-end entry point (a thin orchestrator).
- Each domain is an independently runnable, idempotent script.
- **AI agents can run the no-sudo domains unattended**, while sudo/interactive
  domains stay human-driven.

Status: **planned, not yet built.** This file is the spec.

---

## Why

The no-sudo work (linking dotfiles, installing user-space tooling/plugins) is the
bulk of setup and needs no privileges — but today it's trapped inside a monolith
that aborts/blocks on the first sudo or interactive step. Splitting by domain lets
an agent do the safe 80% and a human do the few privileged steps.

**Caveat:** the no-sudo domains are *not* "run anytime" — they depend on Homebrew
(+ mise) already being installed. They're **phase 2**. Every no-sudo module must
guard its prerequisites (`ensure_brew` / `command -v` checks) and `error` clearly
instead of failing cryptically.

---

## Directory layout

```
setup/
  lib.sh                 # shared helpers, sourced by every module
  homebrew-core.sh       # [sudo]      install Homebrew + brew bundle (Brewfile)
  homebrew-personal.sh   # [sudo]      brew bundle (Brewfile.personal)
  macos.sh               # [sudo]      hostname (scutil) + macOS defaults
  shell.sh               # [sudo]      fish -> /etc/shells + chsh  (+ fisher, see decision #1)
  stow.sh                # [no sudo]   config dirs + stow all packages       <- agent
  git.sh                 # [no sudo*]  pre-commit install + git identity      <- agent*
  runtimes.sh            # [no sudo]   mise install + global npm packages     <- agent
  tmux.sh                # [no sudo]   TPM clone + tmux plugin install        <- agent
  launchd.sh             # [no sudo]   load com.ivanpereira.*.plist agents    <- agent
  ssh.sh                 # [prompt]    SSH keygen (headless only)
  secrets.sh             # [prompt]    1Password -> ~/.secrets (headless only)
macos/defaults.sh        # EXISTS — keep; macos.sh calls it
bootstrap.sh             # orchestrator: prompts + calls modules in order
```

`*` `git.sh`: `pre-commit install` is fully agent-safe; the identity prompt only
fires if `~/.gitconfig.local` is missing and **must skip with a warning when
non-interactive** (no TTY / `NONINTERACTIVE=1`), so an agent can still run it.

---

## Domain → responsibility map (from current `bootstrap.sh`)

| Module | Pulls from `bootstrap.sh` section | sudo | prompt | Agent-safe |
|--------|-----------------------------------|:----:|:----:|:----:|
| `homebrew-core.sh` | Homebrew install + `brew bundle --file=Brewfile` | yes | — | no |
| `homebrew-personal.sh` | `brew bundle --file=Brewfile.personal` | yes | — | no |
| `macos.sh` | Hostname (`scutil --set …`) + run `macos/defaults.sh` | yes | yes | no |
| `shell.sh` | Add fish to `/etc/shells`, `chsh`, fisher plugins | yes | — | no |
| `stow.sh` | `mkdir` config dirs + headless flag + `stow --no-folding -R …` | no | — | **yes** |
| `git.sh` | `pre-commit install` + `~/.gitconfig.local` / `.work` | no | yes* | **yes\*** |
| `runtimes.sh` | `mise install --yes` + global npm packages loop | no | — | **yes** |
| `tmux.sh` | clone TPM + `install_plugins` | no | — | **yes** |
| `launchd.sh` | `launchctl bootout`/`bootstrap` of `com.ivanpereira.*` | no | — | **yes** |
| `ssh.sh` | headless SSH key generate/reuse + print pubkey | no | yes | no |
| `secrets.sh` | headless `op read` -> `~/.secrets` (chmod 600) | no | yes | no |

---

## `lib.sh` (shared)

- `info` / `warn` / `error` + color vars (currently duplicated in `bootstrap.sh`
  and `macos/defaults.sh`).
- `DOTFILES="${DOTFILES:-$HOME/.dotfiles}"`.
- `ensure_brew()` — `eval "$(/opt/homebrew/bin/brew shellenv)"` if present, else
  `error "Homebrew not installed — run setup/homebrew-core.sh first"`.
- `is_interactive()` — true if stdin is a TTY and `NONINTERACTIVE` unset.
- Modules: `set -euo pipefail` + `source "$(dirname "$0")/lib.sh"`.

---

## Orchestration order (`bootstrap.sh`)

Run prompts once (hostname, headless, personal?), export `HOSTNAME_TO_SET` /
`HEADLESS`, then:

```
1. macos.sh              # sudo + prompts, front-loaded (self-contained)
2. homebrew-core.sh      # sudo
3. homebrew-personal.sh  # sudo (only if personal chosen)
4. shell.sh              # sudo  (default shell; fisher part needs step 5 first*)
5. stow.sh               # no sudo  <-- everything below is agent-runnable
6. git.sh                # no sudo (+ identity prompt if interactive)
7. runtimes.sh           # no sudo
8. tmux.sh               # no sudo
9. launchd.sh            # no sudo (needs stowed plists)
10. ssh.sh / secrets.sh  # headless only
```

\* See ordering constraints — fisher must run after stow.

## Ordering constraints (the orchestrator must enforce)

- All no-sudo modules require **`homebrew-core.sh` first** (stow, pre-commit, mise,
  tmux, fish all come from brew).
- **fisher** (in `shell.sh`) and **`launchd.sh`** must run **after `stow.sh`** —
  fisher reads the stowed `fish_plugins`; launchd loads the stowed
  `~/Library/LaunchAgents/*.plist`.
- `runtimes.sh` npm step needs node from `mise install`, so npm runs after mise
  within the module.

---

## Agent usage (no-sudo, after a human has run homebrew-core + shell default)

```bash
setup/stow.sh
setup/git.sh        # NONINTERACTIVE=1 to skip identity prompt
setup/runtimes.sh
setup/tmux.sh
setup/launchd.sh
```

(Consider a convenience `setup/user-env.sh` that runs exactly these in order.)

---

## Open decisions

1. **fisher placement** — keep in `shell.sh` (fish domain, but couples a no-sudo
   action into a sudo module) vs. split into its own agent-runnable
   `fish-plugins.sh`.
2. **npm globals** — folded into `runtimes.sh` (current plan) vs. standalone
   `npm.sh`.
3. **macos/defaults.sh** — leave as one file vs. split its 3 sudo lines
   (hostname/SMB) out so the rest is agent-runnable.
4. **`user-env.sh` convenience wrapper** — add it, or document the sequence only.

---

## Principles

- Every module idempotent and safe to re-run.
- No module assumes it's run from a particular CWD — use absolute `$DOTFILES`.
- Interactive steps degrade gracefully when non-interactive (skip + warn).
- Single source of truth: `bootstrap.sh` calls modules; logic is never duplicated.
