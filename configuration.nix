{ config, pkgs, ... }:

{

  imports = [
    /etc/nixos/hardware-configuration.nix
    <home-manager/nixos>
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    hostName = "Kokasonz";
    networkmanager.enable = true;
  };

  # edit as per your location and timezone
  time.timeZone = "Amsterdam/Europe";
  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
      LC_CTYPE="en_US.utf8"; # required by dmenu don't change this
    };
  };

  sound.enable = true;

  services = {
    xserver = {
      layout = "us";
      xkbVariant = "";
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status
        ];
      };
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      displayManager = {
        lightdm.enable = true;
        defaultSession = "xfce+i3";
      };

      gtk3 = {
        enable = true;
        theme = {
          name = "elementary";
          package = pkgs.pantheon.elementary-icon-theme;
        };
      };

    };
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };
  
  users.users.willem = {
    isNormalUser = true;
    description = "willem";
    extraGroups = [ "networkmanager" "wheel" ];

    packages = with pkgs; [
      xarchiver
    ];
  };


  environment.systemPackages = with pkgs; [
    alacritty
    gtk3
    dmenu
    git
    gnome.gnome-keyring
    nerdfonts
    networkmanagerapplet
    nitrogen
    pasystray
    picom
    polkit_gnome
    pulseaudioFull
    rofi
    vim
    unrar
    unzip
    mysql
    firefox
    php
    telegram-desktop
    (vscode-with-extensions.override {
     vscode = vscodium;
     vscodeExtensions = with vscode-extensions; [
       bbenoist.nix
       ms-python.python
       ms-azuretools.vscode-docker
       ms-vscode-remote.remote-ssh
     ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
       {
         name = "remote-ssh-edit";
         publisher = "ms-vscode-remote";
         version = "0.47.2";
         sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
       }
     ];
   }) 	
  ];

  programs = {
    thunar.enable = true;
    dconf.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  
  hardware = {
    bluetooth.enable = true;
  };

  # Don't touch this
  system.stateVersion = "23.05";

home-manager.users.willem = { pkgs, ... }: {
  home.packages = [ pkgs.atool pkgs.httpie ];
  programs.bash.enable = true;
  # openssh.authorizedKeys.keys = [
  #     "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCR2rFOPbq0v7M3B8H18qNVxaTqP6Qoq2Cwb+LCUAZVmIHC6SZyzRP/abDrr/L7WdSvhFzVIxnocmFkHjRcaOyc17P6fSqVanaJvuv2bU3+K6fSHZoydR1vCNjIM1IC5onpYai5XU/0tk/fpuQ1K68S4RauzV2yEskx5y9xfmuV8BAtswxYJF7OQQR/7h0tjH9RGd+examOffj3n7U+7ma2JZJl+tbrPvvj+cNIQnxNPeblh7KEkzuBW4sXW6czCi9pskq16UUOhBwnbQSIIuIzUrL0XCTBP0l71/PmrxgfDwlBUV7PQj+PYehn94iPlO+zhkm/dENqX5PGGeaGYjcoPJ7/5j9rM5vFzJbYSdxfteWYdTjGDh1JcAT7OXzw8ma0A8gVve5fCEoNiWXZ45BW3jDtvgBPMtbqKWNGQanDKPWV+/fXkb9oCzqdMzyTaVYw4b6gTBKX+08L09cB3LfYrqu2/AujW5YOkC4isXcNyaLEV658WQfDM3+2Uiy7bZ6aiL/roL4VzrxZN0ZWCK20OwBnLnBn2gwhc3CoSvWXmoAEekGStq4SJrqBNoBmBsRdckDoYrDio3qpyx7aNSuAkR4uiPZ8BV5hkWqkdtaoP6hZ0b1avvl7iQKSILojnXRBqDoCuTeEWbr9AJ8GpCyOl4er9Qqa4TVoYgzlHCAMtQ== Home"
  #   ];
  home.stateVersion = "23.05";
};

}
