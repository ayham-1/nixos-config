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

	# yea i live in the center of the world, absolutely
	location.latitude = 0.0;
	location.longitude = 0.0;

	home-manager.users.sisyphus = { pkgs, ... }: {
		programs.home-manager.enable = true;

		# set up xdg variables
		xdg.enable = true;
		#xdg.configHome = "~/.config";
		#xdg.dataHome = "~/.local/share";
		#xdg.cacheHome = "~/.cache";

		xdg.userDirs.enable = true;
		xdg.userDirs.desktop = "\$HOME/desk";
		xdg.userDirs.documents = "\$HOME/dox";
		xdg.userDirs.download = "\$HOME/dl";
		xdg.userDirs.extraConfig = { XDG_MISC_DIR = "\$HOME/misc"; };
		xdg.userDirs.music = "\$HOME/muz";
		xdg.userDirs.pictures = "\$HOME/pix";
		xdg.userDirs.publicShare = "\$HOME/pub";
		xdg.userDirs.templates = "\$HOME/templ";
		xdg.userDirs.videos = "\$HOME/vidz";

		programs.ssh.enable = true;
		programs.git.enable = true;

		# aliases
		programs.bash.enable = true;
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
		#programs.fish.enable = true;
		programs.fish.shellAliases = {
			config = "git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME";
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

	# ~/ clean-up & generic env vars
	environment = {
		variables.DOTFILES_LOC ="/usr/share/dotfiles";
		variables = {
			EDITOR = "nvim";
			VISUAL = "emacs";
			TERMINAL = "alacritty";
			BROWSER = "firefox";

			LESSHISTFILE = "-";
			PASSWORD_STORE_DIR = "~/.config/pass";
			#GNUPGHOME = "~/.config/gnupg";
		};
	};
}
