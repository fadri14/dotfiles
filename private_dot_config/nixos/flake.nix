{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ngit = {
      url = "git+https://ngit.dev/ngit.git?ref=stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ngit }: {
    nixosConfigurations.mynixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit ngit;
      };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
