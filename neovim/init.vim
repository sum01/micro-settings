" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
				silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
				autocmd VimEnter * PlugInstall
endif

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
" Linting
Plug 'w0rp/ale'
call plug#end()

" Use true-color for colorscheme
set termguicolors
" Colorscheme has to come after the plug#end() or it breaks things
colorscheme monokai
" Enables the line number ruler
set number
" Sets tab width to 2
set tabstop=2
" Don't use softtabs
set softtabstop=0
" Actually use tabs over spaces
set noexpandtab
" ??? Some more tab display stuff
set shiftwidth=2
" Enable mouse support
set mouse=a
" Tells splits to go below the current thing
set splitbelow
" Tells splits to go to the right instead of left
set splitright
" Disables the preview window from opening when auto-completers (such as YouCompleteMe) trigger it.
set completeopt-=preview
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
" Keybind the terminal-mode exit keys to Escape
tnoremap <Esc> <C-\><C-n>

" Tells YouCompleteMe where the compilation flags are at
let g:ycm_global_ycm_extra_conf = '~/.config/nvim/.ycm_extra_conf.py'

" DEBUG: Print error crap
"let g:autoformat_verbosemode=1

" Create formatters for vim-autoformat to use
let g:formatdef_uncrustify = '"uncrustify -q -c ~/dev/personal-configs/uncrustify.cfg -l CPP"'

" Check if we're using tabs
if &expandtab ==? 'noexpandtab'
	" luafmt doesn't accept true/false into --use-tabs
	let g:formatdef_luafmt = '"luafmt --use-tabs --stdin -i ".&shiftwidth'
	" A 0 passed to -i signifies tabs
	let g:formatdef_shfmt = '"shfmt -s -i 0"'
	let g:formatdef_prettier_markdown = '"prettier --stdin --parser markdown --use-tabs true --tab-width ".&shiftwidth'
	let g:formatdef_prettier_json = '"prettier --stdin --parser json --use-tabs true --tab-width ".&shiftwidth'
	let g:formatdef_prettier_javascript = '"prettier --stdin --use-tabs true --tab-width ".&shiftwidth'
else
	let g:formatdef_luafmt = '"luafmt --stdin -i ".&shiftwidth'
	" shfmt uses non-zero values to the -i flag for spaces
	let g:formatdef_shfmt = '"shfmt -s -i ".&shiftwidth'
	let g:formatdef_prettier_markdown = '"prettier --stdin --parser markdown --use-tabs false --tab-width ".&shiftwidth'
	let g:formatdef_prettier_json = '"prettier --stdin --parser json --use-tabs false --tab-width ".&shiftwidth'
	let g:formatdef_prettier_javascript = '"prettier --stdin --use-tabs false --tab-width ".&shiftwidth'
endif

" The dash at the end tells it to use stdin
"let g:formatdef_cmake_format = '"cmake-format --command-case lower --dangle-parens true --line-ending unix --tab-size 1 -"'
" Actually tells vim-autoformat to use the custom command on C++ files
let g:formatters_cpp = ['uncrustify']
let g:formatters_lua = ['luafmt']
let g:formatters_markdown = ['prettier_markdown']
let g:formatters_sh = ['shfmt']
let g:formatters_javascript = ['prettier_javascript']
let g:formatters_json = ['prettier_json']
"let g:formatters_cmake = ['cmake_format']
" Disables the fallback formatting if vim-autoformat doesn't find a formatter
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0
" Tells vim-autoformat to run on-save
au BufWrite * :Autoformat
