" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
				silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
				autocmd VimEnter * PlugInstall
endif
call plug#begin('~/.config/nvim/plugged')

" Plug (plugin manager) plugins
" All are from Github.com
call plug#begin()
" Autocompletion. Note that install.py needs to run as it has to be compiled after
" download
Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --system-libclang --system-boost' }
" The Monokai colorscheme
Plug 'crusoexia/vim-monokai'
" Editorconfig support
Plug 'editorconfig/editorconfig-vim'
" Code auto-formatter
Plug 'Chiel92/vim-autoformat'
" File browser
Plug 'scrooloose/nerdtree'
" A nerdtree plugin that adds Git status indicators
Plug 'Xuyuanp/nerdtree-git-plugin'
call plug#end()

" Colorscheme has to come after the plug#end() or it breaks things
colorscheme monokai
" Enables the line number ruler
set number
" Sets tab width to 2
set tabstop=2
set shiftwidth=2
" Enable mouse support
set mouse=a
" Tells splits to go below the current thing
set splitbelow
" Tells splits to go to the right instead of left
set splitright
" Remap split movement to a single key instead of having to use it with CTRL-W
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Remap's the 'move block/line' command to work with keybindings
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" Keybind 'copy selection' to system clipboard
vmap <C-c> "+y

" Tells YouCompleteMe where the compilation flags are at
let g:ycm_global_ycm_extra_conf = '~/.config/nvim/.ycm_extra_conf.py'

" DEBUG: Print error crap
"let g:autoformat_verbosemode=1

" Create formatters for vim-autoformat to use
let g:formatdef_uncrustify = '"uncrustify -q -c ~/dev/personal-configs/uncrustify.cfg -l CPP"'
" NOTE: --use-tabs since checking for tabs seems to not work?
let g:formatdef_luafmt = '"luafmt --use-tabs --stdin -i ".&shiftwidth'
let g:formatdef_prettier_markdown = '"prettier --stdin --parser markdown --use-tabs true --tab-width ".&shiftwidth'
let g:formatdef_shfmt = '"shfmt -s -i 0"'
" NOTE: --tab-size 0 for tabs instead of spaces
"let g:formatdef_cmake_format = '"cmake-format --dangle-parens true --line-ending unix --tab-size 1"'
" Actually tells vim-autoformat to use the custom command on C++ files
let g:formatters_cpp = ['uncrustify']
let g:formatters_lua = ['luafmt']
let g:formatters_markdown = ['prettier_markdown']
let g:formatters_sh = ['shfmt']
"let g:formatters_cmake = ['cmake_format']
" Disables the fallback formatting if vim-autoformat doesn't find a formatter
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0
" Tells vim-autoformat to run on-save
au BufWrite * :Autoformat
