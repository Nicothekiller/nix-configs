{ ... }:

{
  flake.modules.homeManager.autolith = {
    xdg.configFile."autolith/init.lisp".text = ''
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
