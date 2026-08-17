{ ... }:
{
  flake.modules.nixos.ai-course-deps = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      ollama
      jupyter
    ];
  };
}
