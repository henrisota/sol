{pkgs, ...}: let
  outputDirectory = "public";
in {
  packages = with pkgs; [
    zola
  ];

  scripts = {
    build.exec = ''
      zola build --output-dir ${outputDirectory}
    '';
    check.exec = ''
      zola check
    '';
    clean.exec = ''
      rm -rf ${outputDirectory}
    '';
    serve.exec = ''
      zola serve --interface 0.0.0.0 --port 2000 --base-url 0.0.0.0 --open
    '';
  };

  languages.nix.enable = true;

  git-hooks.hooks = {
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
