{pkgs, ...}: let
  outputDirectory = "public";
in {
  packages = with pkgs; [
    git
    zola
  ];

  scripts = {
    build.exec = ''
      zola build --output-dir ${outputDirectory} "$@"
    '';
    check.exec = ''
      zola check
    '';
    clean.exec = ''
      rm -rf ${outputDirectory}
    '';
    deploy.exec = ''
      echo "Configure deployment"

      git config --global url."https://".insteadOf git://
      git config --global url."$GITHUB_SERVER_URL/".insteadOf "git@github.com":
      git config --global --add safe.directory '*'
      git config --global init.defaultBranch main

      cd ${outputDirectory}

      touch .nojekyll

      git init
      git config user.name "GitHub Actions"
      git config user.email "github-actions-bot@users.noreply.github.com"
      git add .

      echo "Deploy"

      git commit -m "Deploy ''${GITHUB_REPOSITORY}"
      git push --force "https://''${GITHUB_ACTOR}:''${GITHUB_TOKEN}@github.com/''${GITHUB_REPOSITORY}.git" main:pages

      echo "Deployed"
    '';
    serve.exec = ''
      zola serve --interface 127.0.0.1 --port 2000 --open
    '';
  };

  languages.nix.enable = true;

  git-hooks.hooks = {
    editorconfig-checker.enable = false;
    end-of-file-fixer.enable = true;
    trim-trailing-whitespace.enable = true;

    lychee.enable = false;
    markdownlint = {
      enable = true;
      settings.configuration = {
        line-length = false;
        no-blanks-blockquote = false;
        single-title = false;
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
