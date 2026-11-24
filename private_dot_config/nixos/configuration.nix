{ config, pkgs, ngit, trashguard, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "fr_BE.UTF-8";
  console.keyMap = "fr-bepo";

  users = {
    mutableUsers = true;
    users."adrien" = {
      isNormalUser = true;
      description = "mynixos";
      initialHashedPassword = "$y$j9T$LcyXvNrGHpp5gZWGQgjWR1$lZfH0xigJBbCs5a.sqOt2BdbdZXZQ4Xk4tZhzEOsah2";
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "networkmanager"
        "netbird-wt0"
      ];
    };
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 10;
    };
    timeout = 0;
  };

  networking.hostName = "mynixos";
  networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      53317 # localsend
      22000 # syncthing
    ];
    allowedUDPPorts = [
      22000 # syncthing
      21027 # syncthing
    ];

  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 30;
  };

  # Pour imprimer
  # services.avahi = {
  #   enable = true;
  #   nssmdns4 = true;
  #   openFirewall = true;
  # };
  # services.printing = {
  #   enable = true;
  #   drivers = with pkgs; [
  #     cups-filters
  #     cups-browsed
  #   ];
  # };

  fileSystems."/home/adrien/mymount" = {
    device = "/dev/disk/by-uuid/e1ac2b27-f11a-4f83-b8b1-afa2dbb0eef1";
    fsType = "ext4";
    options = [ "rw" "user" "noauto"];
  };

  systemd.user.services.niri.enableDefaultPath = false;

  security.polkit.enable = true;
  security.soteria.enable = true;

  services.displayManager.ly.enable = true;
  services.glances.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.blueman.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;
  services.netbird.clients.wt0.port = 51821;
  services.resolved.enable = true;
  # services.syncthing = {
  #   enable = true;
  #   systemService = false;
  # };
  # systemd.targets.multi-user.wants = [ "syncthing@adrien.service" ];

  programs.niri.enable = true;
  programs.fish.enable = true;
  programs.starship.enable = true;
  programs.zoxide = {
    enable = true;
    flags = [ "--cmd e" ];
  };
  programs.ssh = {
    startAgent = true;
  };
  programs.gnupg.agent = {
    enable = true;
    settings = {
      default-cache-ttl = 3600;
    };
  };
  programs.git = {
    enable = true;
    config = {
      user.email = "fadri@proton.me";
      user.name = "fadri14";
      nostr.npub = "npub1nsg605enzd74yguz49gseh8ummrz5jl6hrwdxxdcj2rlt7vjm4hq69q0hj";
      nostr.nsec = "npub1nsg605enzd74yguz49gseh8ummrz5jl6hrwdxxdcj2rlt7vjm4hq69q0hj";
      core.editor = "hx";
      merge.tool = "hx";
      merge.conflictstyle = "diff3";
      mergetool.prompt = false;
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
    };
  };
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  environment.systemPackages = with pkgs; [
     # Application de bureau
     librewolf
     freetube
     spotify
     alacritty
     signal-desktop
     discord
     super-productivity
     nautilus
     gnome-calculator
     loupe
     papers
     showtime
     gnome-disk-utility
     keepassxc
     localsend
     xournalpp
     libreoffice
     joplin-desktop

     # Application dans le terminal
     helix
     yazi
     eza
     chezmoi
     trashy
     pass
     fastfetch
     ngit.packages.${stdenv.hostPlatform.system}.default
     trashguard.packages.${stdenv.hostPlatform.system}.default

     # Application pour le WM
     waybar
     fuzzel
     mako
     awww
     waylogout
     swaylock-effects
     batsignal
     gammastep
     brightnessctl
     pwvucontrol
     wtype
     cliphist

     # Autre
     android-file-transfer
     libnotify
     fzf
     ripgrep
     yt-dlp
     alsa-utils
     networkmanagerapplet
     pinentry-qt
     xwayland-satellite
     xdg-desktop-portal-gnome
     dconf
     adwaita-icon-theme
     wl-clipboard
     translate-shell
     zip
     unzip
  ];

  # Le certificat du homelab
  security.pki.certificates = [
    ''
    -----BEGIN CERTIFICATE-----
    MIIB/DCCAYKgAwIBAgIIYGkdcuTSodQwCgYIKoZIzj0EAwMwIDEeMBwGA1UEAxMV
    bWluaWNhIHJvb3QgY2EgNjA2OTFkMCAXDTI2MTAyMTE0MTY0MloYDzIxMjYxMDIx
    MTQxNjQyWjAgMR4wHAYDVQQDExVtaW5pY2Egcm9vdCBjYSA2MDY5MWQwdjAQBgcq
    hkjOPQIBBgUrgQQAIgNiAAROFGbBDuKqoW6ZRH9dPJ7iE/rCdjrY09I7tAdiyu1D
    2c66LtxBNVMNCTWvNf4eNNQAclhx5wX6G638b/MATv2zuxHvoze1LJVA9WfwYLez
    TH++2huBz5BG1ds+RHw+8rujgYYwgYMwDgYDVR0PAQH/BAQDAgKEMB0GA1UdJQQW
    MBQGCCsGAQUFBwMBBggrBgEFBQcDAjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1Ud
    DgQWBBSeiwXQWum72QBlgiPkvCwm/dNFXDAfBgNVHSMEGDAWgBSeiwXQWum72QBl
    giPkvCwm/dNFXDAKBggqhkjOPQQDAwNoADBlAjEAk1/xf4w27xXlL8+YDgCe+w7F
    nxdbKS30SRlgAB7KOYPYbaAq3E+rAGSI1aUQ1FVMAjB3Cw34VWmQsrEPQwzT19Mx
    gnFrCGWKJHqZh5hvs9V54gBelNrI/coHYcsQqmJB/T4=
    -----END CERTIFICATE-----
    ''
  ];

  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "/home/adrien/.config/nixos#mynixos";
  };

  nix.optimise = {
    automatic = true;
    dates = "weekly";
    persistent = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";

  # services.openssh = {
  #   enable = true;
  #   openFirewall = true;
  #   settings = {
  #     PasswordAuthentication = true;
  #     PermitRootLogin = "no";
  #   };
  # };
}
