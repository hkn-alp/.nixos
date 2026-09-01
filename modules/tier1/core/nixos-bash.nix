{ config, pkgs, ... }: {
  programs.bash.interactiveShellInit = ''
    nix-test() {
      local host=$(hostname)
      pushd ~/.nixos > /dev/null
      echo "Testing local configuration for $host..."
      sudo nixos-rebuild test --flake ".#$host"
      popd > /dev/null
    }

    nix-deploy() {
      local msg="chore: update system configuration"
      local host=$(hostname)
      if [[ "$1" == "-m" && -n "$2" ]]; then
        msg="$2"
      fi
      pushd ~/.nixos > /dev/null
      
      git add -A
      
      # 1. Build and apply LOCALLY first
      echo "Building and applying local configuration..."
      if sudo nixos-rebuild switch --flake ".#$host"; then
        # 2. If successful, check for changes and push
        if ! git diff --cached --quiet; then
          git commit -m "$msg"
          git pull origin main --rebase --autostash || true
          git push origin main
          echo "Build successful. Known-good configuration pushed to GitHub."
        else
          echo "Build successful. No git changes to commit."
        fi
      else
        echo "Build failed! Nothing was pushed to GitHub."
      fi
      popd > /dev/null
    }

    nix-upgrade() {
      local msg="chore: upgrade all packages (bump flake.lock)"
      local host=$(hostname)
      if [[ "$1" == "-m" && -n "$2" ]]; then
        msg="$2"
      fi
      pushd ~/.nixos > /dev/null
      echo "Fetching newest packages from Nixpkgs..."
      nix flake update
      
      # Build and apply LOCALLY first
      if sudo nixos-rebuild switch --flake ".#$host"; then
        git add flake.lock
        if ! git diff --cached --quiet; then
          git commit -m "$msg"
          git pull origin main --rebase --autostash || true
          git push origin main
          echo "System upgraded successfully. New lockfile pushed to GitHub."
        else
          echo "Packages are already up to date."
        fi
      else
        echo "Upgrade failed! Lockfile changes were not pushed."
      fi
      popd > /dev/null
    }
  '';
}
