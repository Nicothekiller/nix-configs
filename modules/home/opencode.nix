{ pkgs, ... }:

{
  programs.opencode = {
    enable = true;
    package = pkgs.unstable.opencode;
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      permission = {
        bash = "ask";
        edit = "ask";
        webfetch = "ask";
      };
      plugin = [ "opencode-gemini-auth@latest" ];

      provider."USFQ" = {
        name = "USFQ models";
        options.baseURL = "https://ai.usfq.edu.ec/api/ai/main/v1";
        models."deepseek-ai/DeepSeek-V4-Flash" = {
          name = "DeepSeek V4 Flash";
          limit = {
            context = 1048576;
            output = 384000;
          };
        };
      };
    };
  };
}
