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
