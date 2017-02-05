set encoding=utf8

"Map the leader key to SPACE
let mapleader="\<SPACE>"
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set showmode            " Show current mode.
set ruler               " Show the line and column numbers of the cursor.
set number              " Show the line numbers on the left side.
set formatoptions+=o    " Continue comment marker in new lines.
set textwidth=0         " Hard-wrap long lines as you type them.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=4           " Render TABs using this many spaces.
set shiftwidth=4        " Indentation amount for < and > commands.
set noshowmode          " Hide the default mode text (e.g. -- INSERT -- below the statusline)

set modeline            " Enable modeline.
set esckeys             " Cursor keys in insert mode.
set linespace=0         " Set line-spacing to minimum.
set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)

" More natural splits
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

if !&scrolloff
    set scrolloff=3       " Show next 3 lines while scrolling.
endif
if !&sidescrolloff
    set sidescrolloff=5   " Show next 5 columns while side-scrolling.
endif
set display+=lastline
set nostartofline       " Do not jump to first character with page commands.

set laststatus=2 " Always show status bar
set updatetime=500 " Let plugins show effects after 500ms, not 4s
set mouse-=a " Disable mouse click to go to position
" Don't let autocomplete affect usual typing habits
set completeopt=menuone,preview,noinsert

set hidden
set history=100

" Set to auto read when a file is changed from the outside
set autoread

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500"

" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
if &listchars ==# 'eol:$'
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list                " Show problematic characters.

" Also highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$\|\t/

set hlsearch            " Highlight search results.
set ignorecase          " Make searching case insensitive
set smartcase           " ... unless the query has capital letters.
set incsearch           " Incremental search.
set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set magic               " Use 'magic' patterns (extended regular expressions).

" Disable swap and backup
set nobackup
set noswapfile
set nowb

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Add cpp syntax for .tpp files
autocmd BufEnter *.tpp :setlocal filetype=cpp

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
        set nornu
        set number
    else
        set rnu
    endif
endfunc

" Toggle between normal and relative numbering.
nnoremap <leader>r :call NumberToggle()<cr>

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

""" Terminal Mapping
tnoremap <Esc> <C-\><C-n>

" Remapping for switching windows when in terminal
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Get terminal get input focus when switching to terminal window
au BufEnter * if &buftype == 'terminal' | :startinsert | endif

" Easy switch between vims tab
nnoremap tc :tabnew<CR>
nnoremap td :tabclose<CR>
nnoremap tp :tabprev<CR>
nnoremap tn :tabnext<CR>

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

" Move in wrapped lines instead of jumping over them
nnoremap j gj
nnoremap k gk

" Edit files with permission even after opened them
" (http://nvie.com/posts/how-i-boosted-my-vim/)
cmap w!! w !sudo tee % >/dev/null

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

" vp doesn't replace paste buffer
function! RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunction
function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" Autosave when focus is lost from window
" (disable it when using mirrors.vim)
au FocusLost * wa

" Send lines in range to hastebin.com and copy url to clipboard
command! -range -bar Haste <line1>,<line2>w !haste | xsel -b

call plug#begin()

" UI plugins
Plug 'vim-airline/vim-airline'
Plug 'freeo/vim-kalisi'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'mbbill/undotree'
Plug 'tpope/vim-characterize'
" Disable because it was causing lag
"Plug 'airblade/vim-gitgutter'

" File management
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'zenbro/mirror.vim'
Plug 'mhinz/vim-startify'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'dietsche/vim-lastplace'
Plug 'tpope/vim-eunuch'
Plug 'vim-scripts/quit-another-window'

" Vim movement and bindings
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'unblevable/quick-scope'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-smooth-scroll'
Plug 'reedes/vim-wheel'
Plug 'powerman/vim-plugin-viewdoc'

" Indenting and autocompletition
Plug 'thirtythreeforty/lessspace.vim', { 'do': ':UpdateRemotePlugins' }
Plug 'Yggdroot/indentLine'
Plug 'editorconfig/editorconfig-vim'
Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'jiangmiao/auto-pairs'
Plug 'sbdchd/neoformat'
Plug 'vim-scripts/YankRing.vim'

" Ctags and language plugins
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'shawncplus/phpcomplete.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'elzr/vim-json'
Plug 'mattn/emmet-vim'

" Terminal
Plug 'wvffle/vimterm'

call plug#end()

filetype plugin indent on

" Set theme
syntax enable
set background=dark

""" Gruvbox config
let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_italic=1
colorscheme gruvbox
set termguicolors

"""" indentLine config
" Set color for indenting character
let g:indentLine_color_term = 241

" Set new indenting char
let g:indentLine_char = '┆'

" Disable concealing
let g:indentLine_concealcursor = ''

""" NerdTree config

" Close NerdTree if it is the onyl windows open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Open NerdTree with ctrl+n
map <C-n> :NERDTreeToggle<CR>

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

""" air-line config
let g:airline_powerline_fonts = 1

" Set kalisi theme
let g:airline_theme='gruvbox'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" testing rounded separators (extra-powerline-symbols):
let g:airline_right_sep = "\uE0B6"

" set the CN (column number) symbol:
let g:airline_section_z = airline#section#create(["\uE0A1" . '%{line(".")}' . "\uE0A3" . '%{col(".")}'])

let g:airline#extensions#tabline#enabled = 1

let g:airline#extensions#tabline#left_sep =  ""
let g:airline#extensions#tabline#left_alt_sep =  ""

let b:usemarks         = 1
let b:cb_jump_on_close = 1

""" Easymotion configuration
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

map <Leader>w <Plug>(easymotion-w)
map <Leader>e <Plug>(easymotion-e)
map <Leader>b <Plug>(easymotion-b)

""" Git gutter config
" Always show column
"let g:gitgutter_sign_column_always=1
" Stop git gutter when there are 500+ modifications
"let g:gitgutter_max_signs = 50

" Speed up gitgutter
"let g:gitgutter_realtime = 0
"let g:gitgutter_eager = 0

""" Startify config
let g:startify_enable_unsafe = 0

""" FZF config
" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }

" Customize fzf colors to match your color scheme
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

" Call fzf
map <C-z> :FZF<CR>
map <Leader>t :BTags<CR>

""" Tagbar
nmap <F8> :TagbarToggle<CR>

" Focus tag bar when showing
let g:tagbar_autofocus = 1

""" vim-smooth-scroll config
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

""" Quick scope config
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

""" Cpp enhanced sintax highligthing
" Highlighting of class scope
let g:cpp_class_scope_highlight = 1

" Hightlight template functions
let g:cpp_experimental_simple_template_highlight = 1

" Highlighting of library concepts
let g:cpp_concepts_highlight = 1

""" Neoformat config
" Add a mapping
nmap <Leader>R :Neoformat<CR>

" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1

""" Mirrors.vim config
" Add a mapping for pushing to the server
nmap <Leader>p :MirrorPush<CR>

""" vim-wheel config
let g:wheel#map#up   = '<m-y>'
let g:wheel#map#down = '<m-e>'

""" Vimterm config
nnoremap <F7> :call vimterm#toggle() <CR>
tnoremap <F7> <C-\><C-n>:call vimterm#toggle() <CR>

""" Undotree config
" Keymap for undotree gui
nnoremap <F5> :UndotreeToggle<cr>

" Focus undotree when showing it
let g:undotree_SetFocusWhenToggle = 1

" Add persistent undo history between files
if has("persistent_undo")
    set undodir=~/.undodir/
    set undofile
endif

""" YangRink config
nnoremap <silent> <F6> :YRShow<CR>

" Increase window height
let g:yankring_window_height = 12

" Change keys for replacing
let g:yankring_replace_n_pkey = '<C-p>'
let g:yankring_replace_n_nkey = '<C-m>'

""" Quick windows close
nnoremap <C-q>h :Qh <CR>
nnoremap <C-q>j :Qj <CR>
nnoremap <C-q>k :Qk <CR>
nnoremap <C-q>l :Ql <CR>
