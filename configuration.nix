# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jan-desktop-nixos"; # Define your hostname.
  networking.extraHosts = ''
    127.0.0.1 jan-desktop-nixos
  ''; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "en_US";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      bash
      atom
      cmake
      discord
      docker
      docker-compose
      dunst
      evince
      ffmpeg
      file
      firefox
      gcc
      gdb
      gimp
      git
      google-chrome
      gparted
      htop
      idea.idea-ultimate
      jdk
      jetbrains.webstorm
      ghostscript
      maven
      pavucontrol
      slack
      spotify
      # steam # takes up way too much space
      sudo
      thunderbird
      rxvt_unicode
      unzip
      vim
      libsForQt5.vlc
      wget
      zathura
      zoom-us
      nodejs
      yarn

      # custom packages
      # (import ./pkgs/custom/technic-launcher.nix)
      # (import ./pkgs/nur-packages.nix)
    ];
    
    variables = {
      EDITOR = "urxvt";
    };
  };

  fonts.fonts = with pkgs; [
    hermit
    source-code-pro
    terminus_font
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
  ];

  virtualisation.virtualbox.host.enable = true;

  # we want some unfree packages
  nixpkgs.config = {
    # allowUnfree = true;
    
    oraclejdk.accept_license = true;

    
  };

  # look at https://github.com/CrazedProgrammer/nix/blob/master/pkgs/custom/technic-launcher.nix
 

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  
  # Support for 32 bit software
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  
  #List services to enable
  services = {
    openssh.enable = true;
    printing.enable = true; #enable CUPS to print
    nixosManual.showManual = true;

    xserver = {
      enable = true;
      
      config = ''
        Section "Monitor"
          Identifier "DisplayPort-0"
        EndSection
        Section "Monitor"
          Identifier "HDMI-A-1"
          Option "LeftOf" "DisplayPort-0"
        EndSection
      '';
      
      layout = "de, us";
      
      exportConfiguration = true;
      
      # Enable the KDE Desktop Environment.
      displayManager.sddm.enable = true;
      # Only setting needed for kde5
      desktopManager.plasma5.enable = true;
      desktopManager.xterm.enable = false;
      desktopManager.gnome3.enable = false;

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          i3lock
          i3status
          dmenu
          j4-dmenu-desktop
        ];
      };
      

      videoDrivers = [ "amdgpu" ];
    };
  };

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jan = {
    isNormalUser = true;
    home = "/home/jan";
    description = "Jan-Philipp Kirsch";
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" ]; # Enable ‘sudo’ for the user and allow user to configure network
  };

  fileSystems."/data" =
  { device = "/dev/sdb2";
    fsType = "ext4";
  };

  
  
  #keepitn up-to date
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

