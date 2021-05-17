{ config, pkgs, lib, ... }: 
{
	imports = [ <home-manager/nixos> ];

	home-manager.users.sisyphus = { pkgs, ... }: {
		programs = {
			obs-studio = {
				enable = true;
				plugins = with pkgs; [ obs-v4l2sink ];
			};

			git = {
				userName = "ayham";
				userEmail = "altffour@protonmail.com";
				signing.key = "81D38F7122AFCC94";
				signing.signByDefault = true;
			};
		};
	};

	# GPG
	programs.gnupg = {
		package = pkgs.gnupg;
		agent.enable = true;
		agent.pinentryFlavor = "qt";
		dirmngr.enable = true;
	};
}
