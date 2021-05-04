{ config, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		lshw
		usbutils
		pciutils
		pactl
	];
	programs.light.enable = true;
}
