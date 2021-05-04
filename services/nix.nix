{ config, ... }:

{
	nix = {
		useSandbox = true;
		trustedUsers = [
			"root"
			"@wheel"
		];
	};
}
