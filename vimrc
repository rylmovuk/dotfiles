#!/usr/bin/vim -S

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

set undodir="$HOME/.vim/undo/,."
set backupdir="$HOME/.vim/backup/,."

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  " autocmd FileType text setlocal textwidth=78

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

call plug#begin()
Plug 'zig-lang/zig.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'
Plug 'chriskempson/base16-vim'
Plug 'tmhedberg/SimpylFold'
Plug 'vim-scripts/indentpython.vim'
call plug#end()

func! WordProcessorMode()                                     
  setlocal formatoptions=1                                    
  setlocal noexpandtab                                        
  map j gj                                                    
  map k gk                                                    
  setlocal spell spelllang=it_it                              
"  set thesaurus+=/Users/sbrown/.vim/thesaurus/mthesaur.txt   
  set complete+=s                                             
  set formatprg=par                                           
  setlocal wrap                                               
  setlocal linebreak                                          
endfu                                                         
com! WP call WordProcessorMode()

set enc=utf-8
set noshowmode
set ruler
set number
set nu
" Enable folding
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
nnoremap <space> za

nnoremap K i<CR><Esc>
let base16colorspace=256
let g:airline_theme='minimalist'
let python_highlight_all=1
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

colorscheme base16-seti

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" optional reset cursor on start:
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.maxlinenr=''

