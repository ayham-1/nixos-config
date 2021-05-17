{ config, pkgs, lib, ... }:

{
	imports = [ <nixpkgs/nixos/modules/profiles/hardened.nix> ];

	# Setup firewall
	networking.firewall.enable = true;
	#networking.firewall.package = pkgs.ufw;
	networking.firewall.allowPing = false;
	#networking.firewall.extraCommands = "ufw default deny incoming";

	# Apparmor
	security.apparmor.enable = true;
	security.apparmor.confineSUIDApplications = true;
	security.audit.enable = true;
	security.auditd.enable = true;
	security.chromiumSuidSandbox.enable = true;

	# General Hardening
	security.forcePageTableIsolation = true;
	security.hideProcessInformation = false; # for wayland
	security.sudo.enable = true;

	# Kernel Hardening
	boot.kernelPackages = pkgs.linuxPackages_hardened;
	security.protectKernelImage = true;
	boot.kernelParams = [
		"slub_debug=FZP"
		"page_poison=1"
		"page_alloc.shuffle=1"
		"lsm=lockdown,yama,apparmor,bpf"
	];

	# Sandboxing
	programs.firejail.enable = true;
}
