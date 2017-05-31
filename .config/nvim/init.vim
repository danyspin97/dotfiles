let g:mapleader="\<SPACE>"
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set showmode            " Show current mode.
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
    set scrolloff=7       " Show next 3 lines while scrolling.
endif
if !&sidescrolloff
    set sidescrolloff=10   " Show next 5 columns while side-scrolling.
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
set timeoutlen=500"

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

set smartindent "Smart indent
set wrap "Wrap lines

" Remap comma to double dots
map , :

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

" Resize windows
map + 10<C-W>+
map - 10<C-W>-
map < 10<C-W><
map > 10<C-W>>

""" Terminal Mapping
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

" Send lines in range to hastebin.com and copy url to clipboard
command! -range -bar Haste <line1>,<line2>w !haste | xsel -b

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

function! BuildYCM(info)
    if a:info.status == 'installed' || a:info.force
        !./install.py --clang-completer --system-libclang --system-boost
    endif
endfunction

function! BuildComposer(info)
    if a:info.status != 'unchanged' || a:info.force
        if has('nvim')
            !cargo build --release
        else
            !cargo build --release --no-default-features --features json-rpc
        endif
    endif
endfunction

call plug#begin()

""" UI plugins
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'mbbill/undotree'
Plug 'tpope/vim-characterize'
Plug 'ntpeters/vim-better-whitespace'
Plug 'lilydjwg/colorizer'

" File management
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'dietsche/vim-lastplace'
Plug 'tpope/vim-eunuch'
Plug 'vim-scripts/quit-another-window'
Plug 'pbrisbin/vim-mkdir'

" Save session
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

" Vim motion and bindings
Plug 'ervandew/supertab'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-smooth-scroll'
Plug 'reedes/vim-wheel'
Plug 'powerman/vim-plugin-viewdoc'
Plug 'bkad/CamelCaseMotion'
Plug 'matze/vim-move'
Plug 'sunaku/vim-shortcut'
Plug 'PeterRincker/vim-argumentative'
Plug 'wesQ3/vim-windowswap'

" Tmux integration
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'benmills/vimux'

" Cliboard management
Plug 'vim-scripts/YankRing.vim'

" Indenting
Plug 'Yggdroot/indentLine'
Plug 'editorconfig/editorconfig-vim'
Plug 'sbdchd/neoformat'

" Autocompletion
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-endwise'

" Build
Plug 'tpope/vim-dispatch'

" Doxygen integration
Plug 'vim-scripts/DoxygenToolkit.vim'

" Ctags and language plugins
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer install' }
Plug 'mattn/emmet-vim'
Plug 'sheerun/vim-polyglot'
Plug 'lyuts/vim-rtags'

" Linting
Plug 'w0rp/ale'

" Writer plugins
Plug 'reedes/vim-pencil'
Plug 'rhysd/vim-grammarous'
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" Time
Plug 'wakatime/vim-wakatime'

call plug#end()

" Remove 'Shortcut: not an editor command' error
runtime plugin/shortcut.vim

augroup OnSave
    autocmd!
    " Autoformat code using neoformat
    autocmd BufWritePre * :Neoformat
    " Stripe whitespaces
    autocmd BufWritePre * :StripWhitespace
augroup END

""" vim-plug shortcts
Shortcut install plugins
            \ map <Leader>pi :PlugInstall<CR>
Shortcut update plugins
            \ map <Leader>pu :PlugUpdate<CR>
Shortcut update vim-plug
            \ map <Leader>pp :PlugUpgrade<CR>

" Set theme
set background=dark

""" Gruvbox config
let g:gruvbox_contrast_dark = 'hard'
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

let g:indentLine_faster=1

""" airline config
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

" Set the CN (column number) symbol:
let g:airline_section_z = airline#section#create(["\uE0A1" . '%{line(".")}' . "\uE0A3" . '%{col(".")}'])

let g:airline#extensions#tabline#enabled = 1

let g:airline#extensions#tabline#left_sep =  ''
let g:airline#extensions#tabline#left_alt_sep =  ''

let b:usemarks         = 1
let b:cb_jump_on_close = 1

""" Easymotion configuration
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

" Turn on case-insensitive feature
let g:EasyMotio2_smartcase = 1

" JK motions: Line motions
Shortcut easymotion lineforward
            \ map <Leader>l <Plug>(easymotion-lineforward)
Shortcut easymotion down
            \ map <Leader>j <Plug>(easymotion-j)
Shortcut easymotion upper
            \ map <Leader>k <Plug>(easymotion-k)
Shortcut easymotion linebackward
            \ map <Leader>h <Plug>(easymotion-linebackward)

Shortcut easymotion e
            \ map <Leader>e <Plug>(easymotion-e)
Shortcut easymotion b
            \ map <Leader>b <Plug>(easymotion-b)

map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)

" Bidirectional & within line 't' motion
omap t <Plug>(easymotion-bd-tl)
" Use uppercase target labels and type as a lower case
let g:EasyMotion_use_upper = 1
" type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1
" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1

" <Leader>f{char} to move to {char}
Shortcut easymotion f
            \ map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" Move to line
Shortcut easymotion move on line
            \ map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
Shortcut easymotion w
            \ map  <Leader>w <Plug>(easymotion-w)

""" FZF config
" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }

" This is the default extra key bindings
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }

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
Shortcut search files
            \ map <Leader>z :FZF<CR>
Shortcut search tags
            \ map <Leader>t :BTags<CR>

" Find command using fzf and ripgrep
" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
command! -bang -nargs=* Look call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!docs/*" --glob "!build/*" --glob "!opt/*" --glob "!vendor/*" --glob "!tags" --color "always" --threads 0 '.shellescape(<q-args>), 1, <bang>0)

Shortcut search word in files
            \ map <Leader>a :Look<CR>

""" Tagbar
Shortcut open tagbar window
            \ nmap <F8> :TagbarOpen fj<CR>

" Focus tag bar when showing
let g:tagbar_autofocus = 0

""" vim-smooth-scroll config
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 5, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 5, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 5, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 5, 4)<CR>

""" Cpp enhanced sintax highligthing
" Highlighting of class scope
let g:cpp_class_scope_highlight = 1

" Hightlight template functions
let g:cpp_experimental_simple_template_highlight = 1

" Highlighting of library concepts
let g:cpp_concepts_highlight = 1

""" Neoformat config
" Add a mapping
Shortcut format current file
            \ nmap <Leader>R :Neoformat<CR>

" Enable alignment
let g:neoformat_basic_format_align = 0

" Enable tab to space conversion
let g:neoformat_basic_format_retab = 0

""" vim-wheel config
let g:wheel#map#up   = '<m-y>'
let g:wheel#map#down = '<m-e>'

""" Undotree config
" Keymap for undotree gui
Shortcut toggle undotree window
            \ nnoremap <F5> :UndotreeToggle<cr>

" Focus undotree when showing it
let g:undotree_SetFocusWhenToggle = 1

" Add persistent undo history between files
if has('persistent_undo')
    set undofile
endif

""" YangRink config
nnoremap <silent> <F6> :YRShow<CR>

" Increase window height
let g:yankring_window_height = 12

" Change keys for replacing
let g:yankring_replace_n_pkey = '<C-p>'
let g:yankring_replace_n_nkey = '<C-n>'

""" Quick windows close
Shortcut close left window
            \ nnoremap <Leader>qh :Qh <CR>
Shortcut close down window
            \ nnoremap <Leader>qj :Qj <CR>
Shortcut close upper window
            \ nnoremap <Leader>qk :Qk <CR>
Shortcut close right window
            \ nnoremap <Leader>ql :Ql <CR>

""" Guten tag config
let g:gutentag_enabled = 1
let g:gutentags_cache_dir = '~/.cache/tags'

""" vim-better-whitespace config
" Whitespaces color
highlight ExtraWhitespace ctermbg=darkred guibg=darkred

""" CamelCaseMotion config
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
map <silent> ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge

function! EnterWriterMode()
    Limelight
    " execute `Goyo` if it's not already active
    if !exists('#goyo')
        Goyo
    endif
endfunction

autocmd! User GoyoLeave Limelight!

""" Vim pencil config
augroup Pencil
    autocmd!
    autocmd FileType markdown,mkd call pencil#init()
                \ | call EnterWriterMode()
augroup END

""" Grammarous config
" Chack grammar only for comments
let g:grammarous#default_comments_only_filetypes = {
            \ '*' : 1, 'help' : 0, 'markdown' : 0,
            \ }
" Use system laguage tool
let g:grammarous#languagetool_cmd = 'languagetool'

Shortcut Check grammar errors
            \ nmap <Leader>gg :GrammarousCheck<CR>
Shortcut Move to the next grammatic error
            \ nmap <Leader>go <Plug>(grammarous-move-to-next-error)
Shortcut Fix current grammatic error
            \ nmap <Leader>gf <Plug>(grammarous-fixit)
Shortcut Remove current grammatic error
            \ nmap <Leader>gr <Plug>(grammarous-remove-error)

""" vim-shortcut config
Shortcut show shortcut menu and run chosen shortcut
            \ noremap <silent> <Leader><Leader> :Shortcuts<Return>

noremap <silent> <Leader> :Shortcuts<Return>

""" Ale config
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

aug QuickFixClose
    au!
    au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END

""" YouCompleteMe config
let g:ycm_path_to_python_interpreter = '/usr/bin/python'
let g:ycm_global_ycm_extra_conf='~/.config/nvim/.ycm_extra_conf.py'
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_goto_buffer_command = 'vertical-split'
let g:ycm_python_binary_path = 'python3'
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_filetype_blacklist = {
            \ 'tagbar' : 1,
            \ 'qf' : 1,
            \ 'notes' : 1,
            \ 'markdown' : 1,
            \ 'unite' : 1,
            \ 'text' : 1,
            \ 'vimwiki' : 1,
            \ 'pandoc' : 1,
            \ 'infolog' : 1,
            \ 'mail' : 1
            \}

Shortcut go to declaration
            \ nnoremap <leader>jd :YcmCompleter GoToDeclaration<CR>
Shortcut go to include
            \ nnoremap <leader>jh :YcmCompleter GoToInclude<CR>
Shortcut go to definition
            \ nnoremap <leader>jk :YcmCompleter GoToDefinition<CR>
Shortcut get type
            \ nnoremap <leader>jt :YcmCompleter GetType<CR>
Shortcut fix error
            \ nnoremap <leader>jf :YcmCompleter FixIt<CR>

" mak YCM compatmble with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

""" netrw config
let g:netrw_liststyle = 3

" Disable banner
let g:netrw_banner = 0

" Open files in previous window
let g:netrw_browse_split = 4
let g:netrw_altv = 1

" Set window Siie
let g:netrw_winsize = 25

" Toggle Vexplore
function! ToggleVExplorer()
    if exists('t:expl_buf_num')
        let l:expl_win_num = bufwinnr(t:expl_buf_num)
        if l:expl_win_num != -1
            let l:cur_win_nr = winnr()
            exec l:expl_win_num . 'wincmd w'
            close
            exec l:cur_win_nr . 'wincmd w'
            unlet t:expl_buf_num
        else
            unlet t:expl_buf_num
        endif
    else
        exec '1wincmd w'
        Vexplore
        let t:expl_buf_num = bufnr('%')
    endif
endfunction

Shortcut open file browser
            \ noremap <Leader>n :call ToggleVExplorer()<CR>

""" vim-tmux-navigator config
" Don't import mappings
let g:tmux_navigator_no_mappings = 1

" Set movement mappings
nnoremap <silent> <C-H> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-J> :TmuxNavigateDown<CR>
nnoremap <silent> <C-K> :TmuxNavigateUp<CR>
nnoremap <silent> <C-L> :TmuxNavigateRight<CR>
nnoremap <silent> <C-\> :TmuxNavigatePrevious<CR>

""" vim-session config
" Don't save help windows
set sessionoptions-=help

" Don't save hidden and unloaded buffers in sessions.
set sessionoptions-=buffers

" Don't persist options and mappings because it can corrupt sessions.
set sessionoptions-=options

" Save without asking prompt
let g:session_autosave = 'yes'
let g:session_autosave_periodic = 5
let g:session_autoload = 'no'
let g:session_lock_enabled = 0

""" Vimux
let g:VimuxUseNearest = 1

Shortcut Build c++ projects using makefile
            \ map <Leader>sm :call VimuxRunCommand("make")<CR>
Shortcut Run last vimux command
            \ map <Leader>ss :VimuxRunLastCommand<CR>
Shortcut Prompt command to run in vimux pane
            \ map <Leader>sp :VimuxPromptCommand<CR>

""" vim argumentative
nmap [, <Plug>Argumentative_Prev
nmap ], <Plug>Argumentative_Next
xmap [, <Plug>Argumentative_XPrev
xmap ], <Plug>Argumentative_XNext
nmap <, <Plug>Argumentative_MoveLeft
nmap >, <Plug>Argumentative_MoveRight
xmap i, <Plug>Argumentative_InnerTextObject
xmap a, <Plug>Argumentative_OuterTextObject
omap i, <Plug>Argumentative_OpPendingInnerTextObject
omap a, <Plug>Argumentative_OpPendingOuterTextObject

""" rtags
let g:rtagsAutoLaunchRdm = 1
