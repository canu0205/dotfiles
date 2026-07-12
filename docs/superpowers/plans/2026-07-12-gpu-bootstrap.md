# GPU Bootstrap Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** provide a repeatable bootstrap for disposable Ubuntu GPU hosts using only the Git, tmux, and Neovim dotfile packages.

**Architecture:** split the current mixed `shell` Stow package into tool-specific packages so the remote host can link a narrowly scoped set of configuration files. A Bash bootstrap installs the required packages, installs a pinned upstream Neovim release because Ubuntu 22.04 is too old, and runs Stow for the GPU packages.

**Tech Stack:** Bash, GNU Stow, apt, Neovim Linux tarball.

---

## Chunk 1: Package layout and bootstrap script

### Task 1: Separate Stow packages

**Files:**
- Create: `git/.gitconfig`
- Create: `tmux/.tmux.conf`
- Create: `nvim/.config/nvim/` (moved from `editor/.config/nvim/`)
- Modify: remove the moved files from `shell/` and `editor/`

- [ ] Move only the Git, tmux, and Neovim configurations into their own Stow packages.
- [ ] Leave `shell/.zshrc` untouched so private and macOS-specific shell configuration is not included in the GPU profile.
- [ ] Verify the package roots contain only the intended configuration.

### Task 2: Specify bootstrap behavior with a failing test

**Files:**
- Create: `tests/bootstrap.sh`
- Create: `bootstrap.sh`

- [ ] Write a shell test that runs `bootstrap.sh` with mocked `apt-get`, `curl`, `tar`, and `stow` commands.
- [ ] Verify the test fails because `bootstrap.sh` does not exist.
- [ ] Implement the smallest Bash script that installs `stow`, `tmux`, `unzip`, and `ripgrep`; installs pinned Neovim under `/opt`; and stows `git`, `tmux`, and `nvim`.
- [ ] Run the test and `bash -n bootstrap.sh`.

### Task 3: Commit the verified change

**Files:**
- Modify: all files from Tasks 1-2

- [ ] Review `git diff --check` and the test output.
- [ ] Commit only the GPU bootstrap files and the package moves with a simple title.
