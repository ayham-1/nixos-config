{ config, pkgs, libs, ... }:

{
	# Setup firewall
	networking.firewall.enable = mkDefault true;
	networking.firewall.package = mkDefault "pkgs.ufw";
	networking.firewall.allowPing = mkDefault false;

	# Apparmor
	security.apparmor.enable = mkDefault true;
	security.apparmor.confineSUIDApplications = mkDefault true;
	security.audit.enable = mkDefault true;
	security.auditd.enable = mkDefault true;
	security.chromiumSuidSandbox.enable = mkDefault true;

	# General Hardening
	security.forcePageTableIsolation = mkDefault true;
	security.hideProcessInformation = mkDefault true;
	security.sudo.enable = mkDefault true;

	# Kernel Hardening
	boot.kernelPackages = mkDefault pkgs.linuxPackages_hardened;
	security.protectKernelImage = mkDefault true;
	nix.allowedUsers = mkDefault [ "@users" ];
	environment.memoryAllocator.provider = mkDefault "scudo";
	environment.variables.SCUDO_OPTIONS = mkDefault "ZeroContents=1";
	security.lockKernelModules = mkDefault true;
	# This is required by podman to run containers in rootless mode.
	security.unprivilegedUsernsClone = mkDefault config.virtualisation.containers.enable;
	security.virtualisation.flushL1DataCache = mkDefault "always";
	boot.kernelParams = [
		"slub_debug=FZP"
		"page_poison=1"
		"page_alloc.shuffle=1"
	];
	boot.kernel.sysctl."kernel.yama.ptrace_scope" = mkOverride 500 1;
	boot.kernel.sysctl."kernel.kptr_restrict" = mkOverride 500 2;
	boot.kernel.sysctl."net.core.bpf_jit_enable" = mkDefault false;
	boot.kernel.sysctl."kernel.ftrace_enabled" = mkDefault false;
	# Enable strict reverse path filtering (that is, do not attempt to route
	# packets that "obviously" do not belong to the iface's network; dropped
	# packets are logged as martians).
	boot.kernel.sysctl."net.ipv4.conf.all.log_martians" = mkDefault true;
	boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = mkDefault "1";
	boot.kernel.sysctl."net.ipv4.conf.default.log_martians" = mkDefault true;
	boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = mkDefault "1";
	# Ignore broadcast ICMP (mitigate SMURF)
	boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = mkDefault true;
	# Ignore incoming ICMP redirects (note: default is needed to ensure that the
	# setting is applied to interfaces added after the sysctls are set)
	boot.kernel.sysctl."net.ipv4.conf.all.accept_redirects" = mkDefault false;
	boot.kernel.sysctl."net.ipv4.conf.all.secure_redirects" = mkDefault false;
	boot.kernel.sysctl."net.ipv4.conf.default.accept_redirects" = mkDefault false;
	boot.kernel.sysctl."net.ipv4.conf.default.secure_redirects" = mkDefault false;
	boot.kernel.sysctl."net.ipv6.conf.all.accept_redirects" = mkDefault false;
	boot.kernel.sysctl."net.ipv6.conf.default.accept_redirects" = mkDefault false;

	# Ignore outgoing ICMP redirects (this is ipv4 only)
	boot.kernel.sysctl."net.ipv4.conf.all.send_redirects" = mkDefault false;
	boot.kernel.sysctl."net.ipv4.conf.default.send_redirects" = mkDefault false;

	# Sandboxing
	programs.firejail.enable = true;
}
