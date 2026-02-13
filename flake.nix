{
  description = "NixOS configuration for jesperls";

  inputs = {
    # Core
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Kernel
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    # Applications
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    deltatune.url = "github:jesperls/deltatune-linux";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      specialArgs = { inherit inputs; };
    in
    {
      nixosConfigurations = {
        pangu = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/pangu/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
            }
          ];
        };
      };
    };
}
