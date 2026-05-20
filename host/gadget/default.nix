## Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ modulesPath, config, lib, pkgs, ... }:
let
/*
  # Pin protoc-gen-go@1.28.1
  # See https://lazamar.co.uk/nix-versions/?package=protoc-gen-go&version=1.28.1&fullName=protoc-gen-go-1.28.1&keyName=protoc-gen-go&revision=8ad5e8132c5dcf977e308e7bf5517cc6cc0bf7d8&channel=nixpkgs-unstable#instructions
  protoc_pkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/8ad5e8132c5dcf977e308e7bf5517cc6cc0bf7d8.tar.gz";
    }) {};
  # Pin protobuf3_20 @ 3.20.1
  # See https://lazamar.co.uk/nix-versions/?package=protobuf&version=3.20.1&fullName=protobuf-3.20.1&keyName=protobuf3_20&revision=c2c0373ae7abf25b7d69b2df05d3ef8014459ea3&channel=nixpkgs-unstable#instructions
  protobuf_pkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/c2c0373ae7abf25b7d69b2df05d3ef8014459ea3.tar.gz";
    }) {};
*/
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ];

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.isContainer = true;
  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  nix = {
    optimise.automatic = true;
    optimise.dates = [ "03:45" ]; # Optional; allows customizing optimisation schedule

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      min-free = ${toString (500 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
      experimental-features = nix-command flakes
    '';

    settings.extra-experimental-features = "nix-command";
  };

  networking.hostName = "GadgetNix"; # Define your hostname.
  networking.nameservers = [ "10.0.20.1" ];

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  virtualisation.docker = {
    enable = true;
    #rootless = {
      #enable = true;
      #setSocketVariable = true;
    #};  
  };


  nixpkgs.config = {
  /*
    packageOverrides = pkgs: with pkgs; {
      protoc_pkgs = import protoc_pkgs {
        config = config.nixpkgs.config;
      };
      protobuf_pkgs = import protobuf_pkgs {
        config = config.nixpkgs.config;
      };
    };
  */
  };

  programs = {
  
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withPython3 = false;
      withRuby = false;
      #package = pkgs.neovim-unwrapped;
    };
    
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
      };
      interactiveShellInit = ''
              source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      '';
    };
  };

  nix.settings.trusted-users = [ "al" ];
  users.users.al = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
    autoSubUidGidRange = false;
    subUidRanges = [
      {
        startUid = 100000;
        count = 15665550;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 15665550;
      }
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.envy-code-r
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    act
    termsvg
    vhs
    ffmpeg
    ttyd
    asciinema_3
    autoconf
    automake
    btop
    busybox
    cargo
    clang    
    cmake
    coreutils
    cosign
    curl
    delta
    difftastic
    docker
    figlet
    fzf
    gcc-arm-embedded
    gcc
    gh
    ghostty
    git
    gnumake
    google-cloud-sdk
    go_1_25
    golangci-lint
    gopls
    hurl
    hugo
    iperf3
    ispell
    jujutsu
    ko
    lsof
    lynx
    nmon
    nodejs_24
    oh-my-zsh
    openssl
    opentofu
    picocom
    /*
    protobuf_pkgs.protobuf3_20
    protoc_pkgs.protoc-gen-go
    */
    qemu_full
    rpl
    rustc
    sqlite
    sqlite-utils
    starship
    sysstat
    termshark
    terraform
    terraform-ls
    terragrunt
    tmux
    tree
    ubootTools
    wezterm
    wget
    zsh-vi-mode
  ];

  nixpkgs.config.allowUnfree = true;


  environment.interactiveShellInit = ''
    alias gs='git status'
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    allowSFTP = false;
    ports = [22];

    # https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67
    settings = {
      LogLevel = "VERBOSE";
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = true;

      KexAlgorithms = [
        "curve25519-sha256@libssh.org"
        "ecdh-sha2-nistp521"
        "ecdh-sha2-nistp384"
        "ecdh-sha2-nistp256"
        "diffie-hellman-group-exchange-sha256"
	"sntrup761x25519-sha512"
	"mlkem768x25519-sha256"
      ];
      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
      ];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
        "hmac-sha2-512"
        "hmac-sha2-256"
        "umac-128@openssh.com"
      ];
    };

    extraConfig = ''
      ClientAliveCountMax 0
      ClientAliveInterval 300

      AllowTcpForwarding local
      AllowAgentForwarding no
      MaxAuthTries 3
      MaxSessions 2
      TCPKeepAlive no
    '';
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

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
  system.stateVersion = "24.05"; # Did you read the comment?

  system.autoUpgrade.enable = true;

  # No DebugFS since we're inside an unprivileged container.
  systemd.mounts = [{
    where = "/sys/kernel/debug";
    enable = false;
  }];

}

