A repo to backup my settings and config files for various things like text-editor's, code formatters, etc.

## [Neovim](https://github.com/neovim/neovim)

The `init.vim` is for Neovim and should be placed at `~/.config/nvim/init.vim`

### Arch-Linux plugin dependencies

`clang python-neovim` are needed for the YouCompleteMe plugin.\
`editorconfig-core-c` is needed for the editorconfig-vim plugin.\
The formatters `uncrustify` and `prettier` are needed for the custom vim-autoformat commands.

## Other stuff

The `settings.json` and `bindings.json` are for the [Micro](https://github.com/zyedidia/micro) text-editor.\
The `cpp-gitignore` is copied into a new C++ project's directory as a `.gitignore` file for easy project creation.\
The `uncrustify.cfg` is my preferred settings for [Uncrustify](https://github.com/uncrustify/uncrustify) formatting on C++ files.\
