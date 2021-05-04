{ config, ... }:

{
	networking.extraHosts = fetchurl {
		url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts";
	};
}
