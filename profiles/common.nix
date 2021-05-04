{ config, pkgs, libs, ... }:

{
	imports = [
		"../services/grub.nix"
		"../services/ntp.nix"
		"../services/dns.nix"
		"../services/localization.nix"
	];
	
	# mount tmpfs on /tmp
	boot.tmpOnTmpfs = lib.mkDefault true;

	# show IP on login screen
	environment.etc."issue.d/ip.issue".text = "\\4\n";
	networking.dhcpcd.runHook = "${pkgs.utillinux}/bin/agetty --reload";

	# common user configuration
	users.mutableUsers = false;

	# install basic packages
	environment.systemPackages = with pkgs; [
		htop
		iotop
		iftop
		wget
		curl
		tcpdump
		telnet
		whois
		file
		lsof
		inotify-tools
		strace
		gdb
		xz
		lz4
		zip
		unzip
		rsync
		tealdeer
		cheat
		tmux
		tree
		dfc
		pwgen
		mkpasswd
		jq
		gitAndTools.gitFull
	];

	programs.bash.enableCompletion = true;

	system.copySystemConfiguration = true;
}
