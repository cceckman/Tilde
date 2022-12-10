{
  description = "Flake for cceckman's home directory";

  # Pick up the nixpkgs dependency from homelab - which should match our system.
  # From: https://discourse.nixos.org/t/nix-flake-to-aggregate-and-concurrently-update-some-dependencies/10774/6
  inputs = {
    homelab.url = "git+https://github.com/cceckman/homelab.git";
    nixpkgs.follows = "homelab/nixos";
    home-manager = {
      url = "git+https://github.com/nix-community/home-manager.git";
      inputs.nixpkgs.follows = "homelab/nixos";
    };
    ack = {
      url = "github:cceckman/ack/nix";
      inputs.nixpkgs.follows = "homelab/nixos";
    };
  };

  outputs = { self, nixpkgs, home-manager, homelab, ack, ... }: {
    homeConfigurations.cceckman = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ ack.overlay ];
      };
      modules = [
        ./cceckman.nix
      ];
    };
  };
}
