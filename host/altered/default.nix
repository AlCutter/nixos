# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ nixpkgs, inputs, config, lib, pkgs, ... }:
let
#  unstableTarball =
#    fetchTarball
#      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
      ./hardware-configuration.nix
      ../../module/dev
    ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    "luks-rpool-nvme-SAMSUNG_MZVLB512HAJQ-000L7_S3TNNF0K808752-part2".device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB512HAJQ-000L7_S3TNNF0K808752-part2";
  };

  nix = {
    settings = {
      extra-experimental-features = [
      	"nix-command"
	"flakes"
      ];
      trusted-users = [ "al" ];
    };
  };

  # Optimize storage and automatic scheduled GC running
  # If you want to run GC manually, use commands:
  # `nix-store --optimize` for finding and eliminating redundant copies of identical store paths
  # `nix-store --gc` for optimizing the nix store and removing unreferenced and obsolete store paths
  # `nix-collect-garbage -d` for deleting old generations of user profiles
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };


  networking = {
    hostName = "altered";
    hostId = "e3498425";

    useDHCP = lib.mkDefault true;

    networkmanager = {
      enable = true; 
      wifi.backend = "iwd";
    };

    wireless.iwd = {
      enable = true;
      settings = {
        IPv4 = {
	  Enabled = true;
	};
        IPv6 = {
          Enabled = true;
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };

  time.timeZone = "Europe/London";

  systemd.sleep.settings.Sleep = {
    MemorySleepMode = "deep";
  };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.fwupd.enable = true;


  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.users.al = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "dialout" "networkmanager" "docker" "audio" "adbusers" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
     ];
     shell = pkgs.zsh;
  };

  # programs.firefox.enable = true;
  programs = {
    firefox.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withRuby = false;
      withPython3 = true;
    };

    direnv.enable = true;
    dconf.enable = true;
    ssh.startAgent = true;
    
    #sway.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true; # recommended for most users
      xwayland.enable = true; # Xwayland can be disabled.
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
      };
    };

    # For running dynamically linked binaries
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      # Add missing libraries here, e.g.:
      # stdenv.cc.cc
      # openssl
      # glib

      # For OGP_G100_Tool (export limit device for battery)
      libxcb
      libz
    ];
  };
    
  fonts.packages = with pkgs; [
   liberation_ttf
   nerd-fonts.envy-code-r
   roboto-mono
   font-awesome
  ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    brave

    usbutils
    alsa-utils
    mesa

    brightnessctl
    playerctl
    wofi
    pavucontrol
    mako
    notify-desktop
    libnotify

    tuigreet
    hyprlock
    hypridle
    hyprmon
    hyprviz
    hyprkeys
    hyprnotify
    hyprpaper
    hyprshot
    hyprsunset
    hyprls
    hyprpolkitagent

    impala
    wl-clipboard
    sassc

    alacritty
    brave
    btop
    chromium
    clang    
    cmake
    coreutils
    curl
    delta
    #docker
    file
    fuzzel
    fzf
    gcc
    gh
    gimp
    git
    gnumake
    go
    golangci-lint
    gopls
    htop
    iperf3
    ispell
    jujutsu
    killall
    kitty
    kstars
    lsof
    nmap
    nix-search
    nmon
    obsidian
    oh-my-zsh
    ollama
    opencode
    picocom
    signal-desktop
    sqlite
    starship
    stellarium
    sway
    s-tui
    termshark
    tmux
    tree
    waybar
    wezterm
    wget
    neovim

    mplayer
    vlc

    unzip
    unrar
    p7zip

    wineWow64Packages.stable
    wineWow64Packages.waylandFull
    wineWow64Packages.fonts
    winetricks

    # Android
    #adb
    scrcpy

    # 3d printing
    orca-slicer

    lean4
    rocq-core_9_3
    rocqPackages.bignums
    rocqPackages.coq-lsp
    rocqPackages.coqutil
    # rocqPackages.Extlib
    rocqPackages.stdlib
    rocqPackages.stdpp
    rocqPackages.ITree
    rocqPackages.wasmcert
  ];

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: with pkgs; {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  services.hypridle.enable = true;

  services = {
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    dbus.enable = true;
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 85;
	RESTORE_THRESHOLDS_ON_BAT=1;
	TPSMAPI_ENABLE=1;

      };
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

