{ config, pkgs, lib, ... }: {
	imports = [ <home-manager/nixos> ];

	home-manager.users.sisyphus = { pkgs, ... }: {
		programs = {
			obs-studio = {
				enable = true;
				plugins = with pkgs; [ obs-v4l2sink  ];
			};

			git = {
				userName = "ayham";
				userEmail = "altffour@protonmail.com";
				signing.key = "B4ADFA86EDF5CCE9";
			}
		}
	}

	# GPG
	programs.gnupg.package = "pkgs.gnupg";
	programs.gnupg.agent.enable = true;
	programs.gnupg.agent.pinentryFlavor = "qt";
	programs.gnupg.dirmngr.enable = true;
}
