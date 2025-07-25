# lc — Lightweight per-directory command launcher 🍀

`lc` lets you attach a **menu of frequently used commands** to any folder.
Think of it as quick text snippets for your terminal—context-aware and always editable.


## How it is used

```bash
# Add a command to the current directory
lc add "npm run dev"

# Show the menu, pick command with up and down arrow keys, press Enter to run
lc

# Remove a command
lc rm "npm run dev"

# List commands registered for this directory
lc ls
```

---

## Installation

**Requirements**

| Tool | macOS | Debian/Ubuntu |
|------|-------|---------------|
| `fzf` (fuzzy finder) | `brew install fzf` | `sudo apt install fzf` |
| `jq`  (JSON CLI)     | `brew install jq`  | `sudo apt install jq` |


**One-time setup**

```bash
# 1. Clone this repo
git clone https://github.com/dabochen/lc.git
cd lc

# 2. Install the script
mkdir -p ~/.lc
cp lc.sh ~/.lc/lc
chmod +x ~/.lc/lc

# 3. Add ~/.lc to PATH (zsh example)
echo 'export PATH="$HOME/.lc:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

---

## Commands

| Command | What it does |
|---------|--------------|
| `lc` | Show menu → arrow keys to select → **Enter** to run |
| `lc add "<command>"` | Register the command for the **current directory** |
| `lc rm "<command>"` | Unregister the command from this directory |
| `lc ls` | List commands registered for this directory |

*Always wrap the full command in quotes* so spaces are preserved.

All data lives in **`~/.lc/registry.json`** — copy that file (and `lc`) to another machine, add `~/.lc` to `$PATH`, and you’re done.

---

## Use over SSH

```bash
# Copy your configuration to the server
scp -r ~/.lc  user@server:/home/user/

# Install dependencies, add lc to PATH
ssh user@server '
  sudo apt update && sudo apt install -y fzf jq &&
  echo "export PATH=\"$HOME/.lc:\$PATH\"" >> ~/.bashrc
'
```

---

## Uninstall

```bash
rm -rf ~/.lc
sed -i '' '/\.lc.*PATH/d' ~/.zshrc  # adjust for your shell
```

---

## License

MIT © 2025 Dabo
