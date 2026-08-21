# .nixos

A declarative, role-based NixOS configuration featuring Niri, the Noctalia Shell, PRIME offload gaming, and Disko-managed LUKS + Btrfs.

This repository utilizes a flattened module architecture, allowing you to instantly deploy highly specific "suites" (e.g., `development`, `games`, `office`) across physical desktops, laptops, and virtual machines.

---

## 🛠️ The GitOps Workflow (Local-First)

This system is managed via custom bash commands embedded in `modules/core/bash.nix`. It enforces a strict "Local-First" rule: changes are built and applied locally, and *only* pushed to GitHub if the build succeeds.

| Command | Action |
| :--- | :--- |
| `nix-test` | Builds the system locally. Changes revert on the next reboot. Perfect for testing breaking changes. |
| `nix-deploy -m "msg"` | Builds the system locally. If successful, automatically commits and pushes the configuration to GitHub. |
| `nix-upgrade -m "msg"` | Fetches the latest Nixpkgs, applies them locally, and pushes the new `flake.lock` to GitHub upon success. |
| `nix-upgrade-inputs <input>` | Updates a specific flake input (e.g., `noctalia`), applies locally, and pushes the lockfile. |

---

## 🚀 Scenario A: Reinstalling an Existing Host
*Use this method if the machine's profile (like Cyron or VM) and `hardware.nix` already exist in the GitHub repository.*

### Step 1: Boot & Format (Disko)
Boot the NixOS Minimal ISO and connect to the internet (use `nmtui` for Wi-Fi). Run Disko directly from GitHub to partition and mount the drives:
```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake "github:hkn-alp/.nixos#Cyron"
```

*(Enter your chosen LUKS encryption password when prompted).*

### Step 2: Install NixOS

Since the hardware configuration is already on GitHub, install directly from the remote flake:

```bash
sudo nixos-install --flake "github:hkn-alp/.nixos#Cyron" --no-root-passwd
sudo reboot
```

### Step 3: Post-Installation Setup

Log in. Clone your repository locally so you can manage future updates via your GitOps workflow:

```bash
git clone https://github.com/hkn-alp/.nixos.git ~/.nixos
cd ~/.nixos
```

---

## 🚀 Scenario B: Bootstrapping a New Machine

*Use this method if you are installing NixOS on a brand new computer that needs a new `hardware.nix` generated.*

### Step 1: Prep the Live Environment & Clone

Boot the NixOS Minimal ISO, connect to the internet, and spawn a temporary shell with Git:

```bash
nix-shell -p git
git clone https://github.com/hkn-alp/.nixos.git
cd .nixos

```

### Step 2: Create the Host Profile

Duplicate an existing host folder to act as a template, and edit `flake.nix` to add `NewHost` to the `nixosConfigurations` block:

```bash
cp -r hosts/Cyron hosts/NewHost
```

Update `hosts/NewHost/default.nix` and `disko.nix` with the new machine's details. Create a blank hardware file and stage it so the Flake can see it:

```bash
touch hosts/NewHost/hardware.nix
git add hosts/NewHost/hardware.nix
```

### Step 3: Format the Disk (Disko)

Run Disko using your *local* flake to format and mount the drives to `/mnt`:

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko \
  --flake .#NewHost
```

### Step 4: Generate Hardware Config

Now that the drives are mounted, generate the hardware profile:

```bash
sudo nixos-generate-config --root /mnt --dir /tmp
cp /tmp/hardware-configuration.nix hosts/NewHost/hardware.nix
```

*Crucial:* Open `hosts/NewHost/hardware.nix` and delete all `fileSystems`, `swapDevices`, and `boot.initrd.luks` blocks, as Disko handles these.

### Step 5: Install & Persist

Stage the newly generated hardware configuration in git. **Without this, the installer will ignore it!**

```bash
git add hosts/NewHost/hardware.nix
```

Install the system from the local flake:

```bash
sudo nixos-install --flake .#NewHost --no-root-passwd
```

**Do not reboot yet!** Copy the local repository directly into your new persistent home directory so it survives the reboot:

```bash
sudo cp -r ~/.nixos /mnt/home/hakanalp/
sudo chown -R 1000:1000 /mnt/home/hakanalp/.nixos
```

### Step 6: Reboot & Push

```bash
sudo reboot
```

Log in to your new system. Open a terminal, navigate to `~/.nixos`, authenticate with GitHub, and push your new hardware configuration. Future updates can now be handled entirely via `nix-deploy`.

---

## 🎮 Gaming & Dedicated GPUs (PRIME)

This configuration universally applies GameMode and specific input Udev rules (like 8BitDo support) via `modules/games/system-gaming.nix`.

### Game Launchers

* **Steam Games**: Right-click the game in Steam -> **Properties...** -> **General** -> **Launch Options**:
```bash
gamemoderun nvidia-offload %command%
```

*(Or with MangoHud: `gamemoderun mangohud nvidia-offload %command%`)*

* **Heroic Games Launcher**: Go to **Settings** -> **Game Defaults** (or per-game settings) -> **Other** -> toggle **Use Dedicated Graphics Card (PRIME Offload)** and **Use GameMode** to ON.

* **Lutris**: Go to **Preferences** -> **Global Options** -> toggle **Enable NVIDIA Prime Render Offload** and **Enable GameMode** to ON.

### Wrapping Standalone Apps (Blender, FreeCAD, SuperTuxKart)

To force standalone applications to permanently use the discrete GPU, use `symlinkJoin` and `makeWrapper` in your `.nix` module. This injects the required environment variables directly into the application's executable.

Here is the module template used for `supertuxkart.nix` that you can adapt for other software:

```nix
{ pkgs, ... }: {
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "supertuxkart-nvidia";
      paths = [ pkgs.supertuxkart ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/supertuxkart \
          --set __NV_PRIME_RENDER_OFFLOAD 1 \
          --set __VK_LAYER_NV_optimus NVIDIA_only \
          --set __GLX_VENDOR_LIBRARY_NAME nvidia
      '';
    })
  ];
}
```
