{
  description = "Flake for cceckman's home directory";

  # Pick up the nixpkgs dependency from homelab - which should match our system
  inputs.homelab = "github.com:cceckman/homelab";
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = inputs.homelab.inputs.nixos;
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    homeConfigurations.cceckman = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs;
      modules = [];
    };
  };
}
