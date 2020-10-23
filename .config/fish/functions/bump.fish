function bump
    sudo cave sync -s local $argv[1]
    sudo cave resolve -x $argv[2] $argv[3] $argv[4] $argv[5]
end
