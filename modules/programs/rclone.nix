{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.rclone
    
    # --- SETUP SCRIPT ---
    (pkgs.writeShellScriptBin "nix-rclone-setup" ''
      #!/usr/bin/env bash
      set -e

      REMOTE=""
      DIR_NAME=""
      CLOUD_DIR=""

      # Parse command line flags
      while [[ $# -gt 0 ]]; do
        case $1 in
          -r|--remote) REMOTE="$2"; shift 2 ;;
          -d|--dir) DIR_NAME="$2"; shift 2 ;;
          -c|--cloud-dir) CLOUD_DIR="$2"; shift 2 ;;
          *) echo "Unknown parameter: $1"; exit 1 ;;
        esac
      done

      if [ -z "$REMOTE" ] || [ -z "$DIR_NAME" ]; then
        echo "Usage: nix-rclone-setup --remote <remotename> --dir <localfolder> [--cloud-dir <remotefolder>]"
        echo "Example 1 (Whole drive): nix-rclone-setup --remote onedrive --dir AllFiles"
        echo "Example 2 (Specific folder): nix-rclone-setup --remote onedrive --dir School --cloud-dir Documents/School"
        exit 1
      fi

      # Construct the remote path depending on whether a cloud dir was provided
      if [ -z "$CLOUD_DIR" ]; then
        REMOTE_PATH="$REMOTE:"
      else
        REMOTE_PATH="$REMOTE:$CLOUD_DIR"
      fi

      BASE_DIR="$HOME/Rclone"
      SYNC_DIR="$BASE_DIR/$DIR_NAME"
      ENV_DIR="$HOME/.config/rclone"
      ENV_FILE="$ENV_DIR/bisync-$DIR_NAME.env"

      mkdir -p "$SYNC_DIR"
      mkdir -p "$ENV_DIR"

      echo "1. Checking authentication for '$REMOTE'..."
      if ! ${pkgs.rclone}/bin/rclone listremotes | grep -q "^$REMOTE:"; then
        echo "Remote '$REMOTE' not found. Launching interactive setup..."
        ${pkgs.rclone}/bin/rclone config
      fi

      echo "2. Checking bisync cache status for $DIR_NAME..."
      if [ ! -f "$ENV_FILE" ]; then
        echo "First run detected. Performing initial --resync. This may take a while..."
        ${pkgs.rclone}/bin/rclone bisync "$REMOTE_PATH" "$SYNC_DIR" --resync --verbose
        
        # Write environment variables for the systemd template to read
        echo "REMOTE_PATH=$REMOTE_PATH" > "$ENV_FILE"
        echo "SYNC_DIR=$DIR_NAME" >> "$ENV_FILE"
      else
        echo "Bisync environment already exists. Skipping --resync."
      fi

      echo "3. Starting background sync service for $DIR_NAME..."
      systemctl --user enable --now "rclone-bisync@$DIR_NAME.timer"
      
      echo "Setup complete! '$REMOTE_PATH' is actively syncing to '$SYNC_DIR'."
    '')

    # --- REMOVE SCRIPT ---
    (pkgs.writeShellScriptBin "nix-rclone-remove" ''
      #!/usr/bin/env bash
      set -e

      DIR_NAME=""
      REMOVE_ALL=false

      # Parse command line flags
      while [[ $# -gt 0 ]]; do
        case $1 in
          -d|--dir) DIR_NAME="$2"; shift 2 ;;
          --all) REMOVE_ALL=true; shift 1 ;;
          *) echo "Unknown parameter: $1"; exit 1 ;;
        esac
      done

      if [ "$REMOVE_ALL" = true ]; then
        echo "Removing ALL rclone bisync timers..."
        for env_file in "$HOME/.config/rclone"/bisync-*.env; do
          [ -e "$env_file" ] || continue
          name=$(basename "$env_file" .env)
          dir_name=''${name#bisync-}
          
          systemctl --user disable --now "rclone-bisync@$dir_name.timer" 2>/dev/null || true
          rm -f "$env_file"
          echo "✅ Disabled sync for: $dir_name"
        done
        echo "All background syncs stopped. Your local files in ~/Rclone/ were NOT deleted."
        exit 0
      fi

      if [ -z "$DIR_NAME" ]; then
        echo "Usage: nix-rclone-remove --dir <foldername> OR nix-rclone-remove --all"
        exit 1
      fi

      echo "Stopping background sync for $DIR_NAME..."
      systemctl --user disable --now "rclone-bisync@$DIR_NAME.timer" 2>/dev/null || true
      rm -f "$HOME/.config/rclone/bisync-$DIR_NAME.env"
      
      echo "✅ Removed background sync for $DIR_NAME."
      echo "Note: Your local files are kept at ~/Rclone/$DIR_NAME."
    '')
  ];

  # --- SYSTEMD SERVICE TEMPLATE ---
  systemd.user.services."rclone-bisync@" = {
    description = "Automated Rclone Bisync for %i";
    after = [ "network-online.target" ];
    unitConfig = {
      ConditionPathExists = "%h/.config/rclone/bisync-%i.env";
    };
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = "%h/.config/rclone/bisync-%i.env";
      ExecStart = "${pkgs.rclone}/bin/rclone bisync \${REMOTE_PATH} %h/Rclone/\${SYNC_DIR} --verbose --conflict-resolve newer";
    };
  };

  # --- SYSTEMD TIMER TEMPLATE ---
  systemd.user.timers."rclone-bisync@" = {
    description = "Timer for automated rclone bisync (%i)";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "3m";
      OnUnitActiveSec = "5m";
      Unit = "rclone-bisync@%i.service";
    };
  };
}
