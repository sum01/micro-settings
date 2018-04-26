" Auto-installs vim-plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall
endif

" Plug (plugin manager) plugins
" All are from Github.com
call plug#begin()
	" TODO: Remove youcompleteme & ale if LSP works better...
	" Autocompletion. Note that install.py runs after install
	" Requires Boost & Clang installed at the system level
	"Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --system-libclang --system-boost' }
	" Linting
	"Plug 'w0rp/ale'

	" The Monokai colorscheme
	Plug 'sickill/vim-monokai'
	" Editorconfig support
	Plug 'editorconfig/editorconfig-vim'
	" Code auto-formatter
	Plug 'Chiel92/vim-autoformat'
	" Makes the statusline a lot better
	Plug 'vim-airline/vim-airline'
	" Adds a bunch of themes to the vim-airline plugin
	Plug 'vim-airline/vim-airline-themes'
	" Adds a file-tree viewer
	Plug 'scrooloose/nerdtree'
	" A nerdtree plugin that adds Git status indicators
	Plug 'Xuyuanp/nerdtree-git-plugin'
	" This is an autocomplete engine, and is used by LanguageClient-neovim
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	" The raw snippets for neosnippet
	Plug 'Shougo/neosnippet-snippets'
	" This is needed for LanguageClient-neovim auto-completion
	Plug 'Shougo/neosnippet.vim'
	" This provides an LSP API, which you use for any language servers you have
	Plug 'autozimu/LanguageClient-neovim', {
	\ 'branch': 'next',
	\ 'do': './install.sh',
	\ }
call plug#end()

let g:deoplete#enable_at_startup = 1
" Makes tab work for the auto-complete snippets dropdown
imap <expr><TAB>
	\ pumvisible() ? "\<C-n>" :
	\ neosnippet#expandable_or_jumpable() ?
	\    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
			\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
let g:LanguageClient_serverCommands = {
	\ 'cpp': ['cquery', '--log-file=/tmp/cq.log'],
	\ 'c': ['cquery', '--log-file=/tmp/cq.log'],
\ }

" This expects your settings.json to be in the same dir as your init.vim
let g:LanguageClient_settingsPath = expand('<sfile>:p:h') . '/settings.json'
let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
" No idea what this crap is, but it was recommended...
set completefunc=LanguageClient#complete
set formatexpr=LanguageClient_textDocument_rangeFormatting()
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

" This function finds and returns an uncrustify config file
" If no local one found, it uses my fall-back
function! s:GetUncrustConf()
	" globpath finds the cfg file (or nothing), fnamemodify turns it into an absolute path
	let l:uncrustconf = fnamemodify(globpath('.', '*.cfg'), ':p')

	" Actually check if there's an uncrustify config in the current dir
	if filereadable(l:uncrustconf)
		return l:uncrustconf
	else
		" My fall-back config file
		return '~/dev/personal-configs/formatter-configs/uncrustify.cfg'
	endif
endfunction

" This defines uncrustify with the current local cfg, or my fall-back
" Although it won't dynamically reload, so close vim if changing projects...
let g:formatdef_uncrustify = "'" . "uncrustify -q -l CPP -c " . s:GetUncrustConf() . "'"

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

" A custom var to toggle on/off as needed
let s:autoformat_run_on_save = 1
" For when you know you want it disabled
function! s:DisableAutoformat()
	let s:autoformat_run_on_save = 0
	echom 'Disabled auto-formatting on-save'
endfunction
" For when you know you want it enabled
function! s:EnableAutoformat()
	let s:autoformat_run_on_save = 1
	echom 'Enabled auto-formatting on-save'
endfunction

command! DisableAutoformat call s:DisableAutoformat()
command! EnableAutoformat call s:EnableAutoformat()

" Run autoformat only if enabled
function! g:RunAutoformatIfEnabled()
	if (s:autoformat_run_on_save)
		" Runs the command created by vim-autoformat plugin
		Autoformat
	endif
endfunction

" Tells vim-autoformat to run on-save
au BufWrite * :call RunAutoformatIfEnabled()

" Disable the crappy Fuchsia lints for the Ale plugin
let g:ale_cpp_clangtidy_checks=['-fuchsia*']
" Sets the Airline plugin theme on startup (requires airline_themes plugin)
let g:airline_theme = 'minimalist'
" Tells Airline to reskin the tabline as well
" This shows all existing buffers, which is a bit annoying...
let g:airline#extensions#tabline#enabled = 1
