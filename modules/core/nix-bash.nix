{ config, pkgs, ... }: {
  programs.bash.interactiveShellInit = ''
    nix-test() {
      local host=$(hostname)
      pushd ~/.nixos > /dev/null
      git add -A
      echo "Testing local configuration for $host..."
      sudo nixos-rebuild test --flake ".#$host"
      popd > /dev/null
    }

    nix-test-back() {
      local host=$(hostname)
      pushd ~/.nixos > /dev/null
      echo "WARNING: Scrapping uncommitted changes..."
      git reset --hard HEAD
      git clean -fd

      echo "Reverting live system to the last commit..."
      sudo nixos-rebuild switch --flake ".#$host"
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

      echo "Building local configuration..."
      # 1. Build first to catch compilation errors
      if sudo nixos-rebuild build --flake ".#$host"; then
        echo "Build successful! Activating live system..."
        
        # 2. Attempt live switch
        if sudo nixos-rebuild switch --flake ".#$host"; then
          if ! git diff --cached --quiet; then
            git commit -m "$msg"
            git pull origin main --rebase --autostash || true
            git push origin main
            echo "Build successful. Known-good configuration pushed to GitHub."
          else
            echo "Build successful. No git changes to commit."
          fi
        else
          echo "Activation failed (likely a service restart issue), but the system was built successfully."
          echo "To apply this configuration safely, reboot your machine."
        fi
      else
        echo "Build failed! Code error detected. Nothing was pushed to GitHub."
      fi
      popd > /dev/null
    }

    nix-deploy-back() {
      local host=$(hostname)
      pushd ~/.nixos > /dev/null
      echo "Reverting the last commit..."
      git revert --no-edit HEAD

      echo "Applying reverted configuration..."
      if sudo nixos-rebuild switch --flake ".#$host"; then
        git push origin main
        echo "Rollback successful and pushed to GitHub."
      else
        echo "Rollback failed. You may need to fix conflicts manually."
      fi
      popd > /dev/null
    }

    nix-upgrade() {
      local msg="chore: upgrade all packages (bump flake.lock)"
      local host=$(hostname)
      local action="switch"

      # Allow passing --boot for major upgrades
      if [[ "$1" == "--boot" ]]; then
        action="boot"
      elif [[ "$1" == "-m" && -n "$2" ]]; then
        msg="$2"
      fi

      pushd ~/.nixos > /dev/null
      echo "Fetching newest packages from Nixpkgs..."
      nix flake update

      echo "Building the new generation..."
      # Separate build from activation to prevent false-failures destroying the lockfile
      if sudo nixos-rebuild build --flake ".#$host"; then
        echo "Build successful! Attempting system $action..."
        
        if sudo nixos-rebuild "$action" --flake ".#$host"; then
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
          echo "Live activation failed. The generation is built and added to your boot menu."
          echo "Reboot to apply the update. Not pushing to GitHub yet to ensure stability."
          # We intentionally DO NOT run nix-test-back here, as it would delete the new flake.lock
        fi
      else
        echo "Upgrade compilation failed! Rolling back flake.lock..."
        git checkout flake.lock
      fi
      popd > /dev/null
    }
  '';
}
