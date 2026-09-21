{ pkgs, ... }: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    presets = [ "nerd-font-symbols" "pastel-powerline" ];

    settings = {
      add_newline = false;

      format = builtins.concatStringsSep "" [
        "[](fg:yellow)"
        "$os"
        "$username"
        "[](bg:bright-yellow fg:yellow)"
        "$directory"
        "[](fg:bright-yellow bg:cyan)"
        "$git_branch"
        "$git_status"
        "[](fg:cyan bg:blue)"
        "$nix_shell"
        "$c$elixir$elm$golang$gradle$haskell$java$julia$maven$nodejs$bun$nim$rust$scala"
        "[](fg:blue bg:bright-black)"
        "$docker_context"
        "[](fg:bright-black bg:black)"
        "$cmd_duration"
        "$time"
        "[ ](fg:black)"
        "\n$character"
      ];

      # --- 1. Enable and Style OS Symbol (NixOS Snowflake) ---
      os = {
        disabled = false;
        style = "bg:yellow fg:black bold";
        symbols = {
          NixOS = " ";
        };
        format = "[$symbol ]($style)";
      };

      # Username
      username = {
        show_always = true;
        style_user = "bg:yellow fg:black bold";
        style_root = "bg:red fg:black bold";
        format = "[$user ]($style)";
      };

      # Directory
      directory = {
        style = "bg:bright-yellow fg:black";
        format = "[ $path ]($style)";
      };

      # Git
      git_branch.style = "bg:cyan fg:black";
      git_status.style = "bg:cyan fg:black";

      # --- 2. Nix Shell Indicator (runs inside blue segment) ---
      nix_shell = {
        disabled = false;
        style = "bg:blue fg:black bold";
        symbol = " ";
        format = "[ $symbol$state ]($style)";
      };

      # Language group (all styled with blue bg, black text)
      c.style = "bg:blue fg:black";
      cpp.style = "bg:blue fg:black";
      elixir.style = "bg:blue fg:black";
      elm.style = "bg:blue fg:black";
      golang.style = "bg:blue fg:black";
      gradle.style = "bg:blue fg:black";
      haskell.style = "bg:blue fg:black";
      java.style = "bg:blue fg:black";
      julia.style = "bg:blue fg:black";
      maven.style = "bg:blue fg:black";
      nodejs.style = "bg:blue fg:black";
      bun.style = "bg:blue fg:black";
      nim.style = "bg:blue fg:black";
      rust.style = "bg:blue fg:black";
      scala.style = "bg:blue fg:black";

      # Docker
      docker_context.style = "bg:bright-black fg:white";

      # --- 3. Command Execution Runtime ---
      cmd_duration = {
        min_time = 2000; # Shows duration if command takes >= 2 seconds
        style = "bg:black fg:yellow bold";
        format = "[ 󱎫 $duration ]($style)";
      };

      # Time
      time = {
        style = "bg:black fg:white";
        format = "[  $time ]($style)";
      };

      # Execution prompt
      character = {
        success_symbol = "[➜](bold green) ";
        error_symbol = "[➜](bold red) ";
      };
    };
  };
}
