# tmux Cheatsheet (Ctrl-a prefix)

## Sessions

- `tmux new -s name -c ~/path` — new session
- `tmux a -t name` — reattach
- `tmux ls` — list sessions
- `tmux kill-session -t name` — kill session
- Prefix shortcuts:
  - `Ctrl-a d` — detach
  - `Ctrl-a s` — session picker
  - `Ctrl-a $` — rename session

## Windows

- `Ctrl-a c` or `Ctrl-t` (Ghostty) — new window
- `Ctrl-a Ctrl-n` / `Ctrl-a Ctrl-p` — next / prev window
- `Ctrl-a ,` — rename window
- `Ctrl-a &` — close window
- Jump to window:
  - `F1`–`F5` — from tmux
  - `Ctrl-1`–`Ctrl-5` — from Ghostty

## Panes

- Split:
  - `Ctrl-a |` or `Cmd+D` (Ghostty) — vertical
  - `Ctrl-a -` or `Cmd+Shift+D` (Ghostty) — horizontal
- Navigate:
  - `Ctrl-a h/j/k/l` — from tmux
  - `Cmd+Alt+H/J/K/L` — from Ghostty
- `Ctrl-a z` — zoom / fullscreen toggle
- `Ctrl-a x` or `Ctrl-d` — close pane
- `Ctrl-a <` / `Ctrl-a >` — swap pane up / down
- `Ctrl-a` then hold arrow keys — resize

## Copy Mode (vi keys)

- `Ctrl-a v` — enter copy mode
- `v` — start selection
- `y` — copy (tmux-yank)
- `Ctrl-a p` — paste
- `/` / `?` — search down / up
- `q` — exit copy mode

## Misc

- `Ctrl-a r` — reload config
- `Ctrl-a :` — command prompt
- `Ctrl-a ?` — list all keybinds
- `tmux send-keys -t session:win.pane "text" Enter` — send to pane
