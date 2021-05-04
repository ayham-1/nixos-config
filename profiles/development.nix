{ config, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		pipenv
		python
		gcc
		rustup
		cargo

		emacs
		neovim
	];

	# setup htop
	programs.htop.enable = true;
	programs.htop.enableMouse = true;
	programs.htop.hideThreads = true;
	programs.htop.shadowOtherUsers = true;
	programs.htop.showCpuFrequency = true;
	programs.htop.treeView = true;
	programs.htop.vimMode = true;

	# setup emacs
	programs.emacs.enable = true;
	programs.emacs.package = "emacs";
	programs.emacs.extraPackages = "epkgs: [ epkgs.use-package ]"

	# setup neovim
	programs.neovim.enable = true;
	programs.neovim.viAlias = true;
	programs.neovim.vimAlias = true;
	programs.neovim.vimdiffAlias = true;
	programs.neovim.configure = {
		customRC = $'''
			filetype plugin indent on

			set t_Co =256
			filetype plugin indent on

			" Setup theme.
			set t_Co=256
			"colorscheme wal
			let g:airline_themes='onedark'

			" General
			set textwidth=80
			let mapleader = " "
			set clipboard+=unnamed
			set autoread
			set backspace=indent,eol,start
			set ignorecase
			set smartcase
			set incsearch
			set magic

			" Appearance
			set number
			set nowrap
			set showbreak=↪
			" toggle invisible characters
			set list
			"set listchars=tab:→\ ,eol:¬
			"set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮,space:·
			set list
			set ttyfast

			" Leader keys
			map <leader>e :bufdo e!<CR>
			nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

			" Custom settings.
			set mouse=a
			set encoding=utf-8
			set backspace=indent,eol,start
			set timeoutlen=50
			syntax on
			set rnu

		$''';
		packages.myVimPackage = with pkgs.vimPlugins; {
			start = [ ctrlp vimwiki vim-startify auto-pairs ];
		};
	};
}
