{
  description = "Al's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

	outputs = { nixpkgs, home-manager, ... }: {
		nixosConfigurations = {
			gadget = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./host/gadget
#					home-manager.nixosModules.home-manager
#					{
#						home-manager.useGlobalPkgs = true;
#						home-manager.users.al = import ./home/al;
#					}
				];
			};
			dangernix = nixpkgs.lib.nixosSystem {
				system = "aarch64-linux";
				modules = [
					./host/utm
#					home-manager.nixosModules.home-manager
#					{
#						home-manager.useGlobalPkgs = true;
#						home-manager.users.al = import ./home/al;
#					}
				];
			};
		};
	};
}
