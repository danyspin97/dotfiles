function ke
    set file (search_f | fzy)
    if ! test -z $file
        k $file
    end
end

