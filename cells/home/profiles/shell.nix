{
  inputs,
  cell,
  lib,
}:
{
  pkgs,
  config,
  lib,
  ...
}:
let
  fzf-preview =
    pkgs.writeShellScriptBin "fzf-preview"
      # sh
      ''
        case $(file -bL --mime-type "$1") in
        cannot\ open*) exit ;;
        inode/directory) ls --color=always "$1" ;;
        text/html) w3m -O UTF-8 -dump "$1" ;;
        text/troff) man ./"$1" ;;
        application/gzip | application/x-tar | application/zip | application/x-7z-compressed | application/vnd.rar | application/x-bzip*) bsdtar --list --file "$1" ;;
        application/json) jq --color-output . "$1" ;;
        audio/* | image/* | application/octet-stream) mediainfo "$1" || exit 1 ;;
        *opendocument*) odt2txt "$1" ;;
        application/pgp-encrypted) gpg -d -- "$1" ;;
        text/* | */xml) bat --style="plain" --color=always "$1" ;;
        esac
      '';
in
with builtins // lib;

{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];
  xdg.enable = true;

  programs = {
    alacritty = {
      enable = true;
      settings = {
        window = {
          padding.y = 1;
          padding.x = 1;
          option_as_alt = "Onlyleft";
          decorations = "buttonless";
          opacity = 0.9;
        };
        font = {
          normal.family = "MonaspiceXe Nerd Font Mono";
          italic = {
            style = "Light Italic";
          };
          normal.style = "Light";
          bold = {
            style = "Medium";
          };
          size = 16;
        };
      };
      catppuccin.enable = true;
    };
    bash = {
      enable = true;
      enableCompletion = true;
    };

    bat = {
      enable = true;
      catppuccin.enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batgrep
        batman
        batpipe
        batwatch
        prettybat
      ];
    };

    bottom = {
      catppuccin.enable = true;
      enable = true;
    };

    btop = {
      catppuccin.enable = true;
      enable = true;
    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
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

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      icons = true;
      git = true;
    };

    fzf = {
      enable = true;
      catppuccin.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
      defaultCommand = "fd --type f --hidden --follow";
      fileWidgetCommand = "fd --type f --hidden --follow";
      defaultOptions = [ "--extended" ];
    };

    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      extensions = with pkgs; [
        gh-actions-cache
        gh-cal
        gh-copilot
        gh-dash
        gh-eco
        gh-markdown-preview
      ];
    };

    git = {
      enable = true;
      lfs.enable = true;
      delta = {
        catppuccin.enable = true;
        enable = true;
      };
      userName = "luxus";
      userEmail = "luxuspur@gmail.com";
      extraConfig = {
        pull.rebase = false;
        push.followTags = true;
        rerere.enabled = true;
        core.fsmonitor = true;
      };
    };

    gitui = {
      enable = true;
      catppuccin.enable = true;
    };

    helix = {
      enable = true;
      catppuccin.enable = true;
      languages = {
        language-server = { };
        language =
          map
            (name: {
              inherit name;
              auto-format = true;
            })
            [
              "rust"
              "python"
              "nix"
            ];
      };
      settings = {
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
        };
      };
    };

    nix-index.enable = true;
    thefuck.enable = true;

    starship = {
      enable = true;
      catppuccin.enable = true;
      enableZshIntegration = false;
      enableTransience = true;
      settings.format = "$all";
    };

    tmux.enable = false;

    zellij = {
      enable = false;
      enableBashIntegration = false;
      enableZshIntegration = false;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
    yazi = {
      enable = true;
      catppuccin.enable = true;
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      autocd = true;
      history = {
        size = 25000;
        path = "${config.xdg.dataHome}/zsh_history";
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignorePatterns = [
          "[bf]g"
          "z"
          "&"
          "ls"
          "exit"
          "reset"
          "clear"
          "cd"
          "cd .."
          "cd.."
        ];
      };
      loginExtra = ''
        export NEOVIDE_MULTIGRID=true
        export NEOVIDE_FRAME=buttonless
      '';
      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.8.0";
            sha256 = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
          };
        }
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "v1.1.1";
            sha256 = "sha256-0/YOL1/G2SWncbLNaclSYUz7VyfWu+OB8TYJYm4NYkM=";
          };
        }
        {
          name = "zsh-completions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-completions";
            rev = "0.35.0";
            sha256 = "sha256-GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg=";
          };
        }
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./zsh;
          file = "p10k.zsh";
        }
      ];
      completionInit =
        # bash
        ''
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
        '';
      initExtraBeforeCompInit =
        # bash
        ''
          P10KP="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"; [[ ! -r "$P10KP" ]] || source "$P10KP"

            # --- zsh data directories ---
            zsh_data="''${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
            [ ! -d ''${zsh_data} ] && mkdir -p ''${zsh_data}
            zsh_cache="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
            [ ! -d ''${zsh_cache} ] && mkdir -p ''${zsh_cache}

            # --- configure zsh options ---
            setopt bash_rematch
            setopt correct
            setopt hist_verify
            setopt inc_append_history
            setopt interactivecomments
            export KEYTIMEOUT=10

            zstyle ':fzf-tab:*' switch-group ',' '.' # switch groups with ,/.
            zstyle ':fzf-tab:complete:*:options' ${fzf-preview}/bin/fzf-preview  # disable options preview
            zstyle ':fzf-tab:complete:*:argument-1' ${fzf-preview}/bin/fzf-preview # disable subcommand preview
            zstyle ':fzf-tab:complete:(nvapp|pg|pd|pe|td|te):*' ${fzf-preview}/bin/fzf-preview # disable preview for my own zsh completion
            zstyle ':fzf-tab:complete:-command-:*' ${fzf-preview}/bin/fzf-preview '(out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "$(P)word"'
            zstyle ':fzf-tab:complete:*:*' ${fzf-preview}/bin/fzf-preview 'preview ''${(Q)realpath}'
            zstyle ':fzf-tab:complete:systemctl-*:*' ${fzf-preview}/bin/fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
            zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ''${(P)word}'
            zstyle ':fzf-tab:complete:git-log:*' ${fzf-preview}/bin/fzf-preview 'git log --color=always $word'
            zstyle ':fzf-tab:complete:git-help:*' ${fzf-preview}/bin/fzf-preview 'git help $word | bat -plman --color=always'
            zstyle ':fzf-tab:complete:git-(add|diff|restore):*' ${fzf-preview}/bin/fzf-preview 'git diff $word | delta'
            zstyle ':fzf-tab:complete:git-show:*' ${fzf-preview}/bin/fzf-preview \
              'case "$group" in
              "commit tag") git show --color=always $word ;;
              *) git show --color=always $word | delta ;;
              esac'
            zstyle ':fzf-tab:complete:git-checkout:*' ${fzf-preview}/bin/fzf-preview \
              'case "$group" in
              "modified file") git diff $word | delta ;;
              "recent commit object name") git show --color=always $word | delta ;;
              *) git log --color=always $word ;;
              esac'


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
  home = {
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];
    packages = with pkgs; [
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
  };
}
