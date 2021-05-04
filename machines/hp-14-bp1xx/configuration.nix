{ config, pkgs, ... }:

{
	imports = [
		/etc/nixos/hardware-configuration.nix
		../../profiles/desktop.nix
		../../profiles/communication.nix
		../../profiles/development.nix
		../../profiles/notebook.nix
		../../profiles/hardware.nix
		../../profiles/security.nix
		../../profiles/personal.nix
	];

	# Use GRUB 2 boot loader
	boot.loader.grub.enable = true;
	boot.loader.grub.version = 2;
	boot.loader.grub.efiSupport = true;
	boot.loader.grub.device = "/dev/sda";
	boot.loader.grub.enableCryptodisk = true;
	boot.loader.eif.canTouchEfiVariables = true;
	boot.loader.eif.efiSysMountPoint  = "/boot/efi";
	boot.initrd.availableKernelModuels = [
		"aes_x86_64"
		"aesni_intel"
		"cryptd"
	];

	# networking
	networking = {
		hostName = "thehill";
		
		wireless.enable = true;
		useDHCP = true;
	};

	# video drivers
	hardware.opengl.enable = true;
	hardware.opengl.extraPackages = [
		amdvlk
		pkgs.vaapiIntel
		pkgs.libvdpau-va-gl
		pkgs.vaapiVdpau
		pkgs.intel-ocl
	];
	environment.variables.VK_ICD_FILENAMES =
	"/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json";
}
