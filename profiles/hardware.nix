{ config, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		lshw
		usbutils
		pciutils
	];

	# network drivers
	#boot.initrd.kernelModules = [ "iwlwifi" ]; # for initrd wifi
	hardware.enableRedistributableFirmware = true;
	hardware.enableAllFirmware = true;
}
