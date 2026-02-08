# Atuin + Syncthing Setup (Cloud-Free Sync)

Sync Atuin's SQLite database across machines using Syncthing instead of cloud.

## ⚠️ Important Warnings

**SQLite + Syncthing Caveats:**
- SQLite databases don't handle simultaneous writes well
- Risk of corruption if both machines are active at once
- No automatic conflict resolution
- Best for: 1 active machine at a time, or read-mostly scenarios

**Recommendation:** Self-hosted Atuin server is safer for multi-device sync.

---

## Setup Steps

### 1. Install Syncthing (if not already)

```bash
# macOS
brew install syncthing

# Start Syncthing
brew services start syncthing

# Access web UI
open http://localhost:8384
```

### 2. Create Atuin Sync Folder

```bash
# Create dedicated sync directory
mkdir -p ~/.config/syncthing/atuin-sync

# Symlink Atuin database (be careful!)
ln -s ~/.local/share/atuin/history.db ~/.config/syncthing/atuin-sync/history.db
ln -s ~/.local/share/atuin/key ~/.config/syncthing/atuin-sync/key
```

### 3. Add Folder to Syncthing

1. Open Syncthing web UI: http://localhost:8384
2. Click "Add Folder"
3. Folder Path: `/Users/ivanpereira/.config/syncthing/atuin-sync`
4. Folder Label: `Atuin History`
5. Folder Type: **Send & Receive**
6. Share with your other devices

### 4. Configure Other Machines

On each additional machine:

```bash
# Accept the shared folder in Syncthing UI
# Point to the Atuin data directory
mkdir -p ~/.local/share/atuin
ln -s ~/.config/syncthing/atuin-sync/history.db ~/.local/share/atuin/history.db
ln -s ~/.config/syncthing/atuin-sync/key ~/.local/share/atuin/key
```

### 5. Safety: Disable Auto-Sync in Atuin

```bash
# Edit ~/.config/atuin/config.toml
# Set auto_sync = false to prevent conflicts with cloud sync
```

Update your config:

```toml
## IMPORTANT: Disable Atuin's cloud sync when using Syncthing
auto_sync = false
# sync_address = "https://api.atuin.sh"  # Commented out
```

---

## Alternative: Read-Only Sync

Safer approach - designate one "primary" machine:

### Primary Machine (MacBook)
```bash
# Normal setup - this machine writes to the database
# Syncthing shares it out
```

### Secondary Machines (Read-mostly)
```bash
# Stop Atuin from writing
# Use Fish's native history for new commands
# Only read from Atuin for search

# In Atuin config, set:
# auto_sync = false
```

---

## Better Approach: Sync Via Git (Database Snapshots)

Instead of live syncing the database, periodically export/import:

```bash
# On Machine 1 - export history
atuin history list --format "{time}\t{command}\t{duration}" > ~/atuin-export.tsv

# Commit to private Git repo
git add atuin-export.tsv
git commit -m "Update history snapshot"
git push

# On Machine 2 - pull and import
git pull
# Manual import from TSV (would need custom script)
```

**Cons:** Manual process, loses metadata

---

## Recommendation: Self-Hosted Atuin

For proper multi-device sync without cloud, **self-host Atuin server** instead:

### Why It's Better:
- ✅ Designed for concurrent access
- ✅ Conflict resolution built-in
- ✅ Still end-to-end encrypted
- ✅ No SQLite corruption risk
- ✅ Proper sync protocol

### Quick Setup:

```bash
# Run on your VPS or home server
docker run -d \
  -p 8888:8888 \
  -v atuin-data:/config \
  -e ATUIN_DB_URI="sqlite:///config/atuin-server.db" \
  ghcr.io/atuinsh/atuin:latest server start

# On clients, point to your server
echo 'sync_address = "http://your-server:8888"' >> ~/.config/atuin/config.toml
```

See `ATUIN-SETUP-GUIDE.md` for full self-hosting instructions.

---

## Summary

| Method | Pros | Cons | Recommended? |
|--------|------|------|--------------|
| **Syncthing (SQLite)** | No server needed | Corruption risk | ⚠️ Use with caution |
| **Syncthing (Read-only)** | Safe for secondary devices | One-way sync only | ✅ OK for read-mostly |
| **Git (Snapshots)** | Simple, safe | Manual, loses metadata | ⚠️ Limited use case |
| **Self-hosted Atuin** | Proper sync, safe | Requires server | ✅ **Best option** |

**Verdict:** If you want true cloud-free multi-device sync, **self-host Atuin server** on a VPS or home server. It's designed for this and won't corrupt your database.

If you only have 1-2 machines and use them one at a time, Syncthing can work but be careful!
