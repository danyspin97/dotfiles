let g:mapleader="\<SPACE>"
set encoding=utf8
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set showmode           " Show current mode.
set ruler               " Show the line and column numbers of the cursor.
set number              " Show the current line number
set formatoptions+=o    " Continue comment marker in new lines.
set textwidth=0         " Hard-wrap long lines as you type them.
set expandtab           " Insert spaces when TAB is pressed.
set nosmarttab
set tabstop=4           " Render TABs using this many spaces.
set shiftwidth=4        " Indentation amount for < and > commands.
set noshowmode          " Hide the default mode text (e.g. -- INSERT -- below the statusline)

set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]

set cursorline
set cursorcolumn

set relativenumber      " Show the line numbers on the left side.
setglobal relativenumber

set modeline            " Enable modeline.
set linespace=0         " Set line-spacing to minimum.
set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)

" More natural splits
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

set display+=lastline
set nostartofline       " Do not jump to first character with page commands.

set updatetime=500 " Let plugins show effects after 500ms, not 4s
set mouse-=a " Disable mouse click to go to position

" Don't let autocomplete affect usual typing habits
set completeopt=menuone,preview,noinsert

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store/docs?/

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hidden

" Render characters quickly
set ttyfast

" How many tenths of a second to blink when matching brackets
set matchtime=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=

set ttimeout
set ttimeoutlen=0

" Tell Vim which characters to show for expanded TABs,
" and end-of-lines.
if &listchars ==# 'eol:$'
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

set list                " Show problematic characters.

"set ignorecase          " Make searching case-insensitive
"set smartcase           " ... unless the query has capital letters.
set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set magic               " Use 'magic' patterns (extended regular expressions).
set incsearch

" Disable swap and backup
set nobackup
set noswapfile
set nowritebackup

" Linebreak on 500 characters
set linebreak
set textwidth=500

"Smart indent
set smartindent
"Wrap lines
set wrap

set shell=/usr/bin/bash

set grepprg=rg\ --vimgrep

set colorcolumn=80

" Enable sql query syntax hightlighting in php files
let g:php_sql_query = 1
" Enable html syntax hightlighting in php files
let g:php_htmlInStrings = 1

" Remap comma to double dots
map , :

nnoremap <Leader>w :w!<CR>
nnoremap <Leader>W :SudoEdit<CR>

" Reload config on savings
autocmd! bufwritepost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim

map <Leader>c :tabedit ~/.config/nvim/init.vim<CR>

" Ex command control
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Cancel a search with esc
nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR>

" Linux / windows ctrl+backspace ctrl+delete
" Note that ctrl+backspace doesn't work in Linux, so ctrl+\ is also available
imap <C-backspace> ú
imap <C-\> ú
imap <C-delete> ø

" Relative numbering
function! NumberToggle()
    if(&relativenumber == 1)
        set norelativenumber
    else
        set relativenumber
    endif
endfunc

" Toggle between normal and relative numbering.
nnoremap <Leader>r :call NumberToggle()<cr>

" Easy window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Remapping for switching windows when in terminal
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" and in insert mode
inoremap <C-h> <Esc><C-w>h
inoremap <C-j> <Esc><C-w>j
inoremap <C-k> <Esc><C-w>k
inoremap <C-l> <Esc><C-w>l

map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Close all open windows
noremap <C-q><C-q> :confirm qall<CR>

set lazyredraw
syntax sync minlines=128

" Wvp doesn't replace paste buffer
function! RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunction
function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

au BufEnter * set noro

" Send lines in range to hastebin.com and copy url to clipboard
command! -range -bar Haste <line1>,<line2>w !haste | xsel -b

if has('nvim')
  let $VISUAL = 'nvr -cc split --remote-wait'
endif

" Neovim Terminal Colors
let g:terminal_color_0  = '#1d2021'
let g:terminal_color_1  = '#cc241d'
let g:terminal_color_2  = '#98971a'
let g:terminal_color_3  = '#d79921'
let g:terminal_color_4  = '#458588'
let g:terminal_color_5  = '#b16286'
let g:terminal_color_6  = '#689d6a'
let g:terminal_color_7  = '#a89984'
let g:terminal_color_8  = '#928374'
let g:terminal_color_9  = '#fb4934'
let g:terminal_color_10 = '#b8bb26'
let g:terminal_color_11 = '#fabd2f'
let g:terminal_color_12 = '#83a598'
let g:terminal_color_13 = '#d3869b'
let g:terminal_color_14 = '#8ec07c'
let g:terminal_color_15 = '#ebdbb2'

augroup term
    autocmd!
    autocmd TermOpen * IndentLinesDisable
    autocmd TermOpen * set noshowmode
    autocmd TermOpen * set noruler
    autocmd TermOpen * set noshowcmd
    "
    " Get terminal get input focus when switching to terminal window
    autocmd BufEnter term://* startinsert
    autocmd BufLeave term://* stopinsert
augroup END

" Donwload vim-plug if missing
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

function! BuildComposer(info)
    if a:info.status != 'unchanged' || a:info.force
        if has('nvim')
            !cargo build --release
        else
            !cargo build --release --no-default-features --features json-rpc
        endif
    endif
endfunction

""" vim-plug shortcuts
map <Leader>pi :PlugInstall<CR>
map <Leader>pu :PlugUpdate<CR>
map <Leader>pp :PlugUpgrade<CR>
map <Leader>pc :PlugClean<CR>

call plug#begin()

" Undo changes
Plug 'mbbill/undotree'
" Open undotree window
nnoremap <F5> :UndotreeToggle<cr>
" Focus undotree when showing it
let g:undotree_SetFocusWhenToggle = 1
" Add persistent undo history between files
if has('persistent_undo')
    set undofile
endif

" Theme
Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italic=1

" Status line
" Plug 'vim-airline/vim-airline'
" Use powerline fonts
let g:airline_powerline_fonts = 1
" Use caching
let g:airline_highlighting_cache = 1
" Use gruvbox theme
let g:airline_theme='gruvbox'

let g:airline#extensions#tabline#enabled = 1

" Another theme
"Plug 'freeo/vim-kalisi'

" Nord theme
Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_uniform_status_lines = 1
let g:nord_comment_brightness = 20
let g:nord_uniform_diff_background = 1

" Add icons
"Plug 'ryanoasis/vim-devicons'
let g:WebDevIconsOS = 'Linux'

" Hightlight html color tags
Plug 'lilydjwg/colorizer'

" File explorer
"Plug 'scrooloose/nerdtree'
" Close NerdTree if it is the onyl windows open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Open NerdTree with ctrl+n
map <Leader>n :NERDTreeToggle<CR>
" and toggle with double n
map <Leader>nn :NERDTreeToggle<CR>
" Show hidden file
let g:NERDTreeShowHidden=1
" Ignore file
let g:NERDTreeIgnore=['\.DS_Store', '\~$', '\.swp']
" Arrows
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
" Symbols
let g:NERDTreeIndicatorMapCustom = {
            \ 'Modified'  : '✹',
            \ 'Staged'    : '✚',
            \ 'Untracked' : '✭',
            \ 'Renamed'   : '➜',
            \ 'Unmerged'  : '═',
            \ 'Deleted'   : '✖',
            \ 'Dirty'     : '✗',
            \ 'Clean'     : '✔︎',
            \ 'Unknown'   : '?'
            \ }

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
" Fzz colors
let g:fzf_colors =
            \ { 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }
" Jump to the existing window if possible
let g:fzf_buffers_jump = 1
let $FZF_DEFAULT_COMMAND = 'rg --files --no-messages'
" Call fzf
noremap <Leader>z :Files<CR>
noremap <Leader>t :BTags<CR>
noremap <Leader>l :Lines<CR>
noremap <Leader>b :Buffers<CR>
noremap <Leader>d :exe ':Look ' . expand('<cword>')<CR>
" Find command using fzf and ripgrep
command! -bang -nargs=* Look
  \ call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!docs?/*" --glob "!build/*" --glob "!opt/*" --glob "!vendor/*" --color "always" --threads 0 --no-messages '
  \   .shellescape(<q-args>), 1,
  \   fzf#vim#with_preview('up:60%'),
  \   <bang>0)
map <Leader>a :Look<CR>

augroup fzf_buffer
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

" Fuzzy search over the text
Plug 'ggVGc/vim-fuzzysearch'
let g:fuzzysearch_hlsearch = 1
let g:fuzzysearch_ignorecase = 1
let g:fuzzysearch_max_history = 30
let g:fuzzysearch_match_spaces = 1
" Open fuzzy search
nnoremap <Leader>/ :FuzzySearch<CR>
" Fast replace text
nnoremap <Leader>R :%s///g<left><left>

" Automaticcaly create dir when saving files
Plug 'pbrisbin/vim-mkdir'

" HTML syntax
Plug 'tpope/vim-eunuch'

" Open the file where it was closed
Plug 'dietsche/vim-lastplace'

" Quick windows close
Plug 'vim-scripts/quit-another-window'
nnoremap <Leader>qh :Qh <CR>
nnoremap <Leader>qj :Qj <CR>
nnoremap <Leader>qk :Qk <CR>
nnoremap <Leader>ql :Ql <CR>

" Swap windows
Plug 'wesQ3/vim-windowswap'
let g:windowswap_map_keys = 0 "prevent default bindings
nnoremap <silent> <leader>yy :call WindowSwap#EasyWindowSwap()<CR>

" Search the selected text using *
"Plug 'nelstrom/vim-visual-star-search'

" Version control
Plug 'tpope/vim-fugitive'

" Integration with github
Plug 'roxma/ncm-github'

" Autocompletition
Plug 'roxma/nvim-completion-manager'
" let g:cm_matcher = {'module': 'cm_matchers.abbrev_matcher', 'case': 'smartcase'}
let g:cm_multi_threading = 1
set shortmess+=c
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
        let $NVIM_NCM_LOG_LEVEL="DEBUG"
        let $NVIM_NCM_MULTI_THREAD=0

" Enhance repeat key
Plug 'tpope/vim-repeat'

" Enhance closing parenthesis
Plug 'tpope/vim-surround'

" Comment lines easily
Plug 'tpope/vim-commentary'

" Better scrolling
Plug 'terryma/vim-smooth-scroll'
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 5, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 5, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 5, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 5, 4)<CR>

"Plug 'reedes/vim-wheel'
" Remap keys
let g:wheel#map#up   = '<m-y>'
let g:wheel#map#down = '<m-e>'

" Move between text objects using CamelCase
Plug 'bkad/CamelCaseMotion'
" Map keys
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
map <silent> ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge

Plug 'matze/vim-move'

" Snippets
Plug 'SirVer/ultisnips'
" Change keymaps
let g:UltiSnipsExpandTrigger = '<C-j>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
" Split window as default action
let g:UltiSnipsEditSplit="vertical"

" Snippets for ultisnips
Plug 'honza/vim-snippets'

" Clipboard management
Plug 'vim-scripts/YankRing.vim'
" Show yankes
nnoremap <silent> <F6> :YRShow<CR>
" Increase window height
let g:yankring_window_height = 12
" Change keys for replacing
let g:yankring_replace_n_pkey = '<C-P>'
let g:yankring_replace_n_nkey = '<C-N>'

let g:yankring_max_history = 1000
let g:yankring_min_element_length = 3
let g:yankring_history_dir = '$HOME/.cache'

" Intend guides
Plug 'Yggdroot/indentLine'
" Set color for indenting character
let g:indentLine_color_gui = '#D8DEE9'
" Set new indenting char
let g:indentLine_char = '┆'
" Disable concealing
let g:indentLine_concealcursor = ''
" Set faster mode
let g:indentLine_faster=1
let g:indentLine_showFirstIndentLevel = 1

let g:indentLine_setColors=1

" Use editor config settings per project
Plug 'editorconfig/editorconfig-vim'

" Format using external tools
Plug 'sbdchd/neoformat'
" Disable alignment
let g:neoformat_basic_format_align = 0
" Enable tab to space conversion
let g:neoformat_basic_format_retab = 1
" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
" Disable formatting
let g:neoformat_enabled_sql = []
" Use formatprg
let g:neoformat_try_formatprg = 1
" Don't put message errors in code
let g:neoformat_only_msg_on_error = 1

" Automatically close Conditional statement in shell scripting
Plug 'tpope/vim-endwise'

" Enhance brackets and paranthesis
Plug 'jiangmiao/auto-pairs'

" Generate tags for code
Plug 'ludovicchabant/vim-gutentags'
" Enable
let g:gutentag_enabled = 1
" Set cache dir
let g:gutentags_cache_dir = '~/.cache/tags'

" HTML shortcuts
Plug 'mattn/emmet-vim'

" Language pack
Plug 'sheerun/vim-polyglot'

" Asynchronous build and make
Plug 'tpope/vim-dispatch'

" Golang plugin
Plug 'fatih/vim-go'
" Disable formatting on save, let neoformat handle this
let g:go_fmt_autosave = 0

augroup go_commands
    autocmd!
    autocmd FileType go nnoremap <Leader>gd :exe ':GoDoc ' . expand('<cword>')<CR>
    autocmd FileType go nnoremap <Leader>gb :GoBuild<CR>
    autocmd FileType go nnoremap <Leader>gr :GoRename<CR>
augroup END

" Refactoring
Plug 'brooth/far.vim'

" Debugging for php
"Plug 'joonty/vdebug'
" Debugging using clang
"Plug 'critiqjo/lldb.nvim'

" Linting
Plug 'w0rp/ale'
" Disable automatic lining on writing
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 0
" Enable completion where available.
let g:ale_completion_enabled = 1

nmap <silent> <Leader>fp <Plug>(ale_previous_wrap)
nmap <silent> <Leader>fn <Plug>(ale_next_wrap)

" Close vim if the last window open is quickfix
aug QuickFixClose
    au!
    au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END
let g:ale_linters = {
    \   'cpp': ['clang'],
    \   'java': ['javac'],
    \}
autocmd BufEnter *.cpp,*.h,*.hpp,*.hxx let g:ale_cpp_clang_options = join(ncm_clang#compilation_info()['args'], ' ')

" Writer plugins
Plug 'reedes/vim-pencil'
augroup Pencil
    autocmd!
    autocmd FileType markdown,mkd,asciidoc call EnterWriterMode()
augroup END

" Markdown preview in firefox
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

" Distraction free writing
Plug 'junegunn/goyo.vim'

" Enhance current line, hide useless information in other lines
Plug 'junegunn/limelight.vim'

" Tab keymaps
Plug 'DanySpin97/ttab.vim'
" Change key
let g:ttab_prefix = '<C-A>'
let g:ttab_shell = 'elvish'

Plug 'IN3D/vim-raml'

" requires phpactor
Plug 'phpactor/phpactor' ,  {'do': 'composer install'}

Plug 'roxma/ncm-phpactor'

Plug 'Shougo/neco-vim'
Plug 'Shougo/neco-syntax'
Plug 'Shougo/neoinclude.vim'
Plug 'calebeby/ncm-css'
Plug 'roxma/nvim-cm-tern',  {'do': 'npm install'}
Plug 'roxma/ncm-clang'
Plug 'fgrsnau/ncm-otherbuf'


" Browse documentation
Plug 'KabbAmine/zeavim.vim', {'on': [
            \   'Zeavim', 'Docset',
            \   '<Plug>Zeavim',
            \   '<Plug>ZVVisSelection',
            \   '<Plug>ZVKeyDocset',
            \   '<Plug>ZVMotion'
            \ ]}

Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
" Use one-character sneak instead of f
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
map m <Plug>Sneak_s
map <C-m> <Plug>Sneak_S

Plug 'dmix/elvish.vim', { 'on_ft': ['elvish']}

" Plug 'jaxbot/browserlink.vim'

Plug 'metakirby5/codi.vim'
let g:codi#rightsplit = 0
let g:codi#rightalign = 0

Plug 'arakashic/chromatica.nvim'
let g:chromatica#libclang_path = '/lib/libclang.so'
let g:chromatica#enable_at_startup = 1

" Needed by coquille
Plug 'let-def/vimbufsync'

Plug 'the-lambda-church/coquille'

" Plug 'nightsense/seagrey'

Plug 'donRaphaco/neotex', { 'for': 'tex' }

Plug 'joereynolds/SQHell.vim'

Plug 'qpkorr/vim-bufkill'

" TODO test
"Plug 'LucHermitte/vim-refactor'
"
" TODO test over far.vim
" Plug 'dkprice/vim-easygrep'
"
" TODO test
Plug 'gregsexton/gitv', { 'on': ['Gitv'] }

" TODO test
Plug 'tpope/vim-rsi'

Plug 'wellle/targets.vim'

" ttags_vim dependency
Plug 'tomtom/tlib_vim'
Plug 'tomtom/ttags_vim'

let g:ttags_display = 'tlib'

" Show available tags
noremap <Leader>g. :TTags<cr>

" Show current buffer's tags
noremap <Leader>g% :call ttags#List(0, "*", "", ".")<cr>

" Show tags matching the word under cursor
noremap <Leader>g# :call ttags#List(0, "*", tlib#rx#Escape(expand("<cword>")))<cr>

" Show tags with a prefix matching the word under cursor
noremap <Leader>g* :call ttags#List(0, "*", tlib#rx#Escape(expand("<cword>")) .".*")<cr>

" Show tags matching the word under cursor (search also in |g:tlib_tags_extra|)
noremap <Leader>g? :call ttags#List(1, "*", tlib#rx#Escape(expand("<cword>")))<cr>

" Show tags of a certain category
for c in split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '\zs')
    exec 'noremap <Leader>g'. c .' :TTags '. c .'<cr>'
endfor

Plug 'rstacruz/sparkup'

" Enanche parenthesis hightlighting
Plug 'kien/rainbow_parentheses.vim'
augroup rainbow
    autocmd!
    " autocmd VimEnter * RainbowParenthesesActivate
    " autocmd BufWritePost * RainbowParenthesesLoadRound
    " autocmd BufWritePost * RainbowParenthesesLoadSquare
    " autocmd BufWritePost * RainbowParenthesesLoadBraces
    " autocmd BufWritePost * RainbowParenthesesLoadChevrons
augroup END

" Multiline searching
Plug 'wincent/ferret'
let g:FerretMap=0

" Nedded by vim-notes
Plug 'xolox/vim-misc'

" Take notes in vim
Plug 'xolox/vim-notes'
let g:notes_directories = ['~/.notes']

" Check particular type of word
Plug 'reedes/vim-wordy'
noremap <silent> <F8> :<C-u>NextWordy<cr>
xnoremap <silent> <F8> :<C-u>NextWordy<cr>
inoremap <silent> <F8> <C-o>:NextWordy<cr>

Plug 'reedes/vim-litecorrect'
nnoremap <C-s> [s1z=<c-o>
inoremap <C-s> <c-g>u<Esc>[s1z=`]A<c-g>u

" Use neovim to write in browser
Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}

" Pick html color
Plug 'DougBeney/pickachu'

Plug 'jvirtanen/vim-octave'

" Open filename:line
Plug 'kopischke/vim-fetch'

call plug#end()

colorscheme gruvbox
set background=dark
set termguicolors

" Path to python interpreter for neovim
let g:python3_host_prog  = '/usr/bin/python3'
" Skip the check of neovim module
let g:python3_host_skip_check = 1

augroup OnSave
    autocmd!
    " Autoformat code using neoformat and trim whitespaces
    autocmd BufWritePre * Neoformat
augroup END

function! EnterWriterMode()
    call pencil#init({'wrap': 'hard', 'autoformat': 0})
    Limelight
    " execute `Goyo` if it's not already active
    if !exists('#goyo')
        Goyo
    endif
    call litecorrect#init()
    setlocal spell
    setlocal wrap
    set noshowmode
    set noshowcmd
    set nocursorcolumn
    set scrolloff=999
    set list lcs=tab:+.
    " Underline spelling errors in red
    hi clear SpellBad
    hi SpellBad cterm=underline ctermfg=red
    hi clear SpellCap
    hi SpellCap cterm=underline ctermfg=blue
    " Underline localization errors in green.
    hi clear SpellLocal
    hi SpellCap cterm=underline ctermfg=green
endfunction

function! s:LeaveWriterMode()
    set showmode
    set showcmd
    set scrolloff=5
    Limelight!
    " set background=dark
endfunction

autocmd! User GoyoLeave nested call <SID>LeaveWriterMode()
