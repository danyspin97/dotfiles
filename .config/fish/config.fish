set fish_home $XDG_CONFIG_HOME/fish

set PATH $HOME/.local/bin:$HOME/.cargo/bin:/usr/local/benice:/usr/bin

# Remove greeting
set fish_greeting

# Use starship as prompt
source $fish_home/starship.fish

# Add z command
source $fish_home/zoxide.fish

# Add thefuck
source $fish_home/thefuck.fish

# Load grc
source /etc/grc.fish
