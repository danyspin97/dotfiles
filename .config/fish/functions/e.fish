function e
    set file (search_f | fzy)
    if ! test -z $file
        kak $file
    end
end

