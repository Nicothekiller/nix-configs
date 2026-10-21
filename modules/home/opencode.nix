{ ... }:

{
  flake.modules.homeManager.opencode = { pkgs, ... }: {
    programs.opencode = {
      enable = true;
      package = pkgs.opencode;

      validateFiles.config = true;

      settings = {
        update = "disable";

        permissions = [
          {
            action = "shell";
            resource = "*";
            effect = "ask";
          }
        ]
        ++
          map
            (cmd: {
              action = "shell";
              resource = "${cmd} *";
              effect = "allow";
            })
            [
              "basename"
              "cal"
              "cat"
              "cmp"
              "column"
              "cut"
              "date"
              "df"
              "diff"
              "dirname"
              "du"
              "echo"
              "fd"
              "file"
              "find"
              "fold"
              "git blame"
              "git diff"
              "git log"
              "git reflog"
              "git shortlog"
              "git show"
              "git status"
              "grep"
              "head"
              "id"
              "less"
              "ls"
              "more"
              "nl"
              "nixos-version"
              "printf"
              "ps"
              "pwd"
              "realpath"
              "rev"
              "rg"
              "sort"
              "stat"
              "tac"
              "tail"
              "tr"
              "tree"
              "uname"
              "uniq"
              "uptime"
              "wc"
              "which"
              "whoami"
            ]
        ++ [
          {
            action = "edit";
            resource = "*";
            effect = "ask";
          }
          {
            action = "webfetch";
            resource = "*";
            effect = "ask";
          }
          {
            action = "external_directory";
            resource = "*";
            effect = "ask";
          }
          {
            action = "external_directory";
            resource = "~/.opencode/*";
            effect = "allow";
          }
          {
            action = "external_directory";
            resource = "/tmp/opencode/*";
            effect = "allow";
          }
        ];

        providers.USFQ = {
          name = "USFQ models";
          package = "@opencode/ai/providers/openai-compatible";
          settings.baseURL = "https://ai.usfq.edu.ec/api/agents/llm/main/v1";
          models."zai-org/GLM-5.3-Flash" = {
            name = "GLM 5.3 Flash";
            capabilities = {
              tools = true;
              input = [
                "text"
                "image"
              ];
              output = [ "text" ];
            };
            limit = {
              context = 262144;
              output = 128000;
            };
          };
        };
      };
    };
  };
}
