" Vim Settings
" -----------------------------------------------------------------------------

" Remove compatibility with vi.
set nocompatible
set grepprg=grep\ -nH\ $*

" Dark background color. Leads to brighter fonts.
set background=dark
set number

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Tabs become 4 spaces
set expandtab
set tabstop=4
set shiftwidth=4

" History of 100 commands
set history=100

" Show info about the cursor position
set ruler

" Display commands as you type them
set showcmd	

" Disable incremental search
set noincsearch

" Use shiftwidth when indenting and when inserting a <Tab>
set smarttab

" Window minimum height set to zero, so that when you have multiple windows you
" are not forced to see one row for each file.
set wmh=0

" Max text width: 78 columns.
"set textwidth=78

" When inserting a closing parenthesis, briefly flash the closed one
set showmatch

" Used to open quickfix errors in new windows
set switchbuf=split

" Backup in /tmp
set bdir=/tmp,.

" Enhanced mode for command-line tab completion
set wildmenu

" Fix for pyflakes, that screws the quickfix window.
let g:pyflakes_use_quickfix = 0

" Persistent Undo
set undodir=~/.vim/undodir
set undofile
"set undolevels=1000 "maximum number of changes that can be undone
"set undoreload=10000 "maximum number lines to save for undo on a buffer reload

set mouse=a

" Key mappings
" -----------------------------------------------------------------------------

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Call man for the word under the cursor
map <F1> :exe ":!man ".expand("<cword>")<CR>

" Move to the directory of the file in the current buffer
map <F4> :cd %:p:h<CR>

" Run make
map <F5> :make<CR>

" Use <C-J> (resp. <C-K>) to move one window up (resp. down) and maximize the
" new window
map <C-J> <C-W>j<C-W>_ 
map <C-K> <C-W>k<C-W>_
imap <C-J> <Esc><C-J>a
imap <C-K> <Esc><C-K>a

" Use <C-L> (resp. <C-H>) to move to the next (resp. previous) tab.
map <C-L> :tabn<CR>
map <C-H> :tabp<CR>

" Lets the backspace key start a new undo sequence
inoremap <C-H> <C-G>u<C-H>

" Allows j and k keys to move even inside wrapped lines
map j gj
map k gk

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Functions
" -----------------------------------------------------------------------------
function! s:LookupPythonModule()
    let l:module_name = expand("<cword>")
    let l:cmd = "/usr/bin/python -c 'import " . l:module_name . "; print " .  l:module_name . ".__file__[:-1]'"
    let l:module = system(l:cmd)
    try
        exe "sp " . l:module
    catch /E172:/
        echo "Not a module, or maybe a builtin module. Couldn't reach it, sorry."
    endtry
endfunction

" Autocommands
" -----------------------------------------------------------------------------

if has("autocmd")
    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on
    
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
    
    " Forced file types for some extensions
    au BufNewFile,BufRead *.thtml setfiletype php
    au BufNewFile,BufRead *.tex setfiletype tex
    au BufNewFile,BufRead *.as setfiletype actionscript 

    " Filetype-dependent autocommands
    au FileType java set makeprg=ant\ -emacs
    au FileType python match errorMsg /^\t+/
    au FileType python set makeprg=pep8\ --repeat\ %

    au FileType python command! LookupPythonModule :call <SID>LookupPythonModule()
    au Filetype python map <F7> :LookupPythonModule<CR>
    " If there is a local .lvimrc file, source it (useful for project-related vim
    " settings)
    au BufRead,BufNewFile * let x=expand('%:p:h')."/.lvimrc" | if filereadable(x) | exe "source ".substitute(x, ' ', '\\ ', 'g') | endif
    let x=expand('%:p:h')."/.lvimrc" | if filereadable(x) | exe "source ".substitute(x, ' ', '\\ ', 'g') | endif
endif

" Strip the newline from the end of a string
function! Chomp(str)
  return substitute(a:str, '\n$', '', '')
endfunction

" Find a file and pass it to cmd
function! DmenuOpen(cmd)
  let fname = Chomp(system("git ls-files | dmenu -i -l 20 -p " . a:cmd))
  if empty(fname)
    return
  endif
  execute a:cmd . " " . fname
endfunction

function! ToggleCopyMode()
    if &mouse == 'a'
        set mouse=
        set nonumber
        echo "Copy mode!"
    else
        set mouse=a
        set number
    endif
endfunction

" Allow usage of Dmenu as file searcher
map <c-t> :call DmenuOpen("tabe")<cr>
map <c-f> :call DmenuOpen("e")<cr>

" Enable usage of NERDTree
map <F2> <esc>:NERDTreeToggle<cr>
map <F3> <esc>:TlistToggle<cr>
map <F12> <esc>:call ToggleCopyMode()<cr>

" highlight if 80 char per line is exceeded
autocmd FileType cpp highlight OverLength ctermbg=red ctermfg=white
autocmd FileType python highlight OverLength ctermbg=red ctermfg=white
" guibg=#592929
autocmd FileType cpp match OverLength /\%81v.\+/
autocmd FileType python match OverLength /\%81v.\+/

" make easy access
let $makejarg=""
fun! SetMkfile()
  let filemk = "Makefile"
  let buildpt = "build/"
  let pathmk = "./"
  let depth = 1
  while depth < 4
    if filereadable(pathmk . filemk)
      return pathmk
    endif
    if filereadable(pathmk . buildpt . filemk)
      return pathmk . buildpt
    endif
    let depth += 1
    let pathmk = "../" . pathmk
  endwhile
  return "."
endf
command! -nargs=* Make | let $mkpath=SetMkfile() | make <args> $makejarg -C $mkpath | cwindow 5 

map <F6> <esc>:Make<cr>

"omnifunc code complete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType cpp set omnifunc=ccomplete#Complete
