set PATH $PATH ~/.bin ~/.config/composer/vendor/bin

# --files: List files that would be searched but do not search
# --hidden: Search hidden files and folders
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
set FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --ignore-case --glob "!.git/*" --glob "!docs/*" --glob "!vendor/*" --color "always" --threads 0'
set FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

set EDITOR nvim
set VISUAL nvim

function fish_mode_prompt
  # NOOP - Disable vim mode indicator
end

function fish_greeting
end
