{
  lib,
  inputs,
  pkgs,
  ...
}:
inputs.devenv.lib.mkShell {
  inherit inputs pkgs;
  modules = [
    {
      packages = with pkgs; [
        zola
      ];

      languages.nix.enable = true;

      pre-commit.hooks = {
        editorconfig-checker.enable = false;
        end-of-file-fixer.enable = true;
        trim-trailing-whitespace.enable = true;

        lychee.enable = true;
        markdownlint.enable = true;
        mkdocs-linkcheck.enable = true;

        alejandra.enable = true;
        deadnix = {
          enable = true;
          args = ["--edit"];
        };
        statix = {
          enable = true;
          args = ["fix" "-i" ".direnv"];
        };
      };

      cachix.enable = false;
    }
  ];
}
