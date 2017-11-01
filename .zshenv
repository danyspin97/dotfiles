ENHANCD_FILTER=fzf

FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
FZF_DEFAULT_OPTS='--inline-info --preview-window right:40% --preview "ccat -C always {}"
  --color=bg+:#3c3836,bg:#1d2021,spinner:#fb4934,hl:#586e75
  --color=fg:#ebdbb2,header:#928374,info:#689d6a,pointer:#fb4934
  --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'
FZF_CTRL_T_COMMAND='rg --files --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!docs/*" --glob "!build/*" --glob "!opt/*" --glob "!vendor/*" --threads 0'
FZF_CTRL_R_OPTS="--preview-window up:1 --preview 'echo {}'"
FZF_ALT_C_OPTS="--preview-window right:40% --preview 'ls -A -F -h --color=always -1 {}'"
FZF_CTRL_T_OPTS="--preview-window right:70% --preview '(termpix --width 100 {} || ccat -C always {}) 2> /dev/null'"
FZF_TMUX=1
FZF_TMUX_HEIGHT="70%"

SAVEHIST=100000
HISTFILE=~/.zsh_history
HISTSIZE=100000000

# Reduce delay between esc and mode change
KEYTIMEOUT=1

# Change default C and C++ compiler
CC=/usr/lib/llvm/4/bin/clang
CXX=/usr/lib/llvm/4/bin/clang++

VISUAL=nvim
EDITOR=nvim
SUDO_EDITOR=nvim
MANPAGER="nvr --remote-tab-wait-silent -c 'set ft=man' -"

PATH=$PATH:~/.bin:~/.config/composer/vendor/bin:/sbin:/usr/sbin:~/go/bin:~/.local/bin:~/.gem/ruby/2.2.0/bin:~/.cargo/bin

XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_DATA_HOME="$HOME/.local/share"

NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
