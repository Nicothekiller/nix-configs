{ ... }:

{
  flake.modules.homeManager.terminal = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initContent = ''
        bindkey -v

        # Kitty ssh alias
        [ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list ''' 'm:{a-z}={A-Za-z}'
        zstyle ':completion::complete:*' gain-privileges 1

        setopt CORRECT
        setopt autocd extendedglob nomatch notify
        unsetopt beep

        autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search

        bindkey "^[[A" up-line-or-beginning-search
        bindkey "^[[B" down-line-or-beginning-search

        function mkdirg() {
          mkdir -p "$1"
          cd "$1"
        }

        function gcom() {
          git add .
          git commit -m "$1"
        }

        function lazyg() {
          git add .
          git commit -m "$1"
          git push
        }

        function krn(){
          kitty @ set-tab-title "$1"
        }
      '';
    };
  };
}
