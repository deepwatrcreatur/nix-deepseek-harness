{
  description = "Nix package and flake for DeepSeek Harness (@deepseek-ai/dsh)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        
        deepseek-harness = pkgs.buildNpmPackage {
          pname = "deepseek-harness";
          version = "0.1.2-rc.1";

          src = ./.;

          npmDepsHash = "sha256-t0y6yve5oAjA+vp664JZTl0wQnj+O7epyT1tY/d7qdo=";

          dontNpmBuild = true;

          nativeBuildInputs = [ pkgs.makeWrapper ];

          postInstall = ''
            mkdir -p $out/bin
            cat <<'EOF' > $out/bin/dsh
#!/usr/bin/env bash
set -e

if [ -z "$DEEPSEEK_API_KEY" ]; then
  for secret_file in \
    "$HOME/.local/share/agenix-user-secrets/deepseek-api-key" \
    "/run/agenix/deepseek-api-key" \
    "/var/lib/roundtable-secrets/deepseek-api-key"; do
    if [ -f "$secret_file" ]; then
      export DEEPSEEK_API_KEY="$(tr -d '\r\n' < "$secret_file")"
      break
    fi
  done
fi

if [ "$#" -eq 0 ]; then
  echo "DeepSeek Harness CLI (dsh)"
  echo ""
  echo "Usage examples:"
  echo "  dsh --profile headless \"Your prompt here\"   (headless mode)"
  echo "  dsh --profile tui                          (TUI mode)"
  echo "  dsh web                                    (web interface)"
  echo ""
  exec @node@ "@binJs@" --help
fi

exec @node@ "@binJs@" "$@"
EOF
            substituteInPlace $out/bin/dsh \
              --replace-fail "@node@" "${pkgs.nodejs}/bin/node" \
              --replace-fail "@binJs@" "$out/lib/node_modules/dsh-pkg/node_modules/@deepseek-ai/dsh/lib/bin.js"
            chmod +x $out/bin/dsh
          '';

          meta = with pkgs.lib; {
            description = "DeepSeek Harness CLI (dsh)";
            homepage = "https://github.com/deepseek-ai/deepseek-harness";
            license = licenses.mit;
            mainProgram = "dsh";
          };
        };
      in
      {
        packages = {
          default = deepseek-harness;
          deepseek-harness = deepseek-harness;
          dsh = deepseek-harness;
        };

        apps = {
          default = flake-utils.lib.mkApp {
            drv = deepseek-harness;
            exePath = "/bin/dsh";
          };
          dsh = flake-utils.lib.mkApp {
            drv = deepseek-harness;
            exePath = "/bin/dsh";
          };
        };

        overlays.default = final: prev: {
          deepseek-harness = deepseek-harness;
          dsh = deepseek-harness;
        };
      }
    );
}
