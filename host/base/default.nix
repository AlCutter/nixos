# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ nixpkgs, inputs, config, lib, pkgs, ... }:
{
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
  nix.gc = lib.mkDefault({
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  });


  time.timeZone = "Europe/London";

  services.fwupd.enable = true;
  services.openssh.enable = true;

  users.users.al = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "dialout" "networkmanager" "docker" "audio" "adbusers" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
     ];
     shell = lib.mkDefault(pkgs.zsh);
  };

  programs = {
    neovim = lib.mkDefault({
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    });

    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    btop
    curl
    fzf
    killall
    tmux
    wget
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  security = {
    rtkit.enable = true;
    pki.caCertificateBlacklist = [
     "Comodo AAA Services root"
     "emSign ECC Root CA - G3"
    ];
  };
}

