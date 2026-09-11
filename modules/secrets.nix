{ ... }:

{
  flake.modules.nixos.secrets = {
    # Secret Service provider for Noctalia encrypted storage
    # (clipboard history, calendar cache/credentials) and NM secrets.
    # D-Bus activates the daemon on demand; Noctalia reopens storage
    # automatically when org.freedesktop.secrets appears.
    services.gnome.gnome-keyring.enable = true;

    # Auto-unlock the Login keyring with the password typed at the
    # noctalia-greeter. greetd has its own PAM service (it cannot reuse
    # the login stack for this, see nixpkgs#357201).
    security.pam.services.greetd.enableGnomeKeyring = true;

    # GUI to inspect/manage the keyring (Passwords and Keys).
    programs.seahorse.enable = true;
  };
}
