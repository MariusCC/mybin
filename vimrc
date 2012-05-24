" Maintainer:	MariusCC <mariuscristianc@gmail.com>
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible                            " We're running Vim, not Vi!
"set verbose=9                               " useful for debug
set viminfo='50,<1000,s100,:100,n~/_viminfo " Set viminfo option & location
set formatoptions=t encoding=utf-8 termencoding=latin1 fileformat=unix
set wrap whichwrap=<,>,h,l,[,]              " backspace and cursor keys wrap to previous/next line
set visualbell noerrorbells
set backspace=indent,eol,start              " allow backspacing over everything in insert mode
set foldlevelstart=20
set history=100		                        " keep 50 lines of command line history
set ruler		                            " show the cursor position all the time
set showcmd		                            " display incomplete commands
set incsearch		                        " do incremental searching
set autoindent		                        " always set autoindenting on
set backup		                            " keep a backup file
set ch=2                                    " Make command line two lines high
"  set patchmode		                    " Keep versions
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
colorscheme northsky
set nu!		                                " Force line numbering
set ic!                                     " Force ignores the case during the search
set expandtab                               " enter spaces when tab is pressed:
set tabstop=4                               " user 4 spaces to represent a tab
set softtabstop=4                           " Set tab stop
" number of space to use for auto indent
" you can use >> or << keys to indent current line or selection
" in normal mode.
set shiftwidth=4
set wildmenu                                " show some autocomplete options in status bar
"auto-save a modified buffer when switching to another buffer
set autowrite
"edit a file without losing modifications to the current file and history
set hidden

"This is useful if you use a 'makeprg' that writes to 'makeef' by itself.
"If you want no piping, but do want to include the 'makeef', set 'shellpipe' to a single space.
set sp=\

" share clipboard with windows clipboard
set clipboard+=unnamed

if has("unix")
    set shcf=-ic
    " (unix forward slash) for mixed environment, not good on Windows
    set shellslash
    "set font
    if has('x11')
        "set guifont=ProggyCleanTTSZ\ 12
        set guifont=Ubuntu\ Mono\ Regular\ 12
        set printfont=Bitstream\ Vera\ Sans\ Mono\ Bold\ 12
    endif
elseif has("win32")
    set guifont=Dina:h10:cDEFAULT
    au GUIEnter * simalt ~x "maximize window in Windows
endif

"search recursively upwards for the tags file
"ctags -R -f ./python.ctags /usr/lib/python2.6/
set tags=./tags,./python.ctags
"
"Mappings
"
let mapleader = ","
"map F5 on make
map <buffer> <F5> :Make<cr><C-w><Up>

"map Shift-M on clean win32 line ends
map M :%s///g
"map Ctrl-M on clean tabs/spaces from end line
map <C-m> :1,$s/[ <tab>]*$//

"JSBeautyfier
map <buffer> <F12> :call g:Jsbeautify()<cr>

"use CTRL + d on NerdTree
map <C-d> :execute 'NERDTreeToggle ' . getcwd()<CR>

" map <F6> to reindent
map <buffer> <F6> gg=G

"This is useful if you use a 'makeprg' that writes to 'makeef' by itself.
"If you want no piping, but do want to include the 'makeef', set 'shellpipe' to a single space.
set sp=\

if has("gui_running")
    " GUI is running or is about to start.
    set guioptions+=aegmrL
    let &guioptions = substitute(&guioptions, "t", "", "g")
    " Make window height VERY large so they always maximise on window switch
    set winheight=9999
    set winwidth=9999
else
    " This is console Vim.
    if exists("+lines")
        set lines=80
    endif
    if exists("+columns")
        set columns=100
    endif
endif

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" http://vim.wikia.com/wiki/Script:556
if has('perl')
    let myINC = system("perl -e '$,=\" \";print @INC'")
    perl push @INC, split(/ /,VIM::Eval("myINC"))
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " change directory to whatever file I'm currently editing
    autocmd BufEnter * lcd %:p:h
    " This beauty remembers where you were the last time you edited the file, and returns to the same position.
    autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
    " Note, perl automatically sets foldmethod in the syntax file
    autocmd Syntax c,cpp,vim,xml,html,xhtml setlocal foldmethod=syntax
    autocmd Syntax c,cpp,vim,xml,html,xhtml,perl normal zR
    "Make your that python is in your path, now when you open any python file just type ":make" to get the syntax errors, use ":cnext", to move to next error, check the help on make (":help make") for more info on how to navigate errors.
    "As you are checking now, <F5> is mapped to execute the current script.
    autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
    autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
    autocmd BufRead *.py nmap <F5> :!python %<CR>
    "That will make to use a 4 spaces for you tabstop (only visually), it avoids wrapping your code and will add a bottom scrollbar.
    autocmd BufRead *.py set nowrap
    autocmd BufRead *.py set go+=b

    autocmd BufNewFile,BufRead *.epl,*.phtml setf embperl
    autocmd FileType perl ":silent 1,$!perltidy -i=4 -syn -bbc -bar -ce -bt=2 -pt=2 -sbt=2 -q -st %"
    autocmd FileType perl let perl_fold=1

    " automatically save and restore folds
    "    autocmd BufWinLeave * mkview
    "    autocmd BufWinEnter * silent loadview

    "enable syntax code completion
    if has("autocmd") && exists("+omnifunc")
        autocmd Filetype *
                    \	if &omnifunc == "" |
                    \		setlocal omnifunc=syntaxcomplete#Complete |
                    \	endif
        "To enable code completion support for Python in Vim you should be able to add the following line to your .vimrc:
        autocmd FileType python
                    \   set omnifunc=pythoncomplete#Complete

        " Make omnicompletation useful
        " http://www.vim.org/tips/tip.php?tip_id=1386
        set completeopt=longest,menuone,preview
        "inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
        inoremap   pumvisible() ? "\" : "\u\"
        inoremap   pumvisible() ? "\c-n>" : "\c-n>\c-r>=pumvisible() \? \"\\down>\" : \"\"\cr>"
        inoremap   pumvisible() ? "\c-n>" : "\c-x>\c-o>\c-n>\ \c-p>\c-r>=pumvisible() ? \"\\down>\" : \"\"\cr>"

        "Then all you have to do to use your code completion is hit the unnatural, wrist breaking, keystrokes CTRL+X, CTRL+O. 
        "I've re-bound the code completion to CTRL+Space since we are making vim an IDE! Add this command to your .vimrc to get the better keybinding:
        inoremap <Nul> <C-x><C-o>
    endif
endif " has("autocmd")

highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

" load XMl folding
let g:xml_syntax_folding = 1
let makeElementSuf = ';;'

let mapleader = ","
" catalog should be set up
nmap <Leader>l <Leader>cd:%w !xmllint --valid --noout -<CR>
nmap <Leader>r <Leader>cd:%w !rxp -V -N -s -x<CR>
nmap <Leader>d4 :%w !xmllint --dtdvalid
            \ "http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd"
            \ --noout -<CR>

vmap <Leader>px !xmllint --format -<CR>
nmap <Leader>px !!xmllint --format -<CR>
nmap <Leader>pxa :%!xmllint --format -<CR>

"TODO items
imap \t <ESC>i#TODO<SPACE>
map \t i#TODO<SPACE>
imap \w <ESC>:grep --exclude=*~ TODO * <CR> :copen <CR>
map \w :grep --exclude=*~ TODO * <CR> :copen <CR>

set laststatus=2        " A status line will be used to separate windows
" 'laststatus' = 2  -> always a status line
"set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ lin:%l\,%L\ col:%c%V\ pos:%o\ ascii:%b\ %P


"
set statusline=
set statusline+=[#%n] "buffer number
set statusline+=%1*[%5.20t]%*  "file name (tail)
set statusline+=%2*%m%*   "modified flag
set statusline+=%<    "truncate here
set statusline+=%r        "readonly flag
"set statusline+=%h        "help flag
set statusline+=[%{&ff}]  "fileformat
set statusline+=[%{&fileencoding}] "fileencoding
set statusline+=%y      "filetype
set statusline+=%=      "aligning separator
set statusline+=[%02Bh]  "char hex value
set statusline+=[%l,%c%V] "line num and column num
set statusline+=[%P]      "percentage

" minibufexplorer settings:j
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapCTabSwitchWindows = 1


" integrate tidy 4 html/xml
map <F12> :%!tidy -q -i -utf8 --tidy-mark 0 2>/dev/null<CR>
map <F11> :%!tidy -q -utf8 --tidy-mark 0 2>/dev/null<CR>
command Txml set ft=xml | execute "%!tidy -q -i -xml"
command Thtml set ft=html | execute "%!tidy -q -i -html"

"NeoComplCacheEnable
let g:neocomplcache_enable_at_startup = 1

"SingleCompile
nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>
"Then I added the following from Change the pink omnicomplete popup to a readable color:
highlight Pmenu guibg=brown gui=bold

" GetLatestVimScripts will attempt to automatically install updated scripts
"let g:GetLatestVimScripts_allowautoinstall=1

"vim-task
inoremap <silent> <buffer> <C-Space> <ESC> :call Toggle_task_status()<CR>i
noremap <silent> <buffer> <C-Space> :call Toggle_task_status()<CR>
