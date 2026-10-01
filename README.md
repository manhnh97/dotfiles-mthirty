# dotfiles-mthirty

Keyboard-first shell, Neovim, and tmux. The command line uses Vi. Neovim uses the same Space leader as Cursor. tmux is how you keep several directories open.

Works on macOS. Linux skips the Homebrew paths in `shell/local.zsh.example`.

## New user

You need git, zsh, and a network connection. On a Mac, install [Homebrew](https://brew.sh) first.

1. Install Oh My Zsh, the prompt, and the two shell plugins:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
```

2. Install the tools the aliases expect. On a Mac:

```bash
brew install eza bat fzf ripgrep fd zoxide git-delta lazygit neovim tmux
```

On Linux, install the same packages with your package manager. `eza` is the maintained `ls` replacement.

3. Clone this repo and link it into your home directory:

```bash
git clone https://github.com/manhnh97/dotfiles-mthirty.git ~/workspaces/dotfiles-mthirty
cd ~/workspaces/dotfiles-mthirty
./install.sh
exec zsh
```

`install.sh` is safe to run again. It symlinks the files below and, if a real file is already in the way, renames it to `*.pre-dotfiles`. It also installs Neovim and tmux when Homebrew is present and they are missing, clones fzf-lua for Neovim, and points git at `git/config`.

4. Open a new terminal tab. The prompt should show the current directory and, inside a git repo, the branch name.

5. Edit the machine file if this computer has its own tools:

```bash
nvim ~/.config/mthirty/local.zsh
```

That file is created from `shell/local.zsh.example` and is not committed. Put JDK, Android SDK, nvm, and anything else that exists only on this machine there. Missing directories are skipped, so the example is safe to leave as-is.

In Warp, set **Settings > Appearance > Input** to **Shell (PS1)** so this prompt is the one you see. Set **Enforce minimum contrast** to **Never** if the prompt colors look gray.

6. On a Mac, apply the keyboard settings:

```bash
./macos/keyboard.sh
```

That turns off the accent popup so held keys repeat, speeds up the repeat, lets Tab reach every control, and starts Rectangle. Snap the focused window with Control-Option and an arrow. Control-Option-Return fills the screen. Log out once if Tab still skips buttons.

## Daily use

The command line is Vi.

| Keys | Action |
|---|---|
| `fj` | Leave insert mode |
| `v` | Open the current command in Neovim |
| `Ctrl-F` or Right arrow | Accept the gray suggestion |
| `Ctrl-R` | Search history |
| `Ctrl-T` | Search files in this directory |
| `cdi` | Jump to a directory you have visited |

A command that starts with a space is not written to history.

| Command | Action |
|---|---|
| `v file` | Edit in Neovim |
| `ll` | Long listing, with git status |
| `lt` | Two-level tree |
| `work` | Go to `~/workspaces` |
| `cs dir` | Enter a directory and list it |
| `lg` | lazygit |
| `g st` | Short git status. Also `g df`, `g lg`, `g cm` |
| `venv` | Create `.venv` with uv and activate it |
| `ports` | Show listening TCP ports. `ports 8200` checks one |
| `hosts` | List SSH servers from `~/.ssh/config` |
| `s` | Pick an SSH server and connect. `s name` skips the picker |
| `identify file` | File type and the first 64 bytes |
| `reload` | Restart the shell |

`cd projects/api` jumps by a partial name after you have been there once. A full path still works. `builtin cd` is plain `cd`.

## Neovim

Open it with `v`. Leader is Space.

| Keys | Action |
|---|---|
| `fj` | Leave insert mode |
| `Space f` | Find a file |
| `Space /` | Search file contents |
| `Space b` | Switch buffer |
| `H` / `L` | Previous / next buffer |
| `Space v` / `Space s` | Vertical / horizontal split |
| `Space w` / `Space q` / `Space x` | Save / quit / save and quit |
| `Space p` | Format Python with ruff, or JS/TS with the project's prettier |
| `J` / `K` | Move the line down / up |
| `Space t` | Flip true/false under the cursor |
| `[d` / `]d` | Previous / next diagnostic |

`nvim .` still uses netrw when you want a directory listing inside the editor.

## tmux

`tm` attaches a session named after the current directory. `tm api` picks the name. From inside tmux it switches to that session instead of nesting.

Prefix is `Ctrl-a`. The status bar shows `PREFIX` while it waits for the next key.

| Keys | Action |
|---|---|
| `Ctrl-a` then `\|` | Split left and right |
| `Ctrl-a` then `-` | Split top and bottom |
| `Ctrl-a` then `h` `j` `k` `l` | Move between panes |
| `Ctrl-a` then `H` `J` `K` `L` | Resize the pane |
| `Ctrl-a` then `c` | New window, same directory |
| `Ctrl-a` then `s` | Session list |
| `Ctrl-a` then `[`, then `v`, then `y` or Enter | Select text. The selection replaces the clipboard |
| Drag, double-click, or triple-click | Copy the selection, the word, or the line |

Esc in Neovim stays instant. tmux does not delay it.

## Layout

| Path | Role |
|---|---|
| `install.sh` | Symlink into `$HOME` and install Neovim, tmux, fzf-lua |
| `shell/zshrc` | Prompt, history, fzf, zoxide |
| `shell/aliases.zsh` | Short commands |
| `shell/functions.zsh` | `cs`, `ports`, `venv`, `identify`, `hosts`, `s`, `tm` |
| `shell/vimmode.zsh` | Vi keys on the command line |
| `shell/p10k.zsh` | Prompt. Directory and branch are plain text |
| `shell/local.zsh.example` | Template for this machine's PATH |
| `.config/nvim` | Neovim |
| `.config/tmux/tmux.conf` | Panes and sessions |
| `git/config` | Neovim as the git editor, short git aliases |
| `.scripts/.alias.sh` | Same short commands for bash |

`~/.config/mthirty/local.zsh` stays on the machine. Do not commit it.
