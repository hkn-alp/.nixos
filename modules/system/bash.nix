# modules/system/bash.nix
{ self, inputs, ... }: {

  flake.nixosModules.system.bash = { config, pkgs, ... }: {
    
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
        git pull origin main --rebase --autostash || true
        git add -A
        if ! git diff --cached --quiet; then
          git commit -m "$msg"
          git push origin main
          echo "Pushed to GitHub. Deploying directly from the cloud..."
          sudo nixos-rebuild switch --refresh --flake "github:hkn-alp/.nixos#$host"
        else
          echo "No changes found to deploy."
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
        git pull origin main --rebase --autostash || true
        echo "Fetching newest packages from Nixpkgs..."
        nix flake update
        git add flake.lock
        if ! git diff --cached --quiet; then
          git commit -m "$msg"
          git push origin main
          echo "New lockfile pushed to GitHub. Upgrading system from the cloud..."
          sudo nixos-rebuild switch --refresh --flake "github:hkn-alp/.nixos#$host"
        else
          echo "Packages are already up to date."
        fi
        popd > /dev/null
      }

      nix-upgrade-inputs() {
        if [ -z "$1" ]; then
          echo "Usage: nix-upgrade-inputs <input1> [input2...] [-m \"commit message\"]"
          return 1
        fi
        local update_args=()
        local input_names=()
        local msg=""
        local host=$(hostname)
        while [[ $# -gt 0 ]]; do
          case "$1" in
            -m)
              msg="$2"
              shift 2
              ;;
            *)
              update_args+=("--update-input" "$1")
              input_names+=("$1")
              shift
              ;;
          esac
        done
        if [ -z "$msg" ]; then
          msg="chore: update flake inputs: ''${input_names[*]}"
        fi
        pushd ~/.nixos > /dev/null
        git pull origin main --rebase --autostash || true
        echo "Updating inputs: ''${input_names[*]}..."
        nix flake lock "''${update_args[@]}"
        git add flake.lock
        if ! git diff --cached --quiet; then
          git commit -m "$msg"
          git push origin main
          echo "New lockfile pushed to GitHub. Upgrading system from the cloud..."
          sudo nixos-rebuild switch --refresh --flake "github:hkn-alp/.nixos#$host"
        else
          echo "Packages are already up to date."
        fi
        popd > /dev/null
      }
    '';
  };
}
