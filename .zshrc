# Created by newuser for 5.3.1
source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# zsh-syntax-highlighting must be loaded
# after executing compinit command and sourcing other plugins
zplug "zdharma/fast-syntax-highlighting", defer:2

zplug "subnixr/minimal", use:minimal.zsh

zplug "zsh-users/zsh-autosuggestions"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# set vim mode
bindkey -v

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use ag instead of the default find command for listing candidates.
# - The first argument to the function is the base path to start traversal
# - Note that ag only lists files not directories
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    ag -g "" "$1"
}

FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
FZF_DEFAULT_OPTS='--inline-info --preview "ccat -C always {}"
  --color=bg+:#3c3836,bg:#1d2021,spinner:#fb4934,hl:#586e75
  --color=fg:#ebdbb2,header:#928374,info:#689d6a,pointer:#fb4934
  --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'
FZF_CTRL_T_COMMAND='rg --files --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!docs/*" --glob "!build/*" --glob "!opt/*" --glob "!vendor/*" --threads 0'
FZF_CTRL_R_OPTS="--preview-window up:1 --preview 'echo {}'"
FZF_ALT_C_OPTS="--preview-window right:40% --preview 'ls {}'"
FZF_CTRL_T_OPTS="--preview-window right:70% --preview '(termpix --width 100 {} || ccat -C always {}) 2> /dev/null'"
FZF_TMUX=1
FZF_TMUX_HEIGHT="70%"

export FZF_DEFAULT_COMMAND FZF_DEFAULT_OPTS FZF_CTRL_T_COMMAND FZF_TMUX FZF_CTRL_R_OPTS FZF_ALT_C_OPTS

setopt share_history
setopt hist_ignore_dups

SAVEHIST=100000
HISTFILE=~/.zsh_history
HISTSIZE=100000000
export SAVEHIST HISTFILE HISTSIZE

# Reduce delay between esc and mode change
export KEYTIMEOUT=1

# Change default C and C++ compiler
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

vi-append-x-selection () { RBUFFER=$(xsel -o -p </dev/null)$RBUFFER; }
zle -N vi-append-x-selection
bindkey '^X' vi-append-x-selection
vi-yank-x-selection () { print -rn -- $CUTBUFFER | xsel -i -p; }
zle -N vi-yank-x-selection
bindkey -a '^Y' vi-yank-x-selection

# Use vim cli mode
bindkey '^P' up-history
bindkey '^N' down-history

# backspace working even after
# returning from command mode
bindkey '^?' backward-delete-char

# ctrl-w removed word backwards
bindkey '^w' backward-kill-word

# ctrl-r starts searching history backward
#bindkey '^r' history-incremental-search-backward

### autosuggestion
bindkey '^ ' autosuggest-accept
bindkey '^o' autosuggest-execute

VISUAL=nvim
EDITOR=nvim
SUDO_EDITOR=nvim
export VISUAL EDITOR SUDO_EDITOR

export PATH=~/.bin/:~/.config/composer/vendor/bin:$PATH

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

if ls --color -d . >/dev/null 2>&1; then  # GNU ls
  export COLUMNS  # Remember columns for subprocesses.
  eval "$(dircolors)"
  function ls {
    command ls -F -h --color=always -v --author --time-style=long-iso -C "$@" | less -R -X -F
  }
  alias ll='ls -l'
  alias l='ls -l -a'
fi
