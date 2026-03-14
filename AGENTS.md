# AGENTS.md

This is a NixOS system configuration repository using Nix Flakes. It defines
reproducible NixOS installations for multiple x86_64-linux hosts. The entire
codebase is written in the Nix expression language.

## Repository Structure

```
flake.nix                   # Flake entry point: inputs (nixpkgs 25.11) and host definitions
flake.lock                  # Pinned dependency versions
configuration.nix           # Shared top-level config, imports all modules
modules/                    # Single-concern shared modules
  boot.nix                  #   Bootloader (systemd-boot) and kernel
  locale.nix                #   Timezone, locale, keymap
  users.nix                 #   User accounts and groups
  packages.nix              #   System-wide packages and fonts
  plasma.nix                #   KDE Plasma 6 desktop, SDDM, Flatpak
  network.nix               #   NetworkManager, firewall, DNS
  services.nix              #   SSH, Bluetooth
  virtualisation.nix        #   Docker
  nix.nix                   #   Nix settings (unfree, flakes, GC, nix-ld)
hosts/                      # Per-host overrides
  nic-on-nixosbtw/          #   Host 1 (Intel, ext4, no discrete GPU)
    hardware-configuration.nix
    local-configuration.nix
  nic-on-nixosbtw2/         #   Host 2 (Intel, btrfs, NVIDIA GPU)
    hardware-configuration.nix
    local-configuration.nix
```

### Architecture

Each host is composed of three layers in `flake.nix`:
1. `configuration.nix` -- shared base (imports all `modules/*`)
2. `hosts/<hostname>/hardware-configuration.nix` -- auto-generated hardware detection
3. `hosts/<hostname>/local-configuration.nix` -- manual host-specific overrides

## Build / Rebuild Commands

There is no Makefile or task runner. All operations use `nixos-rebuild` and `nix`.

```bash
# Build and activate config for a specific host (requires sudo)
sudo nixos-rebuild switch --flake .#nic-on-nixosbtw
sudo nixos-rebuild switch --flake .#nic-on-nixosbtw2

# Build and activate without adding a boot entry
sudo nixos-rebuild test --flake .#<hostname>

# Build only -- no activation, good for checking if config evaluates
sudo nixos-rebuild build --flake .#<hostname>

# Validate flake structure (no custom checks are defined)
nix flake check

# Update flake.lock to latest nixpkgs
nix flake update
```

## Formatting

The project uses `nixfmt` (installed in `modules/packages.nix`). There is no
pre-commit hook or CI pipeline enforcing formatting.

```bash
# Format a single file
nixfmt <file.nix>

# Format all nix files
find . -name '*.nix' -exec nixfmt {} +
```

## Testing / Validation

There are no unit tests or NixOS VM tests defined. Validation is done by
building the configuration:

```bash
# Dry-run build to catch evaluation errors without writing to the store
nix build .#nixosConfigurations.nic-on-nixosbtw.config.system.build.toplevel --dry-run

# Full build (validates the entire config evaluates and all derivations resolve)
sudo nixos-rebuild build --flake .#<hostname>
```

## Code Style Guidelines

### Language: Nix

All files are `.nix`. No other languages are used. Familiarize yourself with
the NixOS module system before making changes.

### File and Directory Naming

- Files: lowercase, kebab-case for multi-word (`local-configuration.nix`)
- Directories: lowercase, kebab-case (`nic-on-nixosbtw2`)
- One domain concern per module file in `modules/`

### Module Signature

Every hand-written module uses a function signature with `...` and only the
parameters it actually references:

```nix
# Module that uses pkgs
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ git ];
}
```

```nix
# Module that needs no parameters
{ ... }:

{
  boot.loader.systemd-boot.enable = true;
}
```

- Only include parameters (`config`, `pkgs`, `lib`, etc.) if they are used
  in the module body. Do not add unused parameters.
- Always include `...` in the signature to accept extra arguments.
- Host `local-configuration.nix` files may use a bare attrset (no function
  signature) when no parameters are needed.
- `hardware-configuration.nix` files are auto-generated -- do not edit them.

### Indentation and Formatting

- 2 spaces, no tabs.
- One blank line between the function signature and the opening `{`.
- One blank line between logically distinct groups of settings.
- Opening `{` for nested attrsets goes on the same line as the attribute.
- Closing `};` on its own line at the attribute's indentation level.
- Keep lines under 80 characters for hand-written code.

### Attribute Path Style

- Use **flat dotted paths** for 1-2 settings under a parent:
  ```nix
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  ```
- Use **attrset blocks** when setting 3+ related values under the same parent:
  ```nix
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
  ```

### Package Lists

Scope `with pkgs;` inline on the list expression, not at module level:

```nix
environment.systemPackages = with pkgs; [
  git
  neovim
];
```

For sub-namespaces: `with pkgs.kdePackages; [ ... ];`

Long lists: one item per line, alphabetical order where practical.
Short lists: inline on one line (`[ "xhci_pci" "ahci" "nvme" ]`).

### Imports

- Use relative paths in `imports` lists: `./modules/boot.nix`
- Hardware configs use `modulesPath` string concatenation for nixpkgs internals

### Comments

- Use `#` with a single space after: `# This is a comment`
- Place comments on the line above the code they describe
- Keep commented-out code as documentation for disabled options
- No multi-line `/* */` comments in this codebase

### Error Handling

This is a purely declarative configuration -- no explicit error handling
(`assert`, `throw`, `tryEval`). Errors are caught at `nixos-rebuild` evaluation
time. If you need conditional configuration, use `lib.mkIf`.

### Boolean Options

Use `.enable = true;` / `.enable = false;` for service toggles. This is the
standard NixOS pattern.

### Adding a New Module

1. Create `modules/<name>.nix` with the standard signature
2. Add `./modules/<name>.nix` to the imports list in `configuration.nix`
3. Keep it single-concern

### Adding a New Host

1. Create `hosts/<hostname>/` directory
2. Generate `hardware-configuration.nix` with `nixos-generate-config`
3. Create `local-configuration.nix` with host-specific overrides (at minimum: `networking.hostName`)
4. Add a new `nixosConfigurations.<hostname>` entry in `flake.nix`

## Git Conventions

- Commit messages follow **Conventional Commits**: `feat:`, `chore:`, etc.
- Lowercase, imperative descriptions, no trailing period
- Examples: `feat: add docker`, `chore: update flake`, `feat: modularize nix configs`
- Linear history on `master` branch (no feature branches observed)
