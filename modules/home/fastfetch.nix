{ pkgs, ... }:

let
  escape = builtins.fromJSON ''"\u001b"'';
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "builtin";
      };
      display = {
        separator = "   ";
        color = "cyan";
      };
      modules = [
        {
          type = "custom";
          format = "┌─────────── ${escape}[1mHardware Information${escape}[0m ───────────┐";
        }
        {
          type = "host";
          key = "  󰌢";
        }
        {
          type = "cpu";
          key = "  ";
        }
        {
          type = "gpu";
          detectionMethod = "pci";
          key = "  ";
        }
        {
          type = "display";
          key = "  󱄄";
        }
        {
          type = "memory";
          key = "  ";
        }
        {
          type = "custom";
          format = "├─────────── ${escape}[1mSoftware Information${escape}[0m ───────────┤";
        }
        {
          type = "os";
          key = "  ";
        }
        {
          type = "kernel";
          key = "  ";
          format = "{1} {2}";
        }
        {
          type = "wm";
          key = "  ";
        }
        {
          type = "shell";
          key = "  ";
        }
        {
          type = "packages";
          key = "  󰏖";
        }
        {
          type = "custom";
          format = "|──────────────${escape}[1mUptime / Age${escape}[0m──────────────────|";
        }
        {
          type = "command";
          key = "  OS Age ";
          keyColor = "magenta";
          text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
        }
        {
          type = "uptime";
          key = "  Uptime ";
          keyColor = "magenta";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────┘";
        }
        {
          type = "colors";
          paddingLeft = 2;
          symbol = "circle";
        }
      ];
    };
  };
}
