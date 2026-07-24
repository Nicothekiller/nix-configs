# AGENTS.md

This is a NixOS system configuration repository using Nix Flakes. It defines
reproducible NixOS installations for multiple x86_64-linux hosts. The entire
codebase is written in the Nix expression language.

## Repository Structure

```
flake.nix                   # Flake inputs and flake-parts entry point
flake.lock                  # Pinned dependency versions
modules/                    # Auto-imported flake-parts modules
  hosts.nix                 # NixOS outputs and host composition
  home-manager.nix          # Home Manager integration and user base
  overlays.nix              # Shared nixpkgs overlays
  boot.nix                  # Bootloader and kernel
  cli-tools.nix             # CLI and development packages
  applications.nix          # Desktop applications
  desktop-theme/            # GTK, Qt, cursor, and theme packages
  file-manager/             # Dolphin, KIO, MIME, and filesystem helpers
  terminal/                 # Shell environment and shell integrations
  desktop-services.nix      # Flatpak and KDE Connect
  desktop-services-system.nix # Bluetooth, PolKit, UDisks2, UPower
  fonts.nix                 # System fonts
  gaming.nix                # Steam and Proton-GE
  hyprland.nix              # Hyprland, DMS, portals, and user config
  locale.nix                # Timezone, locale, and keymaps
  network.nix               # NetworkManager, firewalld, DNS
  nix.nix                   # Nix settings and nix-ld
  printing.nix              # CUPS and printer drivers
  ssh.nix                   # OpenSSH
  tailscale.nix             # Tailscale
  users.nix                 # User accounts and groups
  virtualisation.nix        # Podman and Compose tools
hosts/                      # Host-specific NixOS modules
  nic-on-nixosbtw/          # Intel host using ext4
    hardware-configuration.nix # Auto-generated hardware detection
    local-configuration.nix # Intel VA-API settings
  nic-on-nixosbtw2/         # Intel host with NVIDIA dGPU using btrfs
    hardware-configuration.nix # Auto-generated hardware detection
    local-configuration.nix # NVIDIA and filesystem settings
dotfiles/                   # Out-of-store application configuration
```

### Architecture

This repository uses the dendritic pattern with `flake-parts` and
`import-tree`:

- Every `.nix` file under `modules/` is automatically imported as a
  flake-parts module.
- Shared features publish NixOS modules through
  `flake.modules.nixos.<feature>` and Home Manager modules through
  `flake.modules.homeManager.<feature>`.
- Host definitions include all shared NixOS modules automatically.
- The Home Manager base module includes all shared Home Manager modules
  automatically.
- Files under `hosts/<hostname>/` are ordinary NixOS modules and contain only
  hardware configuration or host-specific overrides.

There is intentionally no shared `configuration.nix`, package aggregator, or
manual module import list. Add shared features under `modules/`; add
host-specific settings under the corresponding `hosts/` directory.

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

# Validate flake structure and NixOS configurations
nix flake check path:.

# Update flake.lock to latest inputs
nix flake update
```

## Formatting

The project uses `nixfmt` (installed in `modules/cli-tools.nix`). There is no
pre-commit hook or CI pipeline enforcing formatting.

```bash
# Format a single file
nixfmt <file.nix>

# Format all nix files
find . -name '*.nix' -exec nixfmt {} +
```

## Testing / Validation

There are no unit tests or automated NixOS VM tests defined. Manual VM testing
is useful for activation and desktop behavior; evaluation is validated by
building the configuration:

```bash
# Dry-run build to catch evaluation errors without writing to the store
nix build path:.#nixosConfigurations.nic-on-nixosbtw.config.system.build.toplevel --dry-run

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

- Shared modules under `modules/` are auto-imported; do not add manual import
  lists for them.
- Host definitions in `modules/hosts.nix` explicitly reference the matching
  hardware and local configuration files under `hosts/`.
- Hardware configs use `modulesPath` string concatenation for nixpkgs internals.

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

1. Create a focused `.nix` file under `modules/`.
2. Publish the feature as `flake.modules.nixos.<feature>`,
   `flake.modules.homeManager.<feature>`, or both.
3. Keep each file focused on one concern. Multiple files may contribute to the
   same feature name when a feature needs to be split by implementation detail.
4. Do not add the file to an import list; `import-tree` discovers it
   automatically.

### Adding a New Host

1. Create `hosts/<hostname>/` directory
2. Generate `hardware-configuration.nix` with `nixos-generate-config`
3. Create `local-configuration.nix` with host-specific overrides (at minimum: `networking.hostName`)
4. Add a new `nixosConfigurations.<hostname>` entry in `modules/hosts.nix`

## Git Conventions

- Commit messages follow **Conventional Commits**: `feat:`, `chore:`, etc.
- Lowercase, imperative descriptions, no trailing period
- Examples: `feat: add docker`, `chore: update flake`, `feat: modularize nix configs`
- Linear history on `master` branch (no feature branches observed)
