{ config, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		# irc
		irssi
		# matrix
		#element-desktop
		# messengers
		discord
		# gnupg
		#gpa
		# rss
		#newsboat
		# video
		mpv
		youtube-dl
		# music
		cmus
	];

	home-manager.users.sisyphus = { pkgs, ... }: {
		# setup newsboat
		programs.newsboat = {
			enable = true;
			autoReload = true;
			reloadThreads = 4;
			extraConfig = ''
				bind-key j down feedlist
				bind-key k up feedlist
				bind-key j next articlelist
				bind-key k prev articlelist
				bind-key J next-feed articlelist
				bind-key K prev-feed articlelist
				bind-key j down article
				bind-key k up article

				macro m set browser "mpv --ytdl %u --profile=360p > /dev/null &"; open-in-browser ; set browser "lynx -nocolor"
				macro a set browser "echo %u | xclip -sel clip"; open-in-browser ; set browser "lynx -nocolor"
				macro v set browser "curl %u | feh - &"; open-in-browser ; set browser "lynx -nocolor"

				delete-played-files no
				download-path "~/dox/pod/%h/%n"
				max-downloads 4
				player "nvlc"
				color listfocus           white   black   bold
				color listfocus_unread    white   black   bold
				color info                white   black   bold

				unbind-key C feedlist
				confirm-exit no
				cleanup-on-quit no
				'';
			urls = [
			{ tags = [ "XKCD" ]; url = "https://xkcd.com/atom.xml"; }
			{ tags = [ "Linux Journal" ]; url =
				"https://www.linuxjournal.com/news.rss"; }
			{ tags = [ "ItsFOSS" ]; url = "https://itsfoss.com/feed"; }
			{ tags = [ "Opensource News" ]; url =
				"https://opensource.org/news.xml"; }
			{ tags = [ "WeLiveSecurity" ]; url =
				"https://www.welivesecurity.com/feed"; }
			{ tags = [ "ItsFOSS" ]; url = "https://itsfoss.com/feed"; }
			];
		};
	};
}
