{ config, lib, ... }: 
{
	boot.loader.grub.enable = lib.mkDefault true;
	boot.loader.grub.version = lib.mkDefault 2;
	boot.loader.grub.memtest86.enable = lib.mkDefault false;
	boot.loader.timeout = lib.mkDefault 2;
}
