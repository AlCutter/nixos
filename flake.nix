{
  description = "Al's NixOS flake";

  inputs = {
    nixpkgs = {
      #url = "github:NixOS/nixpkgs/nixos-25.11";
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    agypkg = {
      url = "./pkgs/agy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, agypkg, home-manager, ... }: {
    nixosConfigurations = {
      Gadget = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./host/gadget
          {
            environment.systemPackages = [
              agypkg.packages.x86_64-linux.default
            ];
          }
        ];
      };
      dangernix = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./host/utm
#          home-manager.nixosModules.home-manager
#          {
#            home-manager.useGlobalPkgs = true;
#            home-manager.users.al = import ./home/al;
#          }
        ];
      };
    };
  };
}
