let g:mapleader="\<SPACE>"
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set showmode           " Show current mode.
set ruler               " Show the line and column numbers of the cursor.
set relativenumber      " Show the line numbers on the left side.
set number              " Show the current line number
set formatoptions+=o    " Continue comment marker in new lines.
set textwidth=0         " Hard-wrap long lines as you type them.
set expandtab           " Insert spaces when TAB is pressed.
set nosmarttab
set tabstop=4           " Render TABs using this many spaces.
set shiftwidth=4        " Indentation amount for < and > commands.
set noshowmode          " Hide the default mode text (e.g. -- INSERT -- below the statusline)

set modeline            " Enable modeline.
set linespace=0         " Set line-spacing to minimum.
set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)

" More natural splits
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

if !&scrolloff
    set scrolloff=7       " Show next 7 lines while scrolling.
endif
if !&sidescrolloff
    set sidescrolloff=10   " Show next 10 columns while side-scrolling.
endif
set display+=lastline
set nostartofline       " Do not jump to first character with page commands.

set updatetime=500 " Let plugins show effects after 500ms, not 4s
set mouse-=a " Disable mouse click to go to position

" Don't let autocomplete affect usual typing habits
set completeopt=menuone,preview,noinsert

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hidden

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

set ignorecase          " Make searching case-insensitive
set smartcase           " ... unless the query has capital letters.
set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set magic               " Use 'magic' patterns (extended regular expressions).

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

set grepprg=rg\ --vimgrep

" Enable sql query syntax hightlighting in php files
let php_sql_query = 1
" Enable html syntax hightlighting in php files
let php_htmlInStrings = 1

" Remap comma to double dots
map , :

nnoremap <Leader>w :SudoWrite<CR>

" Reload config on savings
autocmd! bufwritepost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim

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

""" Terminal Mapping
tnoremap <C-A><ESC> <C-\><C-n>

" Remapping for switching windows when in terminal
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

inoremap <C-h> <Esc><C-w>h
inoremap <C-j> <Esc><C-w>j
inoremap <C-k> <Esc><C-w>k
inoremap <C-l> <Esc><C-w>l

" Get terminal get input focus when switching to terminal window
au BufEnter * if &buftype == 'terminal' | :startinsert | endif

" Move in wrapped lines instead of jumping over them
nnoremap j gj
nnoremap k gk

" Close all open windows
noremap <C-q><C-q> :confirm qall<CR>

" Current line highlithing
hi CursorLineNR cterm=bold
augroup CLNRSet
    autocmd! ColorScheme * hi CursorLineNR cterm=bold
augroup END

augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

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

" Strip whitespaces from files
Plug 'ntpeters/vim-better-whitespace'
" Whitespaces color
highlight ExtraWhitespace ctermbg=darkred guibg=darkred

" Theme
Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italic=1

" Another theme
"Plug 'freeo/vim-kalisi'

" Add icons
Plug 'ryanoasis/vim-devicons'

" Hightlight html color tags
Plug 'lilydjwg/colorizer'

" File explorer
Plug 'scrooloose/nerdtree'
" Close NerdTree if it is the onyl windows open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Open NerdTree with ctrl+n
map <Leader>n :NERDTreeToggle<CR>
" and toggle with double n
map <Leader>nn :NERDTreeToggle<CR>
" Show hidden file
let NERDTreeShowHidden=1
" Ignore file
let NERDTreeIgnore=['\.DS_Store', '\~$', '\.swp']
" Arrows
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
" Symbols
let g:NERDTreeIndicatorMapCustom = {
            \ "Modified"  : "✹",
            \ "Staged"    : "✚",
            \ "Untracked" : "✭",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "✖",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✔︎",
            \ "Unknown"   : "?"
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
noremap <Leader>h :History<CR>
noremap <Leader>d :exe ':Look ' . expand('<cword>')<CR>
" Find command using fzf and ripgrep
command! -bang -nargs=* Look
  \ call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!docs/*" --glob "!build/*" --glob "!opt/*" --color "always" --threads 0 --no-messages '
  \   .shellescape(<q-args>), 1,
  \   fzf#vim#with_preview('up:60%'),
  \   <bang>0)
map <Leader>a :Look<CR>

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
Plug 'nelstrom/vim-visual-star-search'

" Search the text between projects files
Plug 'dyng/ctrlsf.vim'
" Use ripgrep for searching
let g:ctrlsf_ackprg = 'rg'

" Version control
Plug 'tpope/vim-fugitive'

" Integration with github
Plug 'roxma/ncm-github'

" Autocompletition
Plug 'roxma/nvim-completion-manager'
set shortmess+=c
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Handle python dependencies
Plug 'roxma/python-support.nvim'
" for python completions
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'jedi')
" language specific completions on markdown file
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'mistune')

" utils, optional
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'psutil')
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'setproctitle')

" Enhance repeat key
Plug 'tpope/vim-repeat'

Plug 'tpope/vim-surround'

" Comment lines
Plug 'scrooloose/nerdcommenter'

" Better scrolling
Plug 'terryma/vim-smooth-scroll'
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 5, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 5, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 5, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 5, 4)<CR>

Plug 'reedes/vim-wheel'
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

" Intend guides
Plug 'Yggdroot/indentLine'
" Set color for indenting character
let g:indentLine_color_term = 241
" Set new indenting char
let g:indentLine_char = '┆'
" Disable concealing
let g:indentLine_concealcursor = ''
" Set faster mode
let g:indentLine_faster=1

" Use editor config settings per project
Plug 'editorconfig/editorconfig-vim'

" Format using external tools
Plug 'sbdchd/neoformat'
" Disable alignment
let g:neoformat_basic_format_align = 0
" Disable tab to space conversion
let g:neoformat_basic_format_retab = 0
" Disable sql formatting
let g:neoformat_enabled_sql = []

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

" Show code tags
Plug 'majutsushi/tagbar'
nmap <F8> :TagbarOpen fj<CR>
" Focus tag bar when showing
let g:tagbar_autofocus = 0

" HTML shortcuts
Plug 'mattn/emmet-vim'

" Language pack
Plug 'sheerun/vim-polyglot'

" Java autocompletion
Plug 'artur-shaik/vim-javacomplete2'
augroup omnifuncs
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
augroup END

" Better syntax hightlighting for c++ code
Plug 'arakashic/chromatica.nvim'

" Php completion
Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer install' }

" Asynchronous build and make
Plug 'tpope/vim-dispatch'

" Golang plugin
Plug 'fatih/vim-go'

" Refactoring
Plug 'brooth/far.vim'

" Debugging for php
"Plug 'joonty/vdebug'
" Debugging using clang
"Plug 'critiqjo/lldb.nvim'

" Linting
Plug 'w0rp/ale'
" Disable some linters
let g:ale_linters = {
            \   'cpp': [],
            \   'c': []
            \}
" Disable automatic lining on writing
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 0
" Close vim if the last window open is quickfix
aug QuickFixClose
    au!
    au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END

" Writer plugins
Plug 'reedes/vim-pencil'
augroup Pencil
    autocmd!
    autocmd FileType markdown,mkd call pencil#init()
                \ | call EnterWriterMode()
augroup END

" Markdown preview in firefox
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

" Distraction free writing
Plug 'junegunn/goyo.vim'

" Enhance current line, hide useless information in other lines
Plug 'junegunn/limelight.vim'

" Tab keymaps
Plug 'DanySpin97/TabSwitch.vim'
" Change key
let g:tabswitch_prefix = "<C-A>"
let g:tabswitch_terminal_open = 1
let g:tabswitch_insert_mapping = 1
let g:tabswitch_terminal_mapping = 1

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
    " Autoformat code using neoformat
    autocmd BufWritePre * undojoin | Neoformat
    " Stripe whitespaces
    autocmd BufWritePre * :StripWhitespace
augroup END

function! EnterWriterMode()
    Limelight
    " execute `Goyo` if it's not already active
    if !exists('#goyo')
        Goyo
    endif
endfunction

autocmd! User GoyoLeave Limelight!
