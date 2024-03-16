# Shell configurations via Home-manager.
{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
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
      userName = "yousiki";
      userEmail = "you.siki@outlook.com";
      extraConfig = {
        pull.rebase = false;
        push.followTags = true;
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
          args = ["--stdio" "--tsserver-path=''${typescript}/lib/node_modules/typescript/lib"];
        };
        language =
          map
          (name: {
            name = name;
            auto-format = true;
          }) ["rust" "python" "nix"];
      };
      settings = {
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
        };
      };
    };

    # mcfly
    mcfly = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      fuzzySearchFactor = 3;
    };

    # starship
    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableIonIntegration = true;
      enableNushellIntegration = true;
      enableTransience = true;
      settings.format = "$all";
    };

    # tmux
    tmux = {
      enable = true;
    };

    # zellij
    zellij = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = false;
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
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "copyfile"
          "copypath"
          "docker"
          "fzf"
          "git"
          "gitignore"
          "history"
          "python"
          "rust"
          "shell-proxy"
          "thefuck"
          "zoxide"
          "zsh-interactive-cd"
        ];
      };
      initExtra = ''
        bindkey "\e[1;3D" backward-word # ⌥←
        bindkey "\e[1;3C" forward-word # ⌥→

        if [[ -f ~/.orbstack/shell/init.zsh ]]; then
          source ~/.orbstack/shell/init.zsh 2>/dev/null || :
        fi
      '';
      sessionVariables = {
        SHELLPROXY_URL =
          if hasSuffix "-darwin" pkgs.system
          then "http://127.0.0.1:6152" # Surge
          else "http://127.0.0.1:7890"; # Clash
        SHELLPROXY_NO_PROXY = "localhost,127.0.0.1,pku.edu.cn,yousiki.top,ybh1998.space";
      };
    };
  };

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
  ];
}
