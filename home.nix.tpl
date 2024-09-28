{ config, pkgs, lib, ... }:

{
  # Nix Packages Configs
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };  

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "<user>";
  home.homeDirectory = "/home/<user>";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Applications
    vscode
    jetbrains.idea-community
    jetbrains.webstorm
    jetbrains.phpstorm
    jetbrains.goland
    jetbrains.ruby-mine
    jetbrains.datagrip
    postman
    lens
    dbeaver-bin
    
    # Development Tools
    mise
    kubectl
    slack
    fzf
    krew
    direnv
    devbox
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {};

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager.
  home.sessionVariables = {
    EDITOR = "nano";
  };

  # Configurations for zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      rebuild = "home-manager switch --flake ~/.nix-configs";
      k = "kubectl";
      kpods = "kubectl get pods";
      kexec = "kubectl exec -ti";
    };
  
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/.zsh_history";
    };

    initExtra = ''
      export PATH="$HOME/.krew/bin:$PATH"
      export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
      eval "$(direnv hook zsh)"
      eval "$(mise activate zsh)"

      set_git_author() {
        local email="$2" name="$1"

        if [[ -z "$email" ]] || [[ -z "$name" ]]; then
          >&2 echo "Couldn't set git author!"
          return 1
        fi

        git config user.name "$name"
        git config user.email "$email"        
      }
      '';

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };
  };

  # Setup global git config
  programs.git = {
    enable = true;

    # Configure Git user information
    userName = "Vincencius Geraldo";
    userEmail = "vincenciusgeraldo@gmail.com";

    # Git aliases
    aliases = {
       set-global-user = "!f() { git config --global user.name \"$1\"; git config --global user.email \"$2\"; }; f";
       set-local-user = "!f() { git config user.name \"$1\"; git config user.email \"$2\"; }; f";
    };

    # Extra config
    extraConfig = {
      core = { editor = "nano"; };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
