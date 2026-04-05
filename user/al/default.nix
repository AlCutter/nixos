{ config, lib, pkgs, ...}:

{
  users.users.al = {
     isNormalUser = true;
     extraGroups = [ "wheel" "video" "dialout" "networkmanager" "docker" "audio" ];
     packages = with pkgs; [
     ];
     shell = pkgs.zsh;
  };

}
