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

First, duplicate an existing host folder to act as your template:
```bash
cp -r hosts/Cyron hosts/NewHost
```

**1. Route the Flake (Critical)**
Open `flake.nix` and add your `NewHost` to the `nixosConfigurations` block so the flake knows how to evaluate it. 

You must define the correct CPU architecture for the new machine. If you are unsure, run `uname -m` in the terminal:
* For standard Intel/AMD processors, use `"x86_64-linux"`.
* For ARM processors (Raspberry Pi, ARM servers, Mac VMs), use `"aarch64-linux"`.

```nix
NewHost = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux"; # <-- Update this if using ARM!
  specialArgs = { inherit inputs; };
  modules = [
    ./hosts/NewHost/default.nix
  ];
};
```

**2. Update the Hostname**
Open `hosts/NewHost/default.nix` and ensure the hostname matches your new machine:

```nix
networking.hostName = "NewHost";
```

**3. Target the Correct Drive with Disko (Critical)**
You must explicitly tell Disko which physical drive to partition. First, list your available block devices to find the correct identifier:

```bash
lsblk
```

Once you identify the target drive (e.g., `nvme0n1`, `sda`, or `vda`), open `hosts/NewHost/disko.nix` and update the device target:

```nix
disko.devices.disk.main = {
  device = "/dev/YOUR_TARGET_DRIVE"; # <-- Update this line
  # ...
};
```

**4. Stage the Hardware Profile**
Create an empty placeholder for your hardware configuration. Because Nix flakes completely ignore untracked files, you **must** stage this file in Git now, otherwise the installer will not be able to write to it in Step 4:

```bash
touch hosts/NewHost/hardware.nix
git add .
```

### Step 3: Format the Disk (Disko)

Run Disko using your *local* flake to format and mount the drives to `/mnt`:

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake .#NewHost
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

When the machine restarts, log in to your new permanent system.

Because we copied the repository to `/mnt` in the previous step, your `.nixos` folder is waiting for you exactly as you left it. However, you still need to permanently commit the hardware configuration and authenticate with GitHub to push it.

1. Open a terminal and navigate to the repository:
```bash
cd ~/.nixos
```

2. Commit the new machine's configuration:
```bash
git commit -m "feat: bootstrap NewHost hardware configuration"
```

3. Authenticate and push to your repository (you will need to generate a GitHub Personal Access Token or set up your SSH keys on this new machine first):
```bash
git push origin main
```

Your new machine is now fully tracked in your GitOps workflow. Future updates can be handled entirely via your custom `nix-deploy` and `nix-upgrade` commands.
```

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
