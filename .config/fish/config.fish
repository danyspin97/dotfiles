set fish_home $XDG_CONFIG_HOME/fish

set PATH $HOME/nvim-linux64/bin:$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/bin:/usr/lib64/ccache:/usr/bin

# Remove greeting
set fish_greeting

# Use starship as prompt
source $fish_home/starship.fish

# Setup thefuck
source $fish_home/thefuck.fish

# atuin
set -gx ATUIN_NOBIND "true"
source $fish_home/atuin.fish

bind \cr _atuin_search
bind -M insert \cr _atuin_search

fish_ssh_agent

# Add z command
#source $fish_home/zoxide.fish

# Load grc
#source /etc/grc.fish

. "$XDG_DATA_HOME"/xdg-apply/aliases
