# nix-deepseek-harness

Nix flake package for **DeepSeek Harness** (`@deepseek-ai/dsh` / `dsh` CLI).

## Usage

### Run directly with Flakes
```bash
nix run github:deepwatrcreatur/nix-deepseek-harness -- --help
```

### Run headless query
```bash
DEEPSEEK_API_KEY="your-key" nix run github:deepwatrcreatur/nix-deepseek-harness -- --profile headless "Write a hello world in Rust"
```

### Include in a Flake
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-deepseek-harness.url = "github:deepwatrcreatur/nix-deepseek-harness";
  };

  outputs = { self, nixpkgs, nix-deepseek-harness }: {
    # Access nix-deepseek-harness.packages.${system}.dsh
    # or overlay nix-deepseek-harness.overlays.default
  };
}
```

## License
MIT
