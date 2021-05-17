{ config, pkgs, ... }:

{
	imports = [
		#./hardware-configuration.nix
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
	boot.loader.grub.device = "nodev";
	boot.loader.grub.enableCryptodisk = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.efi.efiSysMountPoint  = "/boot/efi";
	boot.initrd.availableKernelModules = [
		"aes_x86_64"
		"aesni_intel"
		"cryptd"
	];

	fileSystems."/" =
	{ device = "/dev/vol/root";
		fsType = "ext4";
	};

	fileSystems."/home" =
	{ device = "/dev/vol/home";
		fsType = "ext4";
	};

	fileSystems."/data" =
	{ device = "/dev/vol/data";
		fsType = "ext4";
	};

	fileSystems."/boot" =
	{ device = "/dev/mapper/boot-crypt";
		fsType = "ext4";
	};

	boot.initrd.luks.devices."boot-crypt".device = "/dev/disk/by-uuid/4b7a0822-06ba-4dc0-a4f6-860f53b7a591";
	boot.initrd.luks.devices."hdd-crypt".device = "/dev/disk/by-uuid/81c2df4b-f848-4a5d-867b-7457f7192a61";

	fileSystems."/boot/efi" =
	{ device = "/dev/sda1";
		fsType = "vfat";
	};

	swapDevices =
		[ { device = "/dev/vol/swap"; }
		];


	# networking
	networking = {
		hostName = "thehill";
		useDHCP = false;
		interfaces.eno1.useDHCP = true;
		interfaces.wlo1.useDHCP = true;
		
		#wireless.enable = true;
		#networkmanager.enable = true;
		#networkmanager.wifi.backend = "iwd";
	};

	# video drivers
	hardware.opengl.enable = true;
	hardware.opengl.extraPackages = with pkgs; [
		amdvlk
		vaapiIntel
		libvdpau-va-gl
		vaapiVdpau
		intel-ocl
	];
	environment.variables.VK_ICD_FILENAMES =
	"/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json";

	system.stateVersion = "20.09";
}
