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
    sync.exec = ''
      function error_exit() {
        echo "ERROR: $1" >&2
        exit "''${2:-1}"
      }

      function extract() {
        local file="$1"
        local field="$2"
        grep -m 1 "^$field =" "$file" | sed -e "s/$field = //" -e 's/ *$//'
      }

      function update_file() {
        local file="$1"
        local date="$2"

        awk -v updated_date="$date" '
          BEGIN { FS = OFS = " = "; updated_found = 0 }
          {
            # If "date" field is found, insert "updated" field if not already present
            if (/^date =/ && !updated_found) {
              print $0
              getline
              if (!/^updated =/) {
                print "updated" OFS updated_date
              }
              updated_found = 1
            }
            # If "updated" field exists, update its value
            if (/^updated =/) {
              $2 = updated_date
              updated_found = 1
            }
            print
          }
        ' "$file" > "''${file}.tmp" && mv "''${file}.tmp" "$file" || error_exit "Failed to update $file"
      }

      # Loop through files
      for file in "$@"; do
        echo "Processing $file"

        # Get the last modified date from the filesystem
        system_date=$(date -r "$file" +'%Y-%m-%d') || error_exit "Failed to get system date"

        # Extract the "date" and "updated" fields from the file
        file_date=$(extract "$file" "date")
        file_updated_date=$(extract "$file" "updated")

        # Skip the file if either "date" or "updated" matches the system date
        if [[ "$file_date" == "$system_date" ]] || [[ "$file_updated_date" == "$system_date" ]]; then
          echo "Skipping $file"
          continue
        fi

        echo "Syncing updated date for $file"
        update_file "$file" "$system_date"

        # Stage the changes.
        git add "$file"
      done
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

    sync = {
      enable = true;
      name = "sync-updated-metadata";
      entry = "sync";
      types = ["markdown"];
      language = "system";
      pass_filenames = true;
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
