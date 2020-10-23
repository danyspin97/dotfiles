function up
    if test -z $argv[1]
        cd ..
        return
    end
    set d "."
    for i in (seq $argv[1])
        set d $d/..
    end
    cd $d
end
