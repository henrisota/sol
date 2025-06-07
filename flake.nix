{
  description = "flak plak";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      package-namespace = "flak";
      channels-config = {
        allowUnfree = true;
      };
      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;
      };
      overlays = with inputs; [
        devenv.overlays.default
      ];
    };
}
