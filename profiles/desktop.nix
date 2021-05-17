{ config, pkgs, lib, ... }:

{
	imports = [
		./common.nix
		../services/fonts
		../users/sisyphus/base.nix
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
	# enable brightness control
	programs.light.enable = true;
	
	home-manager.users.sisyphus = { pkgs, ... }: {
		# setup sway config
		wayland.windowManager.sway = {
			enable = true;
			config = {
				terminal = "alacritty";
				modifier = "Mod4";
				menu = "bemenu-run";
				input = {
					"type:keyboard" = {
						xkb_layout = "us";
						xkb_options = "caps:swapescape";
						xkb_numlock = "enabled";
					};
					"type:touchpad" = {
						accel_profile = "adaptive";
						click_method = "clickfinger";
						dwt = "enabled";
						tap = "enabled";
						drag = "enabled";
					};
					"type:pointer" = {
						accel_profile = "flat";
						pointer_accel = "0.0";
					};
				};
				output = {
					eDP-1 = {
						pos = "0 0";
					};
					HDMI-A-1 = {
						pos = "1440 0";
					};
				};
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

		# setup waybar
		programs.waybar.enable = true;

		# setup tmux
		programs.tmux.enable = true;
		programs.tmux.extraConfig = ''
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

			set -g default-terminal \"screen-256color\"'';

		# setup chromium
		programs.chromium = {
			enable = true;
			package = pkgs.ungoogled-chromium;
			extensions = [
				"cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
				"gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
				"nngceckbapebfimnlniiiahkandclblb" # bitwarden
			];
		#extraOpts = {
		#	"BrowserSignin" = 0;
		#	"SyncDisabled" = true;
		#	"PasswordManagerEnabled" = false;
		#	"AutofillAddressEnabled" = false;
		#	"AutofillCreditCardEnabled" = false;
		#	"BuiltInDnsClientEnabled" = false;
		#	"MetricsReportingEnabled" = false;
		#	"SearchSuggestEnabled" = false;
		#	"AlternateErrorPagesEnabled" = false;
		#	"SpellcheckEnabled" = true;
		#	"SpellcheckLanguage" = [ "en-US" ];
		#	"CloudPrintSubmitEnabled" = false;
		#};
		};

		# setup firefox
		programs.firefox = {
			enable = true;
			extensions = with pkgs.nur.repos.rycee.firefox-addons; [
				privacy-badger
				bitwarden
				clearurls
				cookie-autodelete
				i-dont-care-about-cookies
				h264ify
				temporary-containers
				canvasblocker
				decentraleyes
				ublock-origin
				videospeed
				https-everywhere
				vimium
				darkreader
			];
			package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
				forceWayland = true;
			};
			profiles."sisyphus" = {
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
	# general configurations
	services.printing.enable = true;

	# sway
	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true;
		extraPackages = with pkgs; [
			swaylock
			swayidle
			swaylock
			wl-clipboard
			mako
			alacritty
			bemenu		
		];
	};

	# GDM & GUH-NOME as an alternative
	services.xserver.enable = true;
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.displayManager.gdm.wayland = true;
	services.xserver.desktopManager.gnome3.enable = true;
	services.gnome3.gnome-keyring.enable = true;

	# software packages
	environment.systemPackages = with pkgs; [
			#chromium
			#firefox
			libreoffice
			neofetch
			flameshot
			zathura
			fish
			networkmanager
			calibre
			bitwarden
			bitwarden-cli
			sway

			# theming
			gtk-engine-murrine
			gtk_engines
			gsettings-desktop-schemas
			lxappearance

			# guh-nome
			gnomeExtensions.appindicator
			gnome3.gnome-tweak-tool
			mousetweaks
	];
}

