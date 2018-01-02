fn git-branch-name {
    try {
        name = ( git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' )
        style = "italic;lightgray"
        modified = ""
        # Have files been modified?
        if ?( git status | rg -q '(Changes not staged for commit)|(Untracked files):' ) {
            modified = ( edit:styled "*" bold )
        } elif ?( git status | rg -q '(Changes to be committed)|(new file):' ) {
            modified = ( edit:styled "✚" bold )
        } else {
            modified = ( edit:styled "✔" bold )
        }
        name = ( edit:styled $name $style )
        put $modified $name
    } except e {
        put ""
    }
}

# "tilde-abbr" abbreviates home directory to a tilde.
edit:prompt = {
    edit:styled (tilde-abbr $pwd) lightblue
    put " "
    git-branch-name
    put "\n" (edit:styled "μ" green) " › "
}

# "constantly" returns a function that always writes the same value(s) to
# output; "edit:styled" writes styled output.
edit:rprompt = (constantly (edit:styled (whoami)@(hostname) gray))

edit:-matcher[''] = [p]{ edit:match-prefix &smart-case $p }

use readline-binding

edit:insert:binding[Ctrl-X] = { edit:current-command = $edit:current-command(xsel -b) }
#edit:insert:binding[!!] = { edit:current-command = $edit }

paths = [
    $@paths
    ~/.bin
    ~/.config/composer/vendor/bin
    /sbin
    /usr/sbin
    ~/go/bin
    ~/.local/bin
    ~/.gem/ruby/2.2.0/bin
    ~/.cargo/bin
    ~/.fzf/bin
]

# neovim remote
fn v [n @a]{ E:NVIM_LISTEN_ADDRESS="/tmp/nvimsocket"$n nvr --remote-silent $@a }
fn v [@a]{ nvr --remote-silent $@a }
fn vs [n @a]{ E:NVIM_LISTEN_ADDRESS=/tmp/nvimsocket$n nvr --remote-silent -o $@a }
fn vv [n @a]{ E:NVIM_LISTEN_ADDRESS=/tmp/nvimsocket$n nvr --remote-silent -O $@a }
fn vt [n @a]{ E:NVIM_LISTEN_ADDRESS=/tmp/nvimsocket$n nvr --remote-tab-silent $@a }

fn ls [@a]{ e:ls -F -h --color=always -v --author --time-style=long-iso -C $@a | e:less -R -X -Fs }

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


# Change default C and C++ compiler
E:CC=/usr/lib/llvm/4/bin/clang
E:CXX=/usr/lib/llvm/4/bin/clang++

E:VISUAL=nvim
E:EDITOR=nvim
E:SUDO_EDITOR=nvim
E:MANPAGER="nvr --remote-tab-silent -c 'set ft=man' -"

# Socket for neovim --remote
#E:NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

E:MINIKUBE_WANTUPDATENOTIFICATION=false
E:MINIKUBE_WANTREPORTERRORPROMPT=false
E:MINIKUBE_HOME=$E:HOME
E:CHANGE_MINIKUBE_NONE_USER=true
E:KUBECONFIG=$E:HOME/.kube/config

E:AUTOSSH_PORT=0
