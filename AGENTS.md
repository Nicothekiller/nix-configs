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
  home/                     # Home Manager feature modules (kitty, starship, fastfetch, opencode)
  terminal/                 # Shell environment (bash, zsh, nushell, aliases, integrations, env)
  overlays.nix              # Shared nixpkgs overlays (flatpak patch, packet tracer)
  patches/                  # Local patches (flatpak fonts/icons fix)
  boot.nix                  # Bootloader and kernel (systemd-boot, explicit LTS kernel)
  cli-tools.nix             # CLI and development packages
  applications.nix          # Desktop applications
  desktop-theme/            # GTK, Qt, cursor, and theme packages
  file-manager/             # Dolphin, KIO, MIME, and filesystem helpers
  desktop-services.nix      # Flatpak and KDE Connect
  desktop-services-system.nix # Bluetooth, PolKit, UDisks2, UPower, thermald
  fonts.nix                 # System fonts
  gaming.nix                # Steam and Proton-GE
  hyprland.nix              # Hyprland, Noctalia, portals, and user config
  audio.nix                 # PipeWire and audio services
  locale.nix                # Timezone, locale, and keymaps
  network.nix               # NetworkManager, firewalld (nftables backend), DNS
  nix.nix                   # Nix settings, nix-ld, nh cleanup
  printing.nix              # CUPS and printer drivers
  ssh.nix                   # OpenSSH (port restricted via firewalld home zone)
  tailscale.nix             # Tailscale (manual `tailscale up`, no auth key in repo)
  users.nix                 # User accounts and groups (password set imperatively at install)
  secrets.nix               # Keyring/secret-service integration (no secret values)
  system-state.nix          # system.stateVersion (25.11; home.stateVersion is 26.05)
  virtualisation.nix        # Docker and Compose tools
  ai-course-deps.nix        # AI course packages (ollama, jupyter)
  redes-course-deps.nix     # Networks course packages (containerlab, wireshark, packet tracer)
packages/                   # Local package definitions
  cisco-packet-tracer.nix   # Cisco Packet Tracer from a local .deb (see design notes)
hosts/                      # Host-specific NixOS modules
  nic-on-nixosbtw/          # Intel host using ext4
    hardware-configuration.nix # Auto-generated hardware detection (do not edit)
    local-configuration.nix # Intel VA-API settings
  nic-on-nixosbtw2/         # Intel host with NVIDIA dGPU using btrfs
    hardware-configuration.nix # Auto-generated hardware detection (do not edit)
    local-configuration.nix # NVIDIA PRIME offload and filesystem settings
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

### Design Notes (intentional choices -- do not "fix")

- All shared modules apply to every host via `sharedModules` in
  `modules/hosts.nix`. Per-host differences go in
  `hosts/<hostname>/local-configuration.nix` only.
- Firewall: `networking.firewall.enable = false` with
  `services.firewalld.enable = true` plus `networking.nftables.enable = true`
  is intentional. firewalld uses nftables as its backend (it fails to build
  without the nftables option) and provides dynamic interface/network zones
  for laptops, so rules are managed at runtime via `firewall-cmd`, not via
  rebuilds.
- SSH: `services.openssh.enable = true` with no Nix-level hardening because
  the port is only open in the firewalld home zone. Do not add
  `openFirewall` (it targets `networking.firewall`, which is disabled).
- Users: `users.users.nic` has no declarative password. A temporary
  `initialPassword` is added at install time and removed afterwards.
- Packet Tracer: `flake.nix` uses an absolute
  `path:/home/nic/Downloads/...deb` input on purpose. Cisco requires an
  account to download it, there is nowhere to upload it, the version is
  frozen at 9.0.1, and flake inputs evaluate without `--impure` (unlike a
  git-ignored relative path, which Nix skips unless `git add`-ed).
- Flatpak: `modules/overlays.nix` swaps in a local
  `modules/patches/fix-fonts-icons.patch` by basename. The upstream PR has
  sat unreviewed for months, so the overlay stays and fails loudly (via
  `throw`) if nixpkgs renames or merges the patch.
- Steam: do not manually set `hardware.graphics.enable32Bit` or
  `hardware.steam-hardware.enable`; the `steam` module enables both
  automatically.
- btw2 NVIDIA: `GBM_BACKEND=nvidia-drm`, `WLR_NO_HARDWARE_CURSORS=1`, and
  `LIBVA_DRIVER_NAME=iHD` without `nvidia-vaapi-driver` are intentional --
  HDMI is wired to the dGPU and Intel handles decode. Bus IDs are
  host-specific by design and stable across reboots. The default
  `hardware.nvidia.package` tracks the stable driver, not latest.
- Tailscale: declarative `authKeyFile`, `useRoutingFeatures`, and
  `openFirewall` are intentionally unused (no secrets in repo, no routing
  features, `openFirewall` targets the disabled NixOS firewall). Run
  `tailscale up` manually.
- Versions: `system.stateVersion = "25.11"` with
  `home.stateVersion = "26.05"` is intentional (Home Manager adopted later).
  Never bump either to "fix" the skew on existing installs.
- Kernel: `boot.kernelPackages = pkgs.linuxPackages` is explicit on purpose
  so it is easy to change later.
- Nix GC: the commented-out `nix.gc` block in `modules/nix.nix` documents
  the previous setup and stays until `programs.nh.clean` proves out
  long-term. Extra `substituters`/`trusted-public-keys` append the official
  `cache.nixos.org`; they do not replace it.
- `hardware-configuration.nix` files are auto-generated; `fmask`/`dmask`
  differences between hosts come from `nixos-generate-config`, do not edit.

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
