{
  description = "Al's NixOS flake";

  inputs = {
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    nixpkgs = {
      #url = "github:NixOS/nixpkgs/nixos-25.11";
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    agypkg = {
      url = "./pkgs/agy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, agypkg, home-manager, ... }: {
    nixosConfigurations = {
      altered = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit nixpkgs; inputs = inputs; };
        modules = [
          ./host/altered
        ];
      };
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
