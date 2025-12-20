# nyped's dotfiles

## Usage

### Install with nix flakes

```bash
# Update lock
nix flake lock --update-input home-manager
nix flake lock --update-input nixpkgs

# Update system
sudo nixos-rebuild switch --flake
```

### Manual installation with GNU stow

```bash
# Help me plz
./manage.sh --help

# List target
./manage.sh --list

# Install nvim
./manage.sh --install --target nvim
```

## Useful environment variables

- `_IN_WSL` automatically set by `zsh` on WSL
- `_NVIM_NO_AUTOFORMAT`
- `_NVIM_PYTHON_RUFF`
