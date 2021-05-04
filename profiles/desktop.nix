{ config= pkgs, lib, ... }:

{
	imports = [
		"./common.nix"
		"../services/fonts"
		"../users/sisyphus/base.nix"
	];

	# set up NUR
	nixpkgs.config.packageOverrides = pkgs: {
		nur = import (builtins.fetchTarball
				"https://github.com/nix-community/NUR/archive/master.tar.gz") {
				inherit pkgs;
		};
	};

	# enable boot splash
	boot.plymouth.enable = true;

	# setup sway
	wayland.windowManager.sway.enable = true;
	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true;
		extraPackages = with pkgs; [
			swaylock
			swayidle
			wl-clipboard
			mako
			alacritty
			bemenu
			wf-recorder
			flashfocus
			autotiling
			waybar
			kanshi
			xwayland
		];
		extraOptions = [
			"--my-next-gpu-wont-be-nvidia"
		];
		extraSessionCommands = ''
			export SDL_VIDEODRIVER=wayland
			# needs qt5.qtwayland in systemPackages
			export QT_QPA_PLATFORM=wayland
			export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
			# Fix for some Java AWT applications (e.g. Android Studio),
			# use this if they aren't displayed properly:
			export _JAVA_AWT_WM_NONREPARENTING=1
			'';
	};
	environment.systemPackages = with pkgs; [ wl-clipboard ];
	environment.systemPackages = with pkgs; [
		gtk-engine-murrine
		gtk_engines
		gsettings-desktop-schemas
		lxappearance
	];
	programs.qt5ct.enable = true;
	systemd.user.services.swayidle = {
		description = "Idle Manager for Wayland";
		documentation = [ "man:swayidle(1)" ];
		wantedBy = [ "sway-session.target" ];
		partOf = [ "graphical-session.target" ];
		path = [ pkgs.bash ];
		serviceConfig = {
			ExecStart = '' ${pkgs.swayidle}/bin/swayidle -w -d \
				    timeout 300 '${pkgs.sway}/bin/swaymsg "output * dpms off"' \
				    resume '${pkgs.sway}/bin/swaymsg "output * dpms on"'
				    '';
		};
	};
	# Here we but a shell script into path, which lets us start sway.service (after importing the environment of the login shell).
	environment.systemPackages = with pkgs; [
		(
		 pkgs.writeTextFile {
		 name = "startsway";
		 destination = "/bin/startsway";
		 executable = true;
		 text = ''
		 #! ${pkgs.bash}/bin/bash

		 # first import environment variables from the login manager
		 systemctl --user import-environment
		 # then start the service
		 exec systemctl --user start sway.service
		 '';
		 }
		)
	];
	systemd.user.targets.sway-session = {
		description = "Sway compositor session";
		documentation = [ "man:systemd.special(7)" ];
		bindsTo = [ "graphical-session.target" ];
		wants = [ "graphical-session-pre.target" ];
		after = [ "graphical-session-pre.target" ];
	};
	systemd.user.services.sway = {
		description = "Sway - Wayland window manager";
		documentation = [ "man:sway(5)" ];
		bindsTo = [ "graphical-session.target" ];
		wants = [ "graphical-session-pre.target" ];
		after = [ "graphical-session-pre.target" ];
		# We explicitly unset PATH here, as we want it to be set by
		# systemctl --user import-environment in startsway
		environment.PATH = lib.mkForce null;
		serviceConfig = {
			Type = "simple";
			ExecStart = ''
				${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
				'';
			Restart = "on-failure";
			RestartSec = 1;
			TimeoutStopSec = 10;
		};
	};
	services.redshift = {
		enable = true;
		# Redshift with wayland support isn't present in nixos-19.09 atm. You have to cherry-pick the commit from https://github.com/NixOS/nixpkgs/pull/68285 to do that.
		package = pkgs.redshift-wlr;
	};

	programs.waybar.enable = true;

	systemd.user.services.kanshi = {
		description = "Kanshi output autoconfig ";
		wantedBy = [ "graphical-session.target" ];
		partOf = [ "graphical-session.target" ];
		serviceConfig = {
		# kanshi doesn't have an option to specifiy config file yet, so it looks
		# at .config/kanshi/config
			ExecStart = ''
				${pkgs.kanshi}/bin/kanshi
				'';
			RestartSec = 5;
			Restart = "always";
		};
	};


	# setup firefox
	program.firefox = {
		enable = true;
		extensions = with pkgs.nur.repos.rycee.firefox-addons; [
			privacy-badger
			CookieAutoDelete
			CanvasBlocker
			uBlock
			https-everywhere
			cookiemaster
			vimium-c
			darkreader
			treestyletab
		];
		package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
			forceWayland = true;
			profiles.sisyphus = {
				id = 0;
				isDefault = true;
				name = "sisyphus";
				settings = {
					"app.normandy.api_url" = "";
					"app.normandy.enabled" = false;
					"app.shield.optoutstudies.enabled" = false;
					"app.update.auto" = false;
					"beacon.enabled" = false;
					"breakpad.reportURL" = "";
					"browser.aboutConfig.showWarning" = false;
					"browser.cache.offline.enable" = false;
					"browser.crashReports.unsubmittedCheck.autoSubmit" = false;
					"browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
					"browser.crashReports.unsubmittedCheck.enabled" = false;
					"browser.disableResetPrompt" = true;
					"browser.newtab.preload" = false;
					"browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
					"browser.newtabpage.enabled" = false;
					"browser.newtabpage.enhanced" = false;
					"browser.newtabpage.introShown" = true;
					"browser.safebrowsing.appRepURL" = "";
					"browser.safebrowsing.blockedURIs.enabled" = false;
					"browser.safebrowsing.downloads.enabled" = false;
					"browser.safebrowsing.downloads.remote.enabled" = false;
					"browser.safebrowsing.downloads.remote.url" = "";
					"browser.safebrowsing.enabled" = false;
					"browser.safebrowsing.malware.enabled" = false;
					"browser.safebrowsing.phishing.enabled" = false;
					"browser.search.suggest.enabled" = false;
					"browser.selfsupport.url" = "";
					"browser.send_pings" = false;
					"browser.sessionstore.privacy_level" = 2;
					"browser.shell.checkDefaultBrowser" = false;
					"browser.startup.homepage_override.mstone" = "ignore";
					"browser.tabs.crashReporting.sendReport" = false;
					"browser.urlbar.speculativeConnect.enabled" = false;
					"browser.urlbar.trimURLs" = false;
					"datareporting.healthreport.service.enabled" = false;
					"datareporting.healthreport.uploadEnabled" = false;
					"datareporting.policy.dataSubmissionEnabled" = false;
					"device.sensors.ambientLight.enabled" = false;
					"device.sensors.enabled" = false;
					"device.sensors.motion.enabled" = false;
					"device.sensors.orientation.enabled" = false;
					"device.sensors.proximity.enabled" = false;
					"dom.battery.enabled" = false;
					"dom.event.clipboardevents.enabled" = false;
					"dom.webaudio.enabled" = false;
					"experiments.activeExperiment" = false;
					"experiments.enabled" = false;
					"experiments.manifest.uri" = "";
					"experiments.supported" = false;
					"extensions.CanvasBlocker@kkapsner.de.whiteList" = "";
					"extensions.ClearURLs@kevinr.whiteList" = "";
					"extensions.Decentraleyes@ThomasRientjes.whiteList" = "";
					"extensions.TemporaryContainers@stoically.whiteList" = "";
					"extensions.autoDisableScopes" = 14;
					"extensions.getAddons.cache.enabled" = false;
					"extensions.getAddons.showPane" = false;
					"extensions.greasemonkey.stats.optedin" = false;
					"extensions.greasemonkey.stats.url" = "";
					"extensions.pocket.enabled" = false;
					"extensions.shield-recipe-client.api_url" = "";
					"extensions.shield-recipe-client.enabled" = false;
					"extensions.webservice.discoverURL" = "";
					"media.autoplay.default" = 1;
					"media.autoplay.enabled" = false;
					"media.eme.enabled" = false;
					"media.gmp-widevinecdm.enabled" = false;
					"media.navigator.enabled" = false;
					"media.peerconnection.enabled" = false;
					"media.video_stats.enabled" = false;
					"network.allow-experiments" = false;
					"network.captive-portal-service.enabled" = false;
					"network.cookie.cookieBehavior" = 1;
					"network.dns.disablePrefetch" = true;
					"network.dns.disablePrefetchFromHTTPS" = true;
					"network.http.referer.spoofSource" = true;
					"network.http.speculative-parallel-limit" = 0;
					"network.predictor.enable-prefetch" = false;
					"network.predictor.enabled" = false;
					"network.prefetch-next" = false;
					"network.trr.mode" = 5;
					"privacy.donottrackheader.enabled" = true;
					"privacy.donottrackheader.value" = 1;
					"privacy.firstparty.isolate" = true;
					"privacy.resistFingerprinting" = true;
					"privacy.trackingprotection.cryptomining.enabled" = true;
					"privacy.trackingprotection.enabled" = true;
					"privacy.trackingprotection.fingerprinting.enabled" = true;
					"privacy.trackingprotection.pbmode.enabled" = true;
					"privacy.usercontext.about_newtab_segregation.enabled" = true;
					"security.ssl.disable_session_identifiers" = true;
					"services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = false;
					"signon.autofillForms" = false;
					"toolkit.telemetry.archive.enabled" = false;
					"toolkit.telemetry.bhrPing.enabled" = false;
					"toolkit.telemetry.cachedClientID" = "";
					"toolkit.telemetry.enabled" = false;
					"toolkit.telemetry.firstShutdownPing.enabled" = false;
					"toolkit.telemetry.hybridContent.enabled" = false;
					"toolkit.telemetry.newProfilePing.enabled" = false;
					"toolkit.telemetry.prompted" = 2;
					"toolkit.telemetry.rejected" = true;
					"toolkit.telemetry.reportingpolicy.firstRun" = false;
					"toolkit.telemetry.server" = "";
					"toolkit.telemetry.shutdownPingSender.enabled" = false;
					"toolkit.telemetry.unified" = false;
					"toolkit.telemetry.unifiedIsOptIn" = false;
					"toolkit.telemetry.updatePing.enabled" = false;
					"webgl.disabled" = true;
					"webgl.renderer-string-override" = " ";
					"webgl.vendor-string-override" = " ";
				};
			};
		};
	};
	services.pipewire.enable = true;
	environment.sessionVariables = {
		MOZ_ENABLE_WAYLAND = "1";
		XDG_CURRENT_DESKTOP = "sway"; 
	};
	home.sessionVariables = {
		MOZ_ENABLE_WAYLAND = 1;
		XDG_CURRENT_DESKTOP = "sway"; 
	};
	xdg = {
		portal = {
			enable = true;
			extraPortals = with pkgs; [
				xdg-desktop-portal-wlr
				xdg-desktop-portal-gtk
			];
			gtkUsePortal = true;
		};
	};

	programs.chromium = {
		enable = true;
		extensions = [
			"cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
			"gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
		];
		extraOpts = {
			"BrowserSignin" = 0;
			"SyncDisabled" = true;
			"PasswordManagerEnabled" = false;
			"AutofillAddressEnabled" = false;
			"AutofillCreditCardEnabled" = false;
			"BuiltInDnsClientEnabled" = ffalse;
			"MetricsReportingEnabled" = false;
			"SearchSuggestEnabled" = false;
			"AlternateErrorPagesEnabled" = false;
			"SpellcheckEnabled" = true;
			"SpellcheckLanguage" = [ "en-US" ]
			"CloudPrintSubmitEnabled" = false;
		};
	};

	# setup zathura
	programs.zathura.enable = true;
	programs.zathura.options = {
		default-bg = "#000000"; 
		default-fg = "#FFFFFF";
	};

	# setup fish
	programs.fish.enable = true;

	# setup tmux
	programs.tmux.enable = true;
	programs.tmux.extraConfig = "
		unbind C-b
		set-option -g prefix C-a
		bind-key C-a send-prefix

		bind | split-window -h
		bind - split-window -v
		unbind '\"'
		unbind %

		bind -n M-h select-pane -L
		bind -n M-l select-pane -R
		bind -n M-k select-pane -U
		bind -n M-j select-pane -D

		set -g mouse on

		set-option -g allow-rename on

		bind-key r command-prompt -I \"#W\" "rename-window '%%'"

		set -g default-terminal \"screen-256color\"";

	enviornment.systemPackges = with pkgs; [
		chromium
		firefox
		libreoffice
		neofetch
		flameshot
		zathura
		fish
	];
}
