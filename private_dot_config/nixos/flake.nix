{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ngit = {
      url = "git+https://ngit.dev/ngit.git?ref=stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    trashguard.url = "git+https://gitnostr.com/npub1nsg605enzd74yguz49gseh8ummrz5jl6hrwdxxdcj2rlt7vjm4hq69q0hj/trashguard.git?ref=main";
  };

  outputs = { self, nixpkgs, ngit, trashguard }: {
    nixosConfigurations.mynixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit ngit;
        inherit trashguard;
      };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
