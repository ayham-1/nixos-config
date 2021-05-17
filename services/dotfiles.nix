{ config, ... }:

{
	imports = [ ../users/sisyphus/base.nix ];
	home-manager.users.sisyphus = { pkgs, ... }: {
		xdg.configFile."emacs".source = "/usr/share/dotfiles/dotfiles/emacs";

	};
}
