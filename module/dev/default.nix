{ config, lib, pkgs, ...}:

{
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withPython3 = false;
      withRuby = false;
      
      #package = pkgs.unstable.neovim-unwrapped;
    };

    direnv.enable = true;
    dconf.enable = true;
    ssh.startAgent = true;
    
    #sway.enable = true;
    
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

  environment.systemPackages = with pkgs; [
    btop
    clang    
    cmake
    coreutils
    curl
    delta
    fuzzel
    fzf
    gh
    git
    gnumake
    go
    golangci-lint
    gopls
    htop
    ispell
    jujutsu
    killall
    lsof
    nmon
    markdownlint-cli2
    oh-my-zsh
    picocom
    starship
    termshark
    tmux
    tree
    wget

    zsh-vi-mode
  ];

  nixpkgs.config.allowUnfree = true;

}
