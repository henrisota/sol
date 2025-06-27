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
    markdownlint = {
      enable = true;
      settings.configuration = {
        line-length = false;
      };
    };
    mkdocs-linkcheck.enable = false;

    prettier = {
      enable = true;
      settings = {
        allow-parens = "always";
        check = false;
        embedded-language-formatting = "auto";
        end-of-line = "lf";
        html-whitespace-sensitivity = "strict";
        print-width = 160;
        prose-wrap = "never";
        no-config = true;
        no-semi = false;
        trailing-comma = "all";
        use-tabs = false;
        write = true;
      };
    };

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
