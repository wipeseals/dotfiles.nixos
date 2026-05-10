{ config, pkgs, ... }:

{

  nix = {
    settings = { 
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  # 9757: WiVRn
  networking.firewall.allowedTCPPorts = [ 9757 ];
  networking.firewall.allowedUDPPorts = [ 9757 ];
  
  time.timeZone = "Asia/Tokyo";
  i18n = {
    defaultLocale = "ja_JP.UTF-8";
    consoleKeyMap = "us";
    extraLocaleSettings = {
      LC_ADDRESS = "ja_JP.UTF-8";
      LC_IDENTIFICATION = "ja_JP.UTF-8";
      LC_MEASUREMENT = "ja_JP.UTF-8";
      LC_MONETARY = "ja_JP.UTF-8";
      LC_NAME = "ja_JP.UTF-8";
      LC_NUMERIC = "ja_JP.UTF-8";
      LC_PAPER = "ja_JP.UTF-8";
      LC_TELEPHONE = "ja_JP.UTF-8";
      LC_TIME = "ja_JP.UTF-8";
    };
    inputMethod.enable = true;
    inputMethod.enabled = "fcitx5";
    inputMethod.fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  # fonts
  fonts.enableDefaultPackages = true;
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts

    ubuntu-classic
    liberation_ttf

    carlito
    dejavu_fonts
    ipafont
    kochi-substitute
    source-code-pro
    ttf_bitstream_vera
  ];
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    monospace = [
      "DejaVu Sans Mono"
      "IPAGothic"
    ];
    sansSerif = [
      "DejaVu Sans"
      "IPAPGothic"
    ];
    serif = [
      "DejaVu Serif"
      "IPAPMincho"
    ];
  };

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable avahi/adb for vr headset server
  services.avahi = {
    enable = true;
    publish.userServices = true;
  };
  programs.adb.enable = false; # enable this to install apps on the headset

  # for `#!/bin/bash`
  services.envfs.enable = true;
  # for shared libs
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # for Vivado/Vitis installer, etc...
    xorg.libXext
    xorg.libX11
    xorg.libXrender
    xorg.libXtst
    xorg.libXi
    freetype
    fontconfig
  ];

  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [   
    # core tools
    vim
    git
    git-lfs
    curl
    wget
    direnv
    mozc
    kdePackages.fcitx5-configtool
    kdePackages.fcitx5-qt
    docker

    # cli tools
    tmux
    byobu
    lazygit
    jq
    ripgrep
    bat
    fd
    eza
    helix
    fzf
    gh
    starship
    gcc

    # VRChat+Unity
    blender
    unityhub
    wivrn
    wayvr
    alcom
    gimp

    # cad
    kicad

    # common apps
    google-chrome
    vscode
    discord

    # games
    steam
    steamcmd
    protonplus
  ];
  environment.sessionVariables = {
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; 
      dedicatedServer.openFirewall = true; 
      localNetworkGameTransfers.openFirewall = true;
      package = pkgs.steam.override {
        extraProfile = ''
          # Allows Monado/WiVRn to be used
          export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
          # Fixes timezones on VRChat
          unset TZ
        '';
      };
    };
    starship = {
      enable = true;
    };
  };

  virtualisation.docker = {
    enable = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
      # Optionally customize rootless Docker daemon settings
      daemon.settings = {
        dns = [ "1.1.1.1" "8.8.8.8" ];
        registry-mirrors = [ "https://mirror.gcr.io" ];
      };
    };
  };
 
  system.stateVersion = "25.11";
}
