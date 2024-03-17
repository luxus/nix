# Shell configurations via Home-manager.
{ globals, ... }: { config
                  , lib
                  , pkgs
                  , ...
                  }:
with builtins // lib; {
  imports = [
    globals.outputs.homeProfiles.catppuccin
  ];

  programs = {
    # bash
    bash = {
      enable = true;
      enableCompletion = true;
    };

    # bat
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batgrep
        batman
        batpipe
        batwatch
        prettybat
      ];
    };

    # bottom
    bottom = {
      enable = true;
    };

    # btop
    btop = {
      enable = true;
    };

    # eza (exa)
    eza = {
      enable = true;
      # enableAliases = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      icons = true;
      git = true;
    };

    # fzf
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
      defaultCommand = "fd --type f --hidden --follow";
      fileWidgetCommand = "fd --type f --hidden --follow";
      defaultOptions = [ "--extended" ];
    };

    # gh (github-cli)
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      extensions = with pkgs; [
        gh-actions-cache
        gh-cal
        gh-dash
        gh-eco
        gh-markdown-preview
      ];
    };

    # git
    git = {
      enable = true;
      lfs.enable = true;
      delta.enable = true;
      userName = "luxus";
      userEmail = "luxuspur@gmail.com";
      extraConfig = {
        pull.rebase = false;
        push.followTags = true;
        rerere.enabled = true;
        core.fsmonitor = true;
      };
    };

    # gitui
    gitui = {
      enable = true;
    };

    # helix (hx)
    helix = {
      enable = true;
      languages = {
        # the language-server option currently requires helix from the master branch at https://github.com/helix-editor/helix/
        language-server.typescript-language-server = with pkgs.nodePackages; {
          command = "''${typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" "--tsserver-path=''${typescript}/lib/node_modules/typescript/lib" ];
        };
        language =
          map
            (name: {
              name = name;
              auto-format = true;
            }) [ "rust" "python" "nix" ];
      };
      settings = {
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
        };
      };
    };
    direnv = {
      enable = true;
    };
    # atuin
    atuin = {
      # credit: https://github.com/montchr/dotfield/commit/6237fa7cde4b6fc1ba5b28234e5ce0c295c7bff9#diff-e85828e2a1e40863d27b847846b1f592b906fd9fa495f89b52057125bcc992f7
      enable = true;
      settings = {
        auto_sync = true;
        dialect = "us";
        sync_frequency = "10m";
        sync_address = "https://api.atuin.sh";
        search_mode = "fuzzy"; # 'prefix' | 'fulltext' | 'fuzzy'

        ##: options: 'global' (default) | 'host' | 'session' | 'directory'
        filter_mode = "global";
        filter_mode_shell_up_key_binding = "directory";
      };
    };
    # mcfly
    mcfly = {
      enable = false;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      fuzzySearchFactor = 3;
    };

    # starship
    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = false;
      enableFishIntegration = true;
      enableIonIntegration = true;
      enableNushellIntegration = true;
      enableTransience = true;
      settings.format = "$all";
    };

    # tmux
    tmux = {
      enable = false;
    };

    # zellij
    zellij = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = false;
    };
    kitty = {
      enable = true;
      font = {
        name = "Monolisa";
        size = 14.0;
      };
      settings = {
        hide_window_decorations = "titlebar-only";
        font_features = "MonoLisa + frac + zero + ss02 + ss04 + ss07 + ss08 + ss09 + ss18";
        macos_colorspace = "default";
        # macos_traditional_fullscreen = true;
        macos_quit_when_last_window_closed = true;
        background_opacity = "0.9";
        macos_option_as_alt = true;
      };
      theme = "Catppuccin-Mocha";
    };

    # zoxide
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    # zsh
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      autocd = true;
      history = {
        size = 25000;
        expireDuplicatesFirst = true;
        path = "${config.xdg.dataHome}/zsh_history";
        ignoreDups = true;
        ignorePatterns = [ "[bf]g" "z" "&" "ls" "exit" "reset" "clear" "cd" "cd .." "cd.." ];
      };
      loginExtra = ''
        export NEOVIDE_MULTIGRID=true
        export NEOVIDE_FRAME=buttonless
      '';
      # envExtra = builtins.readFile ./zshenv;
      initExtraBeforeCompInit =
        /*
          bash
        */
        ''
          # --- powerlevel10k instant prompt ---
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi

          # --- zsh data directories ---
          zsh_data="''${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
          [ ! -d ''${zsh_data} ] && mkdir -p ''${zsh_data}
          zsh_cache="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
          [ ! -d ''${zsh_cache} ] && mkdir -p ''${zsh_cache}
          zsh_plugins="''${zsh_data}/plugins"
          [ ! -d ''${zsh_plugins} ] && mkdir -p ''${zsh_plugins}

          # --- minimal zsh plugin manager ---
          function zsh_install_missing_plugins() {
            function zcompile-many() { local f; for f; do zcompile -R -- "$f".zwc "$f"; done }
            function clone-plugin() {
              local plugin="$(basename ''${1})"
              echo "Installing ''${plugin}"
              git clone --quiet --depth=1 "''${1}.git" ''${zsh_plugins}/''${plugin} > /dev/null
            }
            # clone plugins, add more plugin downloads here with optional compilation calls to improve startup
            if [[ ! -e ''${zsh_plugins}/zsh-completions ]]; then
              clone-plugin "https://github.com/zsh-users/zsh-completions"
            fi
            if [[ ! -e ''${zsh_plugins}/fzf-tab ]]; then
              clone-plugin "https://github.com/Aloxaf/fzf-tab"
              zcompile-many ''${zsh_plugins}/fzf-tab/*.zsh
            fi
            if [[ ! -e ''${zsh_plugins}/zsh-syntax-highlighting ]]; then
              clone-plugin "https://github.com/zsh-users/zsh-syntax-highlighting"
              zcompile-many ''${zsh_plugins}/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
            fi
            if [[ ! -e ''${zsh_plugins}/zsh-autosuggestions ]]; then
              clone-plugin "https://github.com/zsh-users/zsh-autosuggestions"
              zcompile-many ''${zsh_plugins}/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
            fi
            if [[ ! -e ''${zsh_plugins}/powerlevel10k ]]; then
              clone-plugin "https://github.com/romkatv/powerlevel10k"
              make -C ''${zsh_plugins}/powerlevel10k pkg > /dev/null || echo "Error building powerlevel10k"
            fi
            unfunction zcompile-many clone-plugin
          }
          # --- zsh plugin manager updater ---
          function zsh_update_plugins() { rm -rf ''${zsh_plugins}/**; zsh_install_missing_plugins }

          # --- install zsh plugins ---
          zsh_install_missing_plugins

          # --- configure zsh options ---
          setopt bash_rematch
          setopt correct
          setopt hist_verify
          setopt inc_append_history
          setopt interactivecomments
          export KEYTIMEOUT=10

          # --- completion ---
          autoload -Uz compinit
          comp_cache=''${zsh_cache}/zcompdump-''${ZSH_VERSION}
          compinit -d ''${comp_cache}
          [[ ''${comp_cache}.zwc -nt ''${comp_cache} ]] || zcompile -R -- "''${comp_cache}".zwc "''${comp_cache}" # compile completion  cache
          zstyle ':completion:*' cache-path ''${zsh_cache} # cache path
          zstyle ':completion:*' menu select # select completions with arrow keys
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS} # use ls colors
          zstyle ':completion:*' completer _complete # approximate completion matches
          zstyle ':completion:*' matcher-list ''' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*' # case insensitive, partial word, substring
          zstyle ':completion::complete:*' use-cache 1 # use cache
          zstyle ':completion:*:git-checkout:*' sort false # don't sort git checkout
          zstyle ':completion:*:descriptions' format '[%d]' # enable group supported descriptions

          # === PLUGINS ===

          # --- fzf-tab ---
          source ''${zsh_plugins}/fzf-tab/fzf-tab.plugin.zsh
          # download preview script if it doesn't exist
          if [ ! -f ''${HOME}/.local/bin/preview ]; then
            mkdir -p ''${HOME}/.local/bin
            wget -O ''${HOME}/.local/bin/preview -- \
              https://gist.githubusercontent.com/mehalter/2809925b6e266b3574c7deab3dae711a/raw/1d8f001c871af3bfc5139260ed7f1301929df15a/preview
            chmod +x ''${HOME}/.local/bin/preview
          fi
          zstyle ':fzf-tab:*' switch-group ',' '.' # switch groups with ,/.
          zstyle ':fzf-tab:complete:*:options' fzf-preview  # disable options preview
          zstyle ':fzf-tab:complete:*:argument-1' fzf-preview # disable subcommand preview
          zstyle ':fzf-tab:complete:(nvapp|pg|pd|pe|td|te):*' fzf-preview # disable preview for my own zsh completion
          zstyle ':fzf-tab:complete:-command-:*' fzf-preview '(out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "$(P)word"'
          zstyle ':fzf-tab:complete:*:*' fzf-preview 'preview ''${(Q)realpath}'
          zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
          zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ''${(P)word}'
          zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
          zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
          zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'
          zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
            'case "$group" in
            "commit tag") git show --color=always $word ;;
            *) git show --color=always $word | delta ;;
            esac'
          zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
            'case "$group" in
            "modified file") git diff $word | delta ;;
            "recent commit object name") git show --color=always $word | delta ;;
            *) git log --color=always $word ;;
            esac'

          # --- zsh-syntax-highlighting ---
          source ''${zsh_plugins}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

          # --- zsh-autosuggestions ---
          source ''${zsh_plugins}/zsh-autosuggestions/zsh-autosuggestions.zsh

          # --- powerlevel10k prompt ---
          source ''${zsh_plugins}/powerlevel10k/powerlevel10k.zsh-theme
          [ -f ''${ZDOTDIR:-$HOME}/.p10k.zsh ] && source ''${ZDOTDIR:-$HOME}/.p10k.zsh

          # === END PLUGINS ===

          # --- keybindings ---
          autoload -Uz edit-command-line
          function zle-keymap-select() { zle reset-prompt; zle -R }
          zle -N edit-command-line
          zle -N zle-keymap-select
          bindkey -v
          if [[ $TERM == tmux* ]]; then
            bindkey '^[[1~' beginning-of-line
            bindkey '^[[4~' end-of-line
          else
            bindkey '^[[H' beginning-of-line
            bindkey '^[[F' end-of-line
          fi
          bindkey '^[[3~' delete-char
          bindkey -M viins '^a' vi-beginning-of-line
          bindkey -M viins '^e' vi-end-of-line
          bindkey -M viins '^k' kill-line
          bindkey -M vicmd '?' history-incremental-search-backward
          bindkey -M vicmd '/' history-incremental-search-forward
          bindkey "^?" backward-delete-char
          bindkey '^x^e' edit-command-line
          bindkey '^ ' autosuggest-accept
          # expand ... to ../.. recursively
          function _rationalise-dot { # This was written entirely by Mikael Magnusson (Mikachu)
            local MATCH # keep the regex match from leaking to the environment
              if [[ $LBUFFER =~ '(^|/| |      |'$'\n'''|\||;|&)\.\.$' ]]; then
              LBUFFER+=/
              zle self-insert
              zle self-insert
            else
              zle self-insert
            fi
          }
          zle -N _rationalise-dot
          bindkey . _rationalise-dot
          bindkey -M isearch . self-insert # without this, typing . aborts incr history search
          # --- source various other scripts ---
          # source ''${ZDOTDIR:-$HOME}/.aliases

          # --- miscellaneous ---
          # # configure nvim as manpager (requires neovim-remote)
          # if [ -n "''${NVIM_LISTEN_ADDRESS+x}" ] || [ -n "''${NVIM+x}" ]; then
          #   export MANPAGER="nvr -c 'Man!' -o -"
          # else
          #   export MANPAGER="nvim -c 'Man!'"
          # fi

        '';
    };
  };
  home.sessionPath = [ "$HOME/.local/bin" "$HOME/.cargo/bin" ];

  home.packages = with pkgs; [
    cachix
    du-dust
    fd
    gdu
    home-manager
    mc
    rclone
    rsync
    statix
    thefuck
    w3m
    mediainfo
    odt2txt
    delta
    github-copilot-cli
    nixpkgs-fmt
    nodejs_21
    devenv
  ];
}
