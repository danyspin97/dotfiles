function fish_mode_prompt
  # NOOP - Disable vim mode indicator
end

function fish_greeting
end

# Abbreviation for pj open
abbr -a pjo pj open

# Add path variable for pj
set -gx PROJECT_PATHS ~/workspace
