fn git-branch-name {
    try {
        git-branch = ( git branch 2> /dev/null )
        name = ( echo $git-branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' )
        style = gray
        if ?(git-is-modified) {
            style = italic
        } else {
            style = bold
        }
        edit:styled $name $style
    } except 128 {
        put ""
    }
}

fn git-is-modified {
    try {
        modified = ( git status | rg -q 'modified:' )
        true
    } except 1 {
        false
    }
}

# "tilde-abbr" abbreviates home directory to a tilde.
edit:prompt = {
    edit:styled (tilde-abbr $pwd) lightblue
    put " "
    git-branch-name
    put "\n" (edit:styled "μ"  green) " › "
}

# "constantly" returns a function that always writes the same value(s) to
# output; "edit:styled" writes styled output.
edit:rprompt = (constantly (edit:styled (whoami)@(hostname) gray))

edit:-matcher[''] = [p]{ edit:match-prefix &smart-case $p }

use readline-binding

edit:insert:binding[Ctrl-X] = { edit:current-command = $edit:current-command(xsel -b) }

paths = [ $@paths ~/.bin ~/.config/composer/vendor/bin /sbin /usr/sbin ~/go/bin ~/.local/bin ~/.gem/ruby/2.2.0/bin ~/.cargo/bin ~/.fzf/bin ]

# neovim remote
fn v [@a]{ nvr --remote-wait-silent $@a }
fn vs [@a]{ nvr --remote-wait-silent -o $@a }
fn vv [@a]{ nvr --remote-wait-silent -O $@a }
fn vt [@a]{ nvr --remote-tab-wait-silent $@a }

fn ls [@a]{ e:ls -F -h --color=always -v --author --time-style=long-iso -C $@a | e:less -R -X -Fs }

fn tb []{ nc termbin.com 9999 }

# Vim keybindings

fn history {
 edit:command-history | each [x]{ echo $x[ id ]" "$x[ cmd ] } | fzf
}

# FZF bindings
#edit:insert:binding[Ctrl-R] = { history }
