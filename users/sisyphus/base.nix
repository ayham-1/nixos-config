{ config, pkgs, lib, ... }:

{
	imports = [ <home-manager/nixos> ];

	users.users.sisyphus = {
		isNormalUser = true;
		home = "/home/sisyphus";
		description = "";
		extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" "libvirtd" ];
		hashedPassword =
			"$6$UElxymiLttxtbHbX$Jt.lWxlWc29MvJNYa97lB57iiMQdhhtDMpXXlRyP.3oFlkgfihhNHy9MRFdvMDCgKo.rXenSamIZyC.mEb/o20";
	};

	home-manager.useUserPackages = true;
	home-manager.useGlobalPkgs = true;

	home-manager.users.sisyphus = { pkgs, ... }: {
		programs = {
			bash = {
				enable = true;
				historyControl = [ "ignoredups" "ignorespace" ];
			};

			ssh.enable = true;

			git.enable = true;
		};
	}

	# set up xdg variables
	xdg.enable = true;
	xdg.configHome = "~/.config";
	xdg.dataHome = "~/.local/share";
	xdg.cacheHome = "~/.cache";

	xdg.userDirs.enable = true;
	xdg.userDirs.createDirectories = true;
	xdg.userDirs.desktop = "\$HOME/desk";
	xdg.userDirs.documents = "\$HOME/dox";
	xdg.userDirs.download = "\$HOME/dl";
	xdg.userDirs.extraConfig = "\$HOME/misc";
	xdg.userDirs.music = "\$HOME/muz";
	xdg.userDirs.pictures = "\$HOME/pix";
	xdg.userDirs.publicShare = "\$HOME/pub";
	xdg.userDirs.templates = "\$HOME/templ";
	xdg.userDirs.videos = "\$HOME/vidz";

	# ~/ clean-up & generic env vars
	environment = let config_loc = "~/.config/" in {
		variables.EDITOR="/usr/share/dotfiles";
		variables = {
			EDITOR = "nvim";
			VISUAL = "emacs";
			TERMINAL = "alacritty";
			BROWSER = "firefox";

			LESSHISTFILE = "-";
			WGETRC = config_loc + "wgetrc";
			PASSWORD_STORE_DIR = config_loc + "pass";
			GNUPGHOME = config_loc + "gnupg";

			DOTFILES_LOC = "/usr/share/dotfiles/";
		};
	};

	# aliases
	home-manager.users.sisyphus = { pkgs, ... }: {
		programs.bash.shellAliases = {
			config = "git --git-dir=$HOME/.config/dotfiles
			--work-tree=$HOME";
			myip = "curl ipinfo.io/ip";
			cp = "cp -iv";
			rm = "rm -iv";
			ll = "ls -lhA";
			g = "g";
			e = "$EDITOR";
			v = "$VISUAL";
			".." = "cd ..";
		};
		programs.fish.shellAliases = {
			config = "git --git-dir=$HOME/.config/dotfiles
			--work-tree=$HOME";
			myip = "curl ipinfo.io/ip";
			cp = "cp -iv";
			rm = "rm -iv";
			ll = "ls -lhA";
			g = "g";
			e = "$EDITOR";
			v = "$VISUAL";
			".." = "cd ..";
		};
	};
}
