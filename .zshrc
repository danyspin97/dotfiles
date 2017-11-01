# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# zsh-syntax-highlighting must be loaded
# after executing compinit command and sourcing other plugins
zplug "zdharma/fast-syntax-highlighting", defer:2

zplug "subnixr/minimal", use:minimal.zsh

zplug "zsh-users/zsh-autosuggestions"

zplug "b4b4r07/enhancd", use:init.sh

zplug "djui/alias-tips"

zplug "Tarrasch/zsh-bd"

zplug "zsh-users/zsh-completions", defer:2

zstyle ':completion::complete:*' use-cache 1

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

setopt share_history
setopt hist_ignore_dups

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

### aliases
# git
alias ga='git add'

# neovim
alias v='NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvr -s'
alias vs='NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvr -s -o'
alias vv='NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvr -s -O'
alias vt='NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvr -s -cc "tabnew"'

# termbin
alias tb='nc termbin.com 9999'

if ls --color -d . >/dev/null 2>&1; then  # GNU ls
  export COLUMNS  # Remember columns for subprocesses.
  eval "$(dircolors)"
  function ls {
    command ls -F -h --color=always -v --author --time-style=long-iso -C "$@" | less -R -X -F
  }
  alias ll='ls -l'
  alias l='ls -l -a'
fi
