{ config, pkgs, ... }:

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

  # tester
  fileSystems."/home/adrien/mymount" = {
    device = "/dev/disk/e1ac2b27-f11a-4f83-b8b1-afa2dbb0eef1";
    fsType = "ext4";
    options = [ "rw" "user" "noauto"];
  };

  # À faire en utilisant la commande : file --mime-type <fichier>
  # xdg.mime.defaultApplications = {
  #   "application/pdf" = "firefox.desktop";
  # }

  systemd.user.services.niri.enableDefaultPath = false;

  security.polkit.enable = true;
  security.soteria.enable = true;

  services.gnome.gnome-keyring.enable = true;
  services.displayManager.ly.enable = true;
  services.glances.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true; # Permet à nautilus de voir les périphériques
  services.blueman.enable = true;

  programs.niri.enable = true;
  programs.fish.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;
  programs.evince.enable = true;
  programs.seahorse.enable = true;
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
      core.editor = "hx";
      merge.tool = "hx";
      merge.conflictstyle = "diff3";
      mergetool.prompt = false;
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
    };
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
     nautilus
     gnome-calculator
     gnome-disk-utility
     keepassxc
     localsend
     eog
     xournalpp
     libreoffice

     # Application dans le terminal
     helix
     yazi
     eza
     ttdl
     chezmoi
     pass
     trashy
     fastfetch

     # Application pour le WM
     waybar
     fuzzel
     mako
     awww
     wlogout
     swaylock-effects
     batsignal
     gammastep
     brightnessctl
     pwvucontrol
     wtype
     cliphist

     # Autre
     python3
     rustup
     libnotify
     fzf
     ripgrep
     keychain
     yt-dlp
     alsa-utils
     networkmanagerapplet
     pinentry-qt
     xwayland-satellite
     xdg-desktop-portal-gnome
     xdg-desktop-portal-gtk
     dconf
     adwaita-icon-theme
     wl-clipboard
  ];

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 15d";
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
