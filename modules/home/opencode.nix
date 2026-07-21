{ pkgs, ... }:

{
  programs.opencode = {
    enable = true;
    package = pkgs.unstable.opencode;
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      permission = {
        bash = {
          "*" = "ask";
          "basename" = "allow";
          "basename *" = "allow";
          "cal" = "allow";
          "cal *" = "allow";
          "cat *" = "allow";
          "cmp" = "allow";
          "cmp *" = "allow";
          "column *" = "allow";
          "cut *" = "allow";
          "date" = "allow";
          "date *" = "allow";
          "df" = "allow";
          "df *" = "allow";
          "diff" = "allow";
          "diff *" = "allow";
          "dirname" = "allow";
          "dirname *" = "allow";
          "du" = "allow";
          "du *" = "allow";
          "echo *" = "allow";
          "fd" = "allow";
          "fd *" = "allow";
          "file" = "allow";
          "file *" = "allow";
          "find" = "allow";
          "find *" = "allow";
          "fold *" = "allow";
          "git blame" = "allow";
          "git blame *" = "allow";
          "git diff" = "allow";
          "git diff *" = "allow";
          "git log" = "allow";
          "git log *" = "allow";
          "git reflog" = "allow";
          "git reflog *" = "allow";
          "git shortlog" = "allow";
          "git shortlog *" = "allow";
          "git show" = "allow";
          "git show *" = "allow";
          "git status" = "allow";
          "git status *" = "allow";
          "grep" = "allow";
          "grep *" = "allow";
          "head" = "allow";
          "head *" = "allow";
          "id" = "allow";
          "id *" = "allow";
          "less" = "allow";
          "less *" = "allow";
          "ls" = "allow";
          "ls *" = "allow";
          "more" = "allow";
          "more *" = "allow";
          "nl *" = "allow";
          "nixos-version" = "allow";
          "nixos-version *" = "allow";
          "printf *" = "allow";
          "ps" = "allow";
          "ps *" = "allow";
          "pwd" = "allow";
          "realpath" = "allow";
          "realpath *" = "allow";
          "rev *" = "allow";
          "rg" = "allow";
          "rg *" = "allow";
          "sort *" = "allow";
          "stat" = "allow";
          "stat *" = "allow";
          "tac *" = "allow";
          "tail" = "allow";
          "tail *" = "allow";
          "tr *" = "allow";
          "tree" = "allow";
          "tree *" = "allow";
          "uname" = "allow";
          "uname *" = "allow";
          "uniq *" = "allow";
          "uptime" = "allow";
          "wc" = "allow";
          "wc *" = "allow";
          "which" = "allow";
          "which *" = "allow";
          "whoami" = "allow";
        };
        edit = "ask";
        webfetch = "ask";
      };

      provider."USFQ" = {
        name = "USFQ models";
        options.baseURL = "https://ai.usfq.edu.ec/api/agents/llm/main/v1";
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
