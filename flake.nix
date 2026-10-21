{
  description = "Al's NixOS flake";

  nixConfig = {
    # override the default substituters
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agypkg = {
      url = "./pkgs/agy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode-v2.url = "github:aijorgenson/opencode-v2-cli-nixos";
  };

  outputs = inputs@{ nixpkgs, agypkg, opencode-v2, home-manager, ... }: {
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
        specialArgs = { inherit nixpkgs; inputs = inputs; };
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
