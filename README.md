# nyped's dotfiles

## Usage

### Install with nix flakes

```bash
# Update lock
nix flake update

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

## Secrets (SOPS)

Secrets are encrypted with [sops](https://github.com/getsecurity/sops) using age keys derived from each machine's SSH host key.

### Adding a new secret file

```bash
# Get the age public keys for all machines
ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub  # run on each machine

# Add them to .sops.yaml, then encrypt a new file
sops secrets/my-secret
```

No private key access needed — encryption only requires the public keys from `.sops.yaml`.

### Rotating keys (e.g. after reinstalling a machine)

1. Get the new machine's age public key:
   ```bash
   ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
   ```
2. Update the corresponding entry in `.sops.yaml`.
3. Re-encrypt all secret files:
   ```bash
   # Requires the age private key of any current recipient (needs root for the SSH host key)
   PRIVATE_AGE_KEY=$(sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key)
   echo y | SOPS_AGE_KEY="$PRIVATE_AGE_KEY" sops updatekeys secrets/my-secret
   ```

> Note: `SOPS_AGE_SSH_PRIVATE_KEY_FILE` does **not** work here because the recipients are
> X25519 age keys (derived via `ssh-to-age`), not native SSH-type age recipients.

## Useful environment variables

- `_IN_WSL` automatically set by `zsh` on WSL
- `_NVIM_NO_AUTOFORMAT`
- `_NVIM_PYTHON_RUFF`
