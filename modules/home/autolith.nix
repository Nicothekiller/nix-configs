{ ... }:

{
  flake.modules.homeManager.autolith = { pkgs, ... }: {
    home.packages = with pkgs; [
      ast-grep
      delve
      go
      gopls
      jq
      llvmPackages.clang-tools
      llvmPackages.lldb
      python3Packages.debugpy
      ty
      yq-go
    ];

    xdg.configFile."autolith/lsp.sexp".text = ''
      (:version 1
       :servers ((:name "gopls"
                  :command "${pkgs.gopls}/bin/gopls"
                  :extensions (".go")
                  :language-id "go"
                  :root-markers ("go.work" "go.mod" ".git"))
                 (:name "rust-analyzer"
                  :command "rust-analyzer"
                  :extensions (".rs")
                  :language-id "rust"
                  :root-markers ("Cargo.toml" ".git"))
                 (:name "clangd-c"
                  :command "${pkgs.llvmPackages.clang-tools}/bin/clangd"
                  :extensions (".c" ".h")
                  :language-id "c"
                  :root-markers ("compile_commands.json" ".git"))
                 (:name "clangd-cpp"
                  :command "${pkgs.llvmPackages.clang-tools}/bin/clangd"
                  :extensions (".cc" ".cpp" ".cxx" ".hh" ".hpp" ".hxx")
                  :language-id "cpp"
                  :root-markers ("compile_commands.json" ".git"))
                 (:name "ty"
                  :command "${pkgs.ty}/bin/ty"
                  :arguments ("server")
                  :extensions (".py" ".pyi")
                  :language-id "python"
                  :root-markers ("pyproject.toml" "ty.toml" ".git"))))
    '';

    xdg.configFile."autolith/init.lisp".text = ''
      (asdf:load-system "autolith/structural")
      (setf autolith:*structural-program* "${pkgs.ast-grep}/bin/ast-grep")

      (asdf:load-system "autolith/debug")
      (setf autolith:*debug-adapter-program*
            "${pkgs.llvmPackages.lldb}/bin/lldb-dap")

      (define-context-contributor nic-agent-instructions (request)
        (declare (ignore request))
        (make-context-contribution
         :identifier "nic-agent-instructions"
         :priority 100
         :instruction
         "Avoid Python unless it is necessary or the best solution. Use jq and yq to parse JSON and YAML. Never commit or perform destructive operations without an explicit user request or approval."))
      (register-openai-compatible-provider
       :name                         "usfq"
       :description                  "USFQ models"
       :endpoint                     "https://ai.usfq.edu.ec/api/agents/llm/main/v1/chat/completions"
       :models-endpoint              "https://ai.usfq.edu.ec/api/agents/llm/main/v1/models"
       :api-key-environment-variable "USFQ_API_KEY"
       :models '((:name "zai-org/GLM-5.3-Flash"
                  :description "GLM 5.3 Flash"
                  :context-window 262144)))
    '';
  };
}
