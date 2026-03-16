{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, vscode-server, ... }: {
  nixosConfigurations = {
    nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
          ./configuration.nix
          
          # home-manager settings
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.user = import ./home.nix;
          }

          # vscode-server settings
          vscode-server.nixosModules.default
          ({ config, pkgs, ...}: {
            services.vscode-server.enable = true;
          })
        ];
      };
    }; 
  };
}
