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
  };

  outputs = { self, nixpkgs, home-manager, homelab, ... }: {
    homeConfigurations.cceckman = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      stateVersion = homelab.outputs.nixosConfigurations.cromwell-nix.system.stateVersion;
      modules = [];
    };
  };
}
