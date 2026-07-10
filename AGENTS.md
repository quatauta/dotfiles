# AGENTS.md

Personal macOS dotfiles managed by [rcm](https://github.com/thoughtbot/rcm). Files in `~/.dotfiles/` are symlinked to `$HOME`.

## Quick Reference

| Command | Purpose |
|---------|---------|
| `rcup` | Deploy/update dotfiles (creates symlinks) |
| `lsrc -F` | Preview what will be symlinked |
| `./bin/update` | Update all tools (Homebrew, devbox, nix, yabai, skhd) |
| `devbox global add PKG` | Install a package (preferred over brew) |
| `refresh-global` | Run after devbox add/rm to sync packages |

## Repository Structure

```
.dotfiles/
├── bin/                    # Scripts (in PATH, excluded from rcm)
├── config/                 # XDG configs (~/.config/)
│   ├── env                 # Primary environment (PATH, aliases, exports)
│   ├── env.local           # Machine-specific overrides (git-ignored)
│   ├── git/                # Git config, hooks, attributes
│   ├── nvim/               # Neovim (LazyVim)
│   ├── starship.toml       # Shell prompt
│   ├── yabai/              # Window manager
│   └── skhd/               # Hotkey daemon
├── oh-my-zsh/custom/       # Zsh customizations
│   └── daniel.zsh          # Primary zsh config
├── rcrc                    # rcm configuration
├── zshrc                   # Zsh entry point (Oh-My-Zsh)
├── bashrc                  # Bash entry point
├── local/share/devbox/global/default/
│   └── devbox.json         # Devbox global packages (preferred)
├── Brewfile                # Homebrew packages (casks, apps, fonts)
└── setup                   # Initial installation script
```

## rcm Configuration (rcrc)

- **COPY_ALWAYS**: `*.local` files are copied (not symlinked) for machine-specific secrets
- **EXCLUDES**: `bin/`, `setup`, `LICENSE*`, `README*`, `_*` files
- **UNDOTTED**: `Library/` symlinked without leading dot (macOS convention)

## Key Scripts (bin/)

| Script | Purpose |
|--------|---------|
| `g` | Git wrapper: no args = status + stash; auto-adds SSH key for pull/push/fetch |
| `update` | Full system update (brew, devbox, nix, yabai, skhd) |

## Environment & Aliases (config/env)

**PATH order**: `devbox global` → `~/.dotfiles/bin` → `~/.local/bin`

**Key aliases**:
- `cat`/`less` → `bat`
- `ls` → `eza`
- `vi`/`vim` → `nvim`
- `rm`/`cp`/`mv` → interactive (`-i`)

**Key exports**: `EDITOR=nvim`

## Git Configuration (config/git/config)

- **Signing**: SSH-based commit signing (`commit.gpgSign = true`)
- **Merge**: Fast-forward only (`merge.ff = only`)
- **Auto-prune**: Fetch/pull delete stale remote refs
- **Diff**: Histogram algorithm, zdiff3 conflict style
- **Hooks**: gitleaks pre-commit (secret scanning)

**Key aliases** (via `g` wrapper or `git`):
- `m` - switch to main, pull, clean local branches
- `bcl` - delete local branches whose upstream is gone
- `fa` / `pa` / `sa` - fetch/pull/status all repos in directory tree
- `for-all-repos` - run command across all .git directories

## Shell (Zsh with Oh-My-Zsh)

**Plugins**: brew, devbox, dotenv, history, mcfly, mix-fast, ssh-agent, zsh-autosuggestions

**Prompt**: Starship (`config/starship.toml`) - shows git branch

## Neovim (config/nvim/)

LazyVim-based with Tokyo Night theme and transparent background. Auto dark mode based on macOS system theme.

## Window Management

- **Yabai** (`config/yabai/yabairc`): BSP tiling, no gaps, floating app exceptions
- **SKHD** (`config/skhd/skhdrc`): `Alt+T` toggle float, `Ctrl+Alt+R` restart services, `Ctrl+Alt+Q` stop yabai

## Critical Rules for AI Agents

1. **Edit sources, not symlinks**: Modify files in `~/.dotfiles/`, not the symlinked versions in `$HOME`
2. **Never commit `*.local` files**: These contain machine-specific secrets and are git-ignored
3. **Test shell changes**: After editing shell config, verify with `zsh -n ~/.zshrc` or start new shell
4. **Respect wrapper scripts**: `g` has special behavior - don't bypass without reason
5. **Fast-forward only**: Git requires FF merges/pulls; rebase if diverged from upstream
6. **Multi-repo aliases are dangerous**: `for-all-repos` affects ALL `.git` directories in tree
7. **macOS-only**: Homebrew, yabai, iTerm2 configs won't work on Linux

## Package Management

**Prefer [devbox](https://www.jetify.com/docs/devbox/) over Homebrew** for CLI tools. Use Homebrew for GUI apps, casks, and fonts.

| Command | Purpose |
|---------|---------|
| `devbox global ls` | List installed packages |
| `devbox search TERM` | Search available packages |
| `devbox global add PKG` | Install a package |
| `devbox global rm PKG` | Remove a package |
| `refresh-global` | **Required** after add/rm to sync packages |

## Common Tasks

### Add new dotfile
```bash
mkrc ~/.newconfig
```

### Add machine-specific config
```bash
echo 'export MY_VAR=value' >> ~/.dotfiles/config/env.local
rcup
```

### Install a tool
```bash
devbox global add ripgrep   # Preferred: uses devbox
refresh-global              # Required: sync packages
# Or for GUI apps/casks:
brew install --cask firefox
```

### Update dependencies
```bash
./bin/update
```
