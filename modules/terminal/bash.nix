{ ... }:

{
  flake.modules.homeManager.terminal = {
    programs.bash = {
      enable = true;

      initExtra = ''
        shopt -s checkwinsize
        shopt -s histappend

        if [[ $- == *i* ]]; then
          bind "set bell-style visible"
          stty -ixon
          bind "set completion-ignore-case on"
          bind "set show-all-if-ambiguous On"
          bind '"\C-f":"zi\n"'
        fi

        export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

        extract() {
          for archive in "$@"; do
            if [ -f "$archive" ]; then
              case $archive in
              *.tar.bz2) tar xvjf $archive ;;
              *.tar.gz) tar xvzf $archive ;;
              *.bz2) bunzip2 $archive ;;
              *.rar) rar x $archive ;;
              *.gz) gunzip $archive ;;
              *.tar) tar xvf $archive ;;
              *.tbz2) tar xvjf $archive ;;
              *.tgz) tar xvzf $archive ;;
              *.zip) unzip $archive ;;
              *.Z) uncompress $archive ;;
              *.7z) 7z x $archive ;;
              *) echo "don't know how to extract '$archive'..." ;;
              esac
            else
              echo "'$archive' is not a valid file!"
            fi
          done
        }

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
      '';
    };
  };
}
