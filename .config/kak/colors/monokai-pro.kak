evaluate-commands %sh{
    base00='rgb:403e41'
    base01='rgb:ff6188'
    base02='rgb:a9dc76'
    base03='rgb:ffd866'
    base04='rgb:FC9867'
    base05='rgb:ab9df2'
    base06='rgb:78dce8'
    base07='rgb:fcfcfa'
    base08='rgb:727072'
    base09='rgb:ff6188'
    base0A='rgb:a9dc76'
    base0B='rgb:ffd866'
    base0C='rgb:FC9867'
    base0D='rgb:ab9df2'
    base0E='rgb:78dce8'
    base0F='rgb:fcfcfa'

    fg='rgb:fcfcfa'
    bg='rgb:1c1c1c'

    statusLineFg='rgb:403e41'

    ## code
    echo "
        face global attribute ${base0A}+b
        face global builtin ${base0D}+b
        face global class ${base0B}+i
        face global comment ${base0E}+i
        face global enum ${base0B}+b
        face global function ${base0E}+b
        face global identifier ${base06}+i
        face global interface ${base04}
        face global keyword ${base0C}+i
        face global label ${base0E}
        face global macro ${base05}
        face global member ${base06}
        face global meta ${base0D}
        face global module ${base0A}
        face global namespace ${base0A}
        face global number ${base01}
        face global operator ${base05}
        face global parameter ${base0A}+i
        face global property ${base04}
        face global regexp ${base0E}
        face global string ${base0D}+i
        face global struct ${base0C}
        face global type ${base03}+i
        face global typeParameter ${base08}
        face global value ${base09}
        face global variable ${base02}
        "

    ## markup
    echo "
        face global title ${base0D}+b
        face global header ${base0D}+b
        face global bold ${base0A}+b
        face global italic ${base0E}
        face global mono ${base0B}
        face global block ${base0C}
        face global link ${base09}
        face global bullet ${base08}
        face global list ${base08}
    "

    ## builtin
    echo "
        face global Default ${fg},${bg}
        face global PrimarySelection ${fg},${base04}
        face global SecondarySelection ${base06},${base0F}
        face global PrimaryCursor ${bg},${fg}
        face global SecondaryCursor ${base06},${base0C}
        face global PrimaryCursorEol ${bg},${base06}
        face global SecondaryCursorEol ${bg},${base06}
        face global LineNumbers ${fg},${bg}
        face global LineNumberCursor ${bg},${fg}
        face global MenuForeground ${base00},${base03}
        face global MenuBackground ${fg},${base00}
        face global MenuInfo ${base02}
        face global Information ${base00},${base03}
        face global Error ${base00},${base09}
        face global StatusLine ${base06},${bg}
        face global StatusLineMode ${base0B}
        face global StatusLineInfo ${base0C}
        face global StatusLineValue ${base0C}
        face global StatusCursor ${base00},${base05}
        face global Prompt ${base0B},${bg}
        face global MatchingChar ${fg},${bg}+b
        face global Whitespace ${base08},${bg}
        face global WrapMarker ${base06},${base02}
        face global BufferPadding ${base08},${bg}
    "

    # Plugins config
    echo "
        face global InactiveCursor default,${base00}
        face global Volatile default,${base05}
        face global EasyMotionBackground ${base08}+b
        face global EasyMotionForeground ${base09}+fgb
        face global EasyMotionSelected ${base03}+fgb
    "
}
