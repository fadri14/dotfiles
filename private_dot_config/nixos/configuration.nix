{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 10;
    };
    timeout = 0;
  };

    # Tester plymouth sur un autre pc
  # boot = {
  #   plymouth = {
  #     enable = true;
  #     theme = "rings";
  #     themePackages = with pkgs; [
  #       (adi1090x-plymouth-themes.override {
  #         selected_themes = [ "circle hud" "cross hud" "cubes" "deus ex" "pixels" "rings" "spinner alt" ];
  #       })
  #     ];
  #   };

  #   consoleLogLevel = 3;
  #   initrd.verbose = false;
  #   kernelParams = [
  #     "quiet"
  #     "rd.udev.log_level=3"
  #     "rd.systemd.show_status=auto"
  #   ];

  #   loader = {
  #     efi.canTouchEfiVariables = true;
  #     systemd-boot = {
  #       enable = true;
  #       editor = false;
  #     };
  #     timeout = 0;
  #   };
  # };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "mynixos";
  networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53317 ]; # localsend
  };

  time.timeZone = "Europe/Brussels";

  i18n.defaultLocale = "fr_BE.UTF-8";

  console.keyMap = "fr-bepo";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  users = {
    mutableUsers = false;
    users."adrien" = {
      isNormalUser = true;
      description = "mynixos";
      hashedPassword = "$y$j9T$LcyXvNrGHpp5gZWGQgjWR1$lZfH0xigJBbCs5a.sqOt2BdbdZXZQ4Xk4tZhzEOsah2";
      shell = pkgs.fish;
      extraGroups = [
        # "networkmanager" # Tester si c'est utile
        "wheel"
      ];
    };
  };

  fileSystems."/home/adrien/mymount" = {
    device = "/dev/disk/e1ac2b27-f11a-4f83-b8b1-afa2dbb0eef1";
    fsType = "ext4";
    options = [ "rw" "user" "noauto"];
  };

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

  # À faire en utilisant la commande : file --mime-type <fichier>
  # xdg.mime.defaultApplications = {
  #   "application/pdf" = "firefox.desktop";
  # }

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 30;
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

  programs.gnupg.agent = {
    enable = true;
    settings = {
      default-cache-ttl = 3600;
    };
    pinentryPackage = pkgs.pinentry-qt;
  };

  systemd.user.services.niri.enableDefaultPath = false;

  security.polkit.enable = true;
  security.soteria.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.displayManager.ly.enable = true;

  programs.niri.enable = true;
  programs.fish.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;
  programs.gtklock.enable = true;
  programs.evince.enable = true;
  services.glances.enable = true;
  programs.seahorse.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  environment.systemPackages = with pkgs; [
     helix
     fastfetch
     librewolf
     freetube
     spotify
     ttdl
     localsend
     wlogout
     alacritty
     fuzzel
     mako
     awww
     nautilus
     signal-desktop
     gnome-calculator
     xournalpp
     fzf
     eog
     ripgrep
     gnome-disk-utility
     pass
     keychain
     zenity
     discord
     wtype
     python3
     gammastep
     yt-dlp
     keepassxc
     rustup
     eza
     chezmoi
     yazi
     pinentry-qt # Tester si c'est utile
     xwayland-satellite
     xdg-desktop-portal-gnome
     xdg-desktop-portal-gtk
     waybar
     jq
     libnotify
     dconf
     adwaita-icon-theme
     brightnessctl
     pwvucontrol
     alsa-utils
     trashy
     wl-clipboard
     cliphist
  ];

  # services.openssh = {
  #   enable = true;
  #   openFirewall = true;
  #   settings = {
  #     PasswordAuthentication = true;
  #     PermitRootLogin = "no";
  #   };
  # };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
