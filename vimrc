" Load plumapleadergins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'editorconfig/editorconfig-vim'
Plug 'joshdick/onedark.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
" Better Whitespace {{{
Plug 'ntpeters/vim-better-whitespace'
autocmd FileType fugitive DisableWhitespace
let g:better_whitespace_enabled = 1
let g:better_whitespace_guicolor='LightYellow'
let g:better_whitespace_ctermcolor='LightYellow'
let g:strip_max_file_size = 0
let g:strip_whitelines_at_eof = 1
let g:strip_whitespace_confirm = 0
let g:strip_whitespace_on_save = 0
autocmd FileType javascript,c,cpp,java,html,ruby,yaml,python EnableStripWhitespaceOnSave
" }}}
call plug#end()

" Leader Shortcuts {{{
let mapleader = ','
let g:mapleader = ','
nnoremap <Leader>o :only<CR>
nnoremap <leader><space> :noh<CR>             " Turn off highlighting until the next search
nnoremap <leader>l :set list! list?<CR>       " Toggle list mode
nnoremap <leader>n :call ToggleNumber()<CR>   " Toggle line number
nnoremap <leader>1 :set number!<CR>
nnoremap <leader>e :NERDTreeToggle<CR>        " Open/Close Nerdtree file manager
" surround word
nnoremap <leader>" ciw"<C-r>""<esc>
nnoremap <leader>' ciw'<C-r>"'<esc>
nnoremap <leader>{ ciw{<C-r>"}<esc>
nnoremap <leader>( ciw(<C-r>")<esc>
nnoremap <leader>[ ciw[<C-r>"]<esc>
nnoremap <leader>< ciw<<C-r>"><esc>
" surround selection
vnoremap <leader>" c"<C-r>""<esc>
vnoremap <leader>' c'<C-r>"'<esc>
vnoremap <leader>{ c{<C-r>"}<esc>
vnoremap <leader>( c(<C-r>")<esc>
vnoremap <leader>[ c[<C-r>"]<esc>
vnoremap <leader>< c<<C-r>"><esc>
nnoremap <Leader><Leader> <C-^>         " <Leader><Leader> -- Open last buffer.
set pastetoggle=<Leader>t
" }}}
" Normal mode mappings {{{
nmap <S-tab> :bNext<cr>         " For fast moving through buffers
" Faster switching between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-o> <C-w>o
" Prevent x and the delete key from overriding what's in the clipboard.
noremap x "_x
noremap X "_x
noremap <Del> "_x
" Prevent selecting and pasting from overwriting what you originally copied.
" xnoremap p pgvy
" }}}
" Visual mode mappings {{{
" move selected block up/down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap < <gv
vnoremap > >gv
" greatest remap ever
" no overwrite paste
" xnoremap <leader>p "_dP
xnoremap p "_dP
" }}}

syntax enable           " enable syntax processing
set nocompatible        " Don't try to be vi compatible

scriptencoding utf-8
set encoding=utf-8
set backspace=indent,eol,start    " Fix backspace key

set tabstop=2           " 2 space tab
set expandtab           " use spaces for tabs
set softtabstop=2       " 2 space tab
set shiftwidth=2
set modelines=1
filetype indent on
filetype plugin on
set autoindent

" Undo / Swap
set nobackup noswapfile nowritebackup undofile undodir=~/.vim/undo undolevels=99999
set scrolloff=999

" UI Layout
set number              " show line numbers
set highlight+=N:DiffText             " make current line number stand out a little
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set wildmenu
set lazyredraw
set showmatch           " higlight matching parenthesis
set listchars=eol:¶,trail:•,tab:▸\  showbreak=¬\

" Automation for numbering modes
" Automatically switch to absolute line numbers when in insert mode
" and relative numbers when in normal mode
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
autocmd FocusLost * :set norelativenumber
autocmd FocusGained * :set relativenumber

" Searching
set ignorecase          " ignore case when searching
set incsearch           " search as characters are entered
set hlsearch            " highlight all matches

" Status line
set laststatus=2   " Always show the status line - use 2 lines for the status bar
set statusline=
set statusline+=%#PmenuSel#
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c

" Themes
" set t_Co=256
set background=dark
set termguicolors
"silent! colorscheme onedark
colorscheme catppuccin_mocha

" Filetype settings
autocmd FileType python setlocal omnifunc=python3complete#Complete
autocmd FileType yaml setlocal ai ts=2 sts=2 sw=2 expandtab number cursorcolumn omnifunc=syntaxcomplete#Complete
autocmd FileType yaml autocmd BufWritePre <buffer> %s/\s\+$//e            " Automatically removing all trailing whitespace
" Set color for cursorcolumn
autocmd VimEnter * highlight CursorColumn guibg=#45475a

" Custom Functions
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

function RemoveM()
%s/^M//
:endfunction

function RemoveWhiteSpace()
%s/^ \+ $//       " replaces a line that starts and ends with white spaces
%s/^ $//          " replaces a single white space that is alone on a line
%s/ \+$//         " replaces the end of a line that finishes with trailing spaces
%s/ $//           " replaces the end of a line that finishes with single white space
:endfunction

function! StripTrailingWhitespace()
  normal mZ
  let l:chars = col("$")
  %s/\s\+$//e
  if (line("'Z") != line(".")) || (l:chars != col("$"))
    echo "Trailing whitespace stripped\n"
  endif
  normal `Z
endfunction

" Allow for per-machine overrides in ~/.vim/host/hostname and
" ~/.vim/vimrc.local.
let s:hostfile = $HOME . '/.vim/host/' . substitute(hostname(), "\\..*", '', '')
if filereadable(s:hostfile)
  execute 'source ' . s:hostfile
endif

let s:vimrc_local = $HOME . '/.vim/.vimrc.local'
if filereadable(s:vimrc_local)
  execute 'source ' . s:vimrc_local
endif
