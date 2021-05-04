{ config, ... }:

{
	imports = [ "../users/sisyphus/base.nix" ];
	xdg.configFile."sway/config".source = environment.variables.DOTFILES_LOC
	+ "sway/config";

	xdg.configFile."emacs".source = environment.variables.DOTFILES_LOC +
	"emacs";

	xdg.configFile = {
		"xdg/waybar/config".source = environment.variables.DOTFILES_LOC
		+ "waybar/config";
		"xdg/waybar/style.css".source = environment.variables.DOTFILES_LOC
		+ "waybar/style.css";
	};
}
