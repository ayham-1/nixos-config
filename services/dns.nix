{ config, lib, ... }:

{
	#networking.hostFiles = [ ../dotfiles/hosts ];
	#networking.hostFiles = [  ];
	networking.extraHosts = (builtins.readFile ../dotfiles/hosts);
}
