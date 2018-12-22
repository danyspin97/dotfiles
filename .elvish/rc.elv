# Get env variables
use env
# Load prompt
use prompt
use readline-binding

use asciinema

# Manage elvish module
use epm
epm:install &silent-if-installed=$true   \
  github.com/zzamboni/elvish-modules     \
  github.com/zzamboni/elvish-completions \
  github.com/zzamboni/elvish-themes      \
  github.com/xiaq/edit.elv               \
  github.com/muesli/elvish-libs

# Git utilities
#use github.com/muesli/elvish-libs/git
# Git completion
use github.com/zzamboni/elvish-completions/git
# Long running notifications
use github.com/zzamboni/elvish-modules/long-running-notifications
# Recall last command
use github.com/zzamboni/elvish-modules/bang-bang
# Set the terminal title automatically
use github.com/zzamboni/elvish-modules/terminal-title
# Utility
use github.com/zzamboni/elvish-modules/util



#edit:-matcher[''] = [p]{ edit:match-prefix &smart-case $p }

#edit:insert:binding[Ctrl-X] = { edit:current-command = $edit:current-command(xsel -b) }
#edit:insert:binding[!!] = { edit:current-command = $edit }

paths = [
    $@paths
    ~/.bin
    ~/.config/composer/vendor/bin
    ~/.go/bin
    ~/.local/bin
    ~/.gem/ruby/2.2.0/bin
    ~/.gem/ruby/2.5.0/bin
    ~/.cargo/bin
    ~/.fzf/bin
]

# neovim remote
#fn v [n @a]{ E:NVIM_LISTEN_ADDRESS="/tmp/nvimsocket"$n nvr --remote-silent $@a }
fn v [@a]{ nvr --remote-silent $@a }
fn vs [@a]{ E:NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvr --remote-silent -o $@a }
fn vv [@a]{ E:NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvr --remote-silent -O $@a }
fn vt [@a]{ E:NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvr --remote-tab-silent $@a }

fn ls [@a]{ e:exa --color=always --all --long --time-style=long-iso --git --git-ignore --extended --group-directories-first $@a | e:less -R -X -Fs }

fn dmesg [@a]{ e:dmesg --color=always $@a | e:less -R -X -Fs }

fn tb []{ nc termbin.com 9999 }

fn tmuxrc []{ tmux new-session -s app weechat }

# Vim keybindings

fn history {
    edit:command-history | each [x]{ echo $x[ id ]" "$x[ cmd ] } | fzf
}

fn ssh [@a]{
    autossh $@a
}

fn steam-wine [@a]{
   E:WINEDEBUG=-all wine "C:\\Program Files (x86)\\Steam\\Steam.exe" "$@a"
}

# FZF bindings
#edit:insert:binding[Ctrl-R] = { history }


