{ config, pkgs, ... }: {
  environment.systemPackages = [ pkgs.direnv ];

  programs.bash = {
    # Automatically hook direnv into the shell
    interactiveShellInit = ''
      eval "$(direnv hook bash)"
    '';

    # Custom alias to track which folders on your drive have active .envrc files
    shellAliases = {
      direnv-list = "find ~/.local/share/direnv/allow -type f -exec cat {} + | xargs -I {} dirname {}";
    };
  };
}
