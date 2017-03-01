set PATH $PATH ~/.config/composer/vendor/bin ~/.gem/ruby/2.4.0/bin

# --files: List files that would be searched but do not search
# --hidden: Search hidden files and folders
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
set FZF_DEFAULT_COMMAND 'rg --files --hidden --glob "!.git/*"'
set FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

function fish_mode_prompt
  # NOOP - Disable vim mode indicator
end

function fish_greeting
end
