{ config, pkgs, libs, ... }:

{
	imports = [ "../users/sisyphus/personal.nix" ];

	environment.systemPackages = with pkgs; [
		virtmanager
	]

	virtualisation.docker.enable = true;

	virtualisation.libvirtd = {
		enable = true;
		qemuPackage = pkgs.qemu_kvm;
	};
}
