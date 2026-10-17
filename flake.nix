{
  description = "Al's NixOS flake";

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
