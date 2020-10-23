
# Add benice to PATH
set -U fish_user_paths /usr/local/benice $fish_user_paths

# Remove greeting
set fish_greeting

# Use starship as prompt
starship init fish | source

# Add z command
zoxide init fish | source

# Add thefuck
thefuck --alias | source 

# Load grc
source /etc/grc.fish
