{ pkgs, ... }:

let
  # Shared helper interpolated into the scripts that push to GitHub
  retryGitPush = ''
    _retry_git_push() {
      if git push origin main; then
        return 0
      else
        echo -e "\nERROR: git push failed. (Likely the Wayland SSH agent refusing operation)"
        read -p "Would you like to secure the key, authorize it via CLI, and retry? (y/N): " retry_ans
        if [[ "$retry_ans" =~ ^[Yy]$ ]]; then
          echo "1. Securing key permissions (chmod 600)..."
          chmod 600 ~/.ssh/id_ed25519

          echo "2. Forcing manual passphrase prompt..."
          ssh-add ~/.ssh/id_ed25519

          echo "3. Verifying GitHub access..."
          if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            echo "GitHub authentication successful! Retrying push..."
            git push origin main
            return $?
          else
            echo "GitHub authentication failed. You will need to check your keys manually."
            return 1
          fi
        else
          echo "Skipping push. You will need to manually push later."
          return 1
        fi
      fi
    }
  '';

  nix-test = pkgs.writeShellScriptBin "nix-test" ''
    host=$(hostname)
    pushd ~/.nixos > /dev/null
    git add -A
    echo "Testing local configuration for $host..."
    sudo nixos-rebuild test --flake ".#$host"
    popd > /dev/null
  '';

  nix-test-back = pkgs.writeShellScriptBin "nix-test-back" ''
    host=$(hostname)
    pushd ~/.nixos > /dev/null
    echo "WARNING: Scrapping uncommitted changes..."
    git reset --hard HEAD
    git clean -fd

    echo "Reverting live system to the last commit..."
    sudo nixos-rebuild switch --flake ".#$host"
    popd > /dev/null
  '';

  nix-deploy = pkgs.writeShellScriptBin "nix-deploy" ''
    ${retryGitPush}
    msg="chore: update system configuration"
    host=$(hostname)
    if [[ "$1" == "-m" && -n "$2" ]]; then
      msg="$2"
    fi
    pushd ~/.nixos > /dev/null

    git add -A

    echo "Building local configuration..."
    if sudo nixos-rebuild build --flake ".#$host"; then
      echo "Build successful! Activating live system..."

      if sudo nixos-rebuild switch --flake ".#$host"; then
        if ! git diff --cached --quiet; then
          git commit -m "$msg"
          git pull origin main --rebase --autostash || true
          if _retry_git_push; then
            echo "Build successful. Known-good configuration pushed to GitHub."
          else
            echo "ERROR: Build and commit successful, but git push failed! Configuration is only local."
          fi
        else
          echo "Build successful. No git changes to commit."
        fi
      else
        echo "Live activation failed (likely a service issue). Falling back to boot..."
        sudo nixos-rebuild boot --flake ".#$host"

        if ! git diff --cached --quiet; then
          git commit -m "$msg (requires reboot)"
          git pull origin main --rebase --autostash || true
          if _retry_git_push; then
            echo "Configuration committed and pushed. Please reboot your machine to apply the changes."
          else
            echo "ERROR: Configuration committed locally, but git push failed! Please reboot and manually push later."
          fi
        fi
      fi
    else
      echo "Build failed! Code error detected. Nothing was pushed to GitHub."
    fi
    popd > /dev/null
  '';

  nix-deploy-back = pkgs.writeShellScriptBin "nix-deploy-back" ''
    ${retryGitPush}
    host=$(hostname)
    pushd ~/.nixos > /dev/null
    echo "Reverting the last commit..."
    git revert --no-edit HEAD

    echo "Applying reverted configuration..."
    if sudo nixos-rebuild switch --flake ".#$host"; then
      if _retry_git_push; then
        echo "Rollback successful and pushed to GitHub."
      else
        echo "ERROR: Rollback applied locally, but git push failed!"
      fi
    else
      echo "Rollback failed. You may need to fix conflicts manually."
    fi
    popd > /dev/null
  '';

  nix-upgrade = pkgs.writeShellScriptBin "nix-upgrade" ''
    ${retryGitPush}
    msg="chore: upgrade all packages (bump flake.lock)"
    host=$(hostname)
    action="switch"

    if [[ "$1" == "--boot" ]]; then
      action="boot"
    elif [[ "$1" == "-m" && -n "$2" ]]; then
      msg="$2"
    fi

    pushd ~/.nixos > /dev/null
    echo "Fetching newest packages from Nixpkgs..."
    nix flake update

    echo "Building the new generation..."
    if sudo nixos-rebuild build --flake ".#$host"; then
      echo "Build successful! Attempting system $action..."

      if sudo nixos-rebuild "$action" --flake ".#$host"; then
        git add flake.lock
        if ! git diff --cached --quiet; then
          git commit -m "$msg"
          git pull origin main --rebase --autostash || true
          if _retry_git_push; then
            echo "System upgraded successfully. New lockfile pushed to GitHub."
          else
            echo "ERROR: System upgraded and lockfile committed locally, but git push failed!"
          fi
        else
          echo "Packages are already up to date."
        fi
      else
        echo "Live activation failed. Falling back to boot..."
        sudo nixos-rebuild boot --flake ".#$host"

        git add flake.lock
        if ! git diff --cached --quiet; then
          git commit -m "$msg (requires reboot)"
          git pull origin main --rebase --autostash || true
          if _retry_git_push; then
            echo "Lockfile committed and pushed. Please reboot to apply the upgrade."
          else
            echo "ERROR: Lockfile committed locally, but git push failed! Please reboot and push manually."
          fi
        fi
      fi
    else
      echo "Upgrade compilation failed! Rolling back flake.lock..."
      git checkout flake.lock
    fi
    popd > /dev/null
  '';

  nix-clean = pkgs.writeShellScriptBin "nix-clean" ''
      echo "1. Deploying current configuration..."
      if ! nix-deploy "$@"; then
        echo "ERROR: nix-deploy failed. Aborting cleanup to preserve rollback generations."
        exit 1
      fi

      echo "2. Deleting old system and user generations + collecting garbage..."
      sudo nix-collect-garbage -d
      nix-collect-garbage -d

      echo "3. Resetting current generation to #1..."
      current_target=$(readlink -f /nix/var/nix/profiles/system)
      current_link=$(readlink /nix/var/nix/profiles/system)

      if [[ "$current_link" != "system-1-link" ]]; then
        sudo ln -sfn "$current_target" /nix/var/nix/profiles/system-1-link
        sudo ln -sfn system-1-link /nix/var/nix/profiles/system
        sudo rm -f "/nix/var/nix/profiles/$current_link"
      fi

      echo "4. Updating boot menu..."
      sudo /run/current-system/bin/switch-to-configuration boot

      echo "5. Current system generations:"
      sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
    '';
in
{
  environment.systemPackages = [
    nix-test
    nix-test-back
    nix-deploy
    nix-deploy-back
    nix-upgrade
    nix-clean
  ];
}
