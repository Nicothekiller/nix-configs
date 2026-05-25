# config.nu
#
# Installed by:
# version = "0.104.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# zoxide
source ~/.zoxide.nu

# starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# env
$env.config.buffer_editor = "nvim"
$env.EDITOR = "nvim"
$env.config.show_banner = false
$env.config.edit_mode = "vi"

# for python venv, starship already does this.
$env.VIRTUAL_ENV_DISABLE_PROMPT = true

# add .local/bin to path
$env.PATH = ($env.PATH | append [$"($env.HOME)/.local/bin", $"($env.HOME)/.cargo/bin"])

# aliases
alias lg = lazygit
alias cat = bat
alias cd = z
alias ip = ip -color

# functions

# For searching arch packages and their info
def pacbrowse [] {
  pacman -Slq | fzf --multi --preview 'pacman -Si {1}'
}
# For searching arch/aur packages and their info
def yaybrowse [] {
  yay -Slq | fzf --multi --preview 'yay -Si {1}'
}

# For renaming tabs in kitty more easily
def krn [str: string] {
  kitten @ set-tab-title $str
}

# Opens a dev setup in kitty.
#
# By default, it opens:
# - Neovim in the current tab
# - Opencode in another tab (only when -o / --opc is passed)
# - A tab for commands
def dev [
  --opc (-o) # Include an opencode tab
  --nix-shell (-n) # Run nix develop as well
] {
  if not $nix_shell {
    kitten @ set-tab-title nvim
    if $opc {
      kitten @ launch --type=tab --title=opencode --cwd=current -- nu -e opencode
    }
    kitten @ launch --type=tab --title=commands --cwd=current
    kitten @ send-text "nvim\n"
  } else {
    kitten @ set-tab-title nvim
    if $opc {
      kitten @ launch --type=tab --title=opencode --cwd=current -- nix develop -c -- nu -e opencode
    }
    kitten @ launch --type=tab --title=commands --cwd=current -- nix develop -c nu
    kitten @ send-text "nix develop -c -- nu -e nvim\n"
  }
}

# carapace config
source $"($nu.cache-dir)/carapace.nu"
