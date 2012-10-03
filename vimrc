" Maintainer:    MariusCC <mariuscristianc@gmail.com>
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
"set verbose=9                               " useful for debug
set nocompatible      " We're running Vim, not Vi!
set formatoptions=t encoding=utf-8 termencoding=latin1
set wrap whichwrap=<,>,h,l,[,]              " backspace and cursor keys wrap to previous/next line
set visualbell noerrorbells
set backspace=indent,eol,start              " allow backspacing over everything in insert mode
set foldlevelstart=20
"set number
"set nrformats=
set history=100		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set nu!		      " Force line numbering
"set incsearch		" do incremental searching
set softtabstop=4     " Set tab stop
set ic!               " Force ignores the case during the search
" do not break lines when line lenght increases
set textwidth=0
" enter spaces when tab is pressed:
set expandtab
" user 4 spaces to represent a tab
set tabstop=4
" number of space to use for auto indent
" you can use >> or << keys to indent current line or selection
" in normal mode.
set shiftwidth=4
" show some autocomplete options in status bar
set wildmenu
"auto-save a modified buffer when switching to another buffer
set autowrite
"edit a file without losing modifications to the current file and history
set hidden
"always set autoindenting on
set autoindent		
"This is useful if you use a 'makeprg' that writes to 'makeef' by itself.  
"If you want no piping, but do want to include the 'makeef', set 'shellpipe' to a single space.
set sp=\ 
set laststatus=2        " A status line will be used to separate windows 
                        " 'laststatus' = 2  -> always a status line
"set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ lin:%l\,%L\ col:%c%V\ pos:%o\ ascii:%b\ %P
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
"set grepprg=grep -n
set clipboard=unnamed "have Vim use the clipboard instead of the default register for yanking, putting

highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

" Set viminfo options
" Set viminfo location in $VIM
set viminfo='50,<1000,s100,:100 ",nc:\opt\vim\_viminfo

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
"  set patchmode		" Keep versions
endif
if has("unix")
    set fileformat=unix
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
    set fileformat=dos
    set guifont=Dina:h10:cDEFAULT
    au GUIEnter * simalt ~x "maximize window in Windows
    " For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
    set guioptions+=aegmrL
    let &guioptions = substitute(&guioptions, "t", "", "g")
    "share clipboard with windows clipboard
    set clipboard+=unnamed
endif

"colorscheme darkblue
colorscheme northsky

"search recursively upwards for the tags file
"ctags -R -f c:\opt\Vim\tags\python.ctags c:\opt\Python26\
set tags=./tags

"c:\opt\Vim\vimfiles\ftplugin\python_pydiction.vim options
"let g:pydiction_location = 'c:\opt\Vim\vimfiles\ftplugin\pydiction\complete-dict'
"let g:pydiction_menu_height = 20

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

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
   syntax on             " Enable syntax highlighting
   filetype on           " Enable filetype detection
   filetype indent on    " Enable filetype-specific indenting
   filetype plugin on    " Enable filetype-specific plugins

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
    "change the pink omnicomplete popup to a readable color: 
    highlight Pmenu guibg=brown gui=bold
	"inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
	"set completeopt=longest,menuone,preview
	"inoremap   pumvisible() ? "\" : "\u\"
	"inoremap   pumvisible() ? "\c-n>" : "\c-n>\c-r>=pumvisible() \? \"\\down>\" : \"\"\cr>" 
	"inoremap   pumvisible() ? "\c-n>" : "\c-x>\c-o>\c-n>\ \c-p>\c-r>=pumvisible() ? \"\\down>\" : \"\"\cr>"
    
    "Then all you have to do to use your code completion is hit the unnatural, wrist breaking, keystrokes CTRL+X, CTRL+O. I’ve re-bound the code completion to CTRL+Space since we are making vim an IDE! Add this command to your .vimrc to get the better keybinding:
    "inoremap <Nul> <C-x><C-o>

    endif

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 80 characters.
  autocmd FileType text setlocal textwidth=80

   "change directory to whatever file I'm currently editing
   autocmd BufEnter * lcd %:p:h

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

    "let perl_fold=1
    "augroup filetypedetect
    "autocmd! BufNewFile,BufRead *.epl,*.phtml setf embperl
    "augroup END

    "au FileType perl ":silent 1,$!perltidy -i=4 -syn -bbc -bar -ce -bt=2 -pt=2 -sbt=2 -q -st %" 
    au GUIEnter * simalt ~x

    " load XMl folding
    " au BufNewFile,BufRead *.xml,*.msifact,*.wxs,*.wxi,*.htm,*.html so c:\opt\Vim\vimfiles\plugin\XMLFolding.vim 
    let g:xml_syntax_folding = 1
    let makeElementSuf = ';;'
    augroup filetypedetect
    autocmd! BufNewFile,BufRead *.msifact,*.wxs,*.wxi,*.xaml setf xml
    autocmd! BufNewFile,BufRead *.sql setf sqlserver
    augroup END

    "Make your that python is in your path, now when you open any python file just type ":make" to get the syntax errors, use ":cnext", to move to next error, check the help on make (":help make") for more info on how to navigate errors.
    "As you are checking now, <F5> is mapped to execute the current script.
    autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
    autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
    autocmd BufRead *.py nmap <F5> :!python %<CR>
    "That will make to use a 4 spaces for you tabstop (only visually), it avoids wrapping your code and will add a bottom scrollbar.
    autocmd BufRead *.py set tabstop=4
    "autocmd BufRead *.py set nowrap
    autocmd BufRead *.py set go+=b

    " vimtl : Allow to handle todo lists 
    autocmd BufWinEnter *.otl call Loadvimtl()
    autocmd BufWinEnter *.tl call Loadvimtl() 

endif " has("autocmd")

"
" MAPPINGS
"
"map copy/paste
nmap <S-Insert> "+gP
imap <S-Insert> <ESC><S-Insert>i
vmap <C-Insert> "+y

let mapleader = ","
"map F5 on make
map <buffer> <F5> :Make<cr><C-w><Up>

"map Shift-M on clean win32 line ends
map M :%s///g
"map Ctrl-M on clean tabs/spaces from end line
map <C-m> :1,$s/[ <tab>]*$//

"JSBeautyfier
map <buffer> <F12> :call g:Jsbeautify()<cr>

" map <F6> to reindent
map <buffer> <F6> gg=G

"syn region myFold start="{" end="}" transparent fold
"syn sync fromstart
let perl_fold=1

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

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

"Taglist plugin
nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_Ctags_Cmd="c:\opt\tools\ctags.exe"
let Tlist_Exit_OnlyWindow = 1     " exit if taglist is last window open
let Tlist_Show_One_File = 1       " Only show tags for current buffer
let Tlist_Enable_Fold_Column = 0  " no fold column (only showing one file)
let tlist_sql_settings = 'sql;P:package;t:table'
let tlist_ant_settings = 'ant;p:Project;r:Property;t:Target'
let tlist_perl_settings = 'perl;c:Classes;s:Subroutines'

"SOME MORE SETTINGS:
"
" automatically save and restore folds
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview

" this lets us put the marker in the file so that
" it can be shared across and stored in version control.
"set foldmethod=marker
" this is for python, put
" # name for the folded text # {{{
" to begin marker and
" # }}}
" close to end it.
set commentstring=\ #\ %s
" default fold level, all open, set it 200 or something
" to make it all closed.
set foldlevel=5

" minibufexplorer settings:j
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapCTabSwitchWindows = 1

" GetLatestVimScripts will attempt to automatically install updated scripts
let g:GetLatestVimScripts_allowautoinstall=1

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


"vim-task
inoremap <silent> <buffer> <C-Space> <ESC> :call Toggle_task_status()<CR>i
noremap <silent> <buffer> <C-Space> :call Toggle_task_status()<CR>
