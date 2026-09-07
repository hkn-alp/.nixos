{ config, pkgs, ... }: {
  programs.bash.interactiveShellInit = ''
    nix-test() {
      local host=$(hostname)
      pushd ~/.nixos > /dev/null
      echo "Testing local configuration for $host..."
      sudo nixos-rebuild test --flake ".#$host"
      popd > /dev/null
    }

    nix-test-back() {
      local host=$(hostname)
      pushd ~/.nixos > /dev/null
      echo "Scrapping uncommitted changes..."
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
