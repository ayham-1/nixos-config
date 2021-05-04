{ config, lib, ... }:

{
	services.ntp.enable = true;

	services.timesyncd = {
		enable = lib.mkDefault true;
		servers = [
			"0.asia.pool.ntp.org"
			"1.asia.pool.ntp.org"
			"2.asia.pool.ntp.org"
			"3.asia.pool.ntp.org"
		];
	};
}
