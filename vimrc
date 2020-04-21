#!/usr/bin/vim -S

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if &term =~ "^st"
  set ttymouse=sgr
endif

set undodir=$HOME/.vim/undo//,.
set backupdir=$HOME/.vim/backup//,.

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
Plug 'fatih/vim-go'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'
Plug 'tmhedberg/SimpylFold'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
call plug#end()

let g:UltiSnipsSnippetsDir = ".vim/UltiSnips"
let g:UltiSnipsExpandTrigger = "<Tab>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"

fun SpellCheck()
	setlocal spell
	setlocal spelllang=it,en_us,ru
endf

let g:ale_fixers = {
\	'javascript': [
\		'eslint',
\	],
\}

set enc=utf-8
set noshowmode
set ruler
set number
set splitright
set foldmethod=indent
set foldlevel=99
set relativenumber

" Make `go back` easier to input on us_intl layout
nnoremap ´ ''

nnoremap <Space>w <C-w>
nnoremap <Space>f :vim // ./**/*<CR>:copen<CR>
nnoremap <Space>s :w<CR>
nnoremap <Space>m :make
nnoremap <Leader>s :%s/
nnoremap <Space>cc :%ClipCopy<CR><CR>
nnoremap <Space>cv :r !xclip -o -sel c<CR><CR>
nnoremap <Space>; :

vnoremap <Space>cc :ClipCopy<CR><CR>
vnoremap <Space>; :
" Easily quit ins mode
inoremap kj <C-[>
inoremap jk <C-[>
" Instantly correct spelling mistake
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
" Making 'replace-paste' work (don't touch " register)
vnoremap p "_dP
" :Trail -- Remove trailing spaces
com -range=% -bar Trail <line1>,<line2>substitute/\s\+$//ge
" :ClipCopy -- Copy to X clipboard
com -range ClipCopy <line1>,<line2>w !xclip -i -sel c
" K=inverse of J -- split line under cursor
" nnoremap K i<CR><Esc>

" Easily disable highlighting after a search
nmap <Leader>/ :noh<CR>
let base16colorspace=256
let g:airline_theme='minimalist'
let python_highlight_all=1
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

colorscheme base16-seti
hi SpellBad	cterm=undercurl	ctermfg=1 ctermbg=0
hi SpellCap	cterm=undercurl ctermfg=3 ctermbg=0

" set cursor on mode change
if exists('$TMUX')
	let &t_SI = "\<Esc>Ptmux;\<Esc>\e[6 q\<Esc>\\"
	let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
	let &t_SI = "\e[6 q"
	let &t_EI = "\e[2 q"
endif

augroup myFts
	autocmd!
	autocmd BufEnter *.svelte set ft=html
	autocmd BufEnter *.tex call s:latexParams()
augroup END

" optional reset cursor on start:
augroup myCmds
	autocmd!
	autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

augroup myAutoMake
	autocmd!
	autocmd BufWritePost vimrc source %
	autocmd BufWritePost *.tex silent make % | execute "normal \<C-L>" | belowright cwindow 4
	autocmd BufWritePost *.ly silent execute "!lilypond -s ".shellescape(expand("%"))
augroup END

function! s:latexParams()
	set makeprg=pdflatex\ -interaction=nonstopmode
	set efm=%E!\ LaTeX\ %trror:\ %m,
		\%E!\ %m,
		\%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#,
		\%+W%.%#\ at\ lines\ %l--%*\\d,
		\%WLaTeX\ %.%#Warning:\ %m,
		\%Cl.%l\ %m,
		\%+C\ \ %m.,
		\%+C%.%#-%.%#,
		\%+C%.%#[]%.%#,
		\%+C[]%.%#,
		\%+C%.%#%[{}\\]%.%#,
		\%+C<%.%#>%.%#,
		\%C\ \ %m,
		\%-GSee\ the\ LaTeX%m,
		\%-GType\ \ H\ <return>%m,
		\%-G\ ...%.%#,
		\%-G%.%#\ (C)\ %.%#,
		\%-G(see\ the\ transcript%.%#),
		\%-G\\s%#,
		\%+O(%f)%r,
		\%+P(%f%r,
		\%+P\ %\\=(%f%r,
		\%+P%*[^()](%f%r,
		\%+P[%\\d%[^()]%#(%f%r,
		\%+Q)%r,
		\%+Q%*[^()])%r,
		\%+Q[%\\d%*[^()])%r

endfunction
