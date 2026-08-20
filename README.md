# .nixos (Host: Cyron)

Declarative NixOS configuration featuring Niri, Noctalia Shell, PRIME offload gaming, and Disko-managed LUKS + Btrfs.

---

## 1. Installation from Live ISO (Existing Host)

### Step 1: Boot & Connect to Network
Boot the target machine or VM using the official **NixOS Minimal ISO**.

* **Wired Connection (Ethernet):**
  DHCP is active by default. Verify your connection with:
  ```bash
  ping -c 3 nixos.org
  ```

* **Wireless Connection (Wi-Fi):**
  Use the NetworkManager text UI to scan and connect:
  ```bash
  nmtui
  ```
  *(Select **Activate a connection**, choose your SSID, and enter your password).*

---

### Step 2: Disk Partitioning, Encryption & Formatting (Disko)
Run Disko directly from GitHub to automatically configure the GPT partitions, LUKS container, Btrfs subvolumes, and swap space:

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko \
  --flake "github:hkn-alp/.nixos#Cyron"
```
*(Enter your chosen LUKS encryption password when prompted).*

**Verify partitions:**
To ensure Disko successfully formatted and mounted your drives, check the block device layout:
```bash
lsblk
```
*(You should see your main drive divided into ESP, a decrypted cryptroot LUKS container with your Btrfs subvolumes mounted under /mnt, and a swap partition).*

---

### Step 3: Install NixOS
Install the entire system referencing the remote flake directly:

```bash
sudo nixos-install --flake "github:hkn-alp/.nixos#Cyron" --no-root-passwd
```

---

### Step 4: Reboot
```bash
sudo reboot
```

---

## 2. Post-Installation Setup

Log in as `hakanalp` (default initial password: `1234`) and clone your repository locally to manage future builds. *(Note: Git is already installed here because it is in your core packages)*:

```bash
git clone [https://github.com/hkn-alp/.nixos.git](https://github.com/hkn-alp/.nixos.git) ~/.nixos
cd ~/.nixos
```

### Rebuilding the System (GitOps Workflow)

This configuration uses a GitOps workflow. Changes made locally must be tested, and then deployed to GitHub to become permanent. 

* **Test local changes safely:**
  ```bash
  nix-test
  ```
  *(Builds the system locally. If it crashes, changes disappear on reboot).*

* **Deploy changes permanently:**
  ```bash
  nix-deploy -m "optional commit message here"
  ```
  *(Pushes your code to GitHub and deploys directly from the cloud).*

* **Upgrade all packages (Nixpkgs, Disko, Noctalia):**
  ```bash
  nix-upgrade -m "optional commit message here"
  ```

* **Upgrade specific inputs:**
  ```bash
  nix-upgrade-inputs noctalia noctalia-greeter -m "optional commit message here"
  ```

---

## 3. Porting to New Hardware

Because NixOS flakes evaluate exactly what is in your Git repository, you cannot install from GitHub until your new hardware configuration is pushed there. You must perform the initial install from a local clone on the Live USB.

1. **Boot, Connect, & Get Git:**
   Boot the new machine with the Live ISO, connect to the internet, and spawn a temporary shell with Git installed:
   ```bash
   nix-shell -p git
   ```

2. **Clone Locally:**
   Inside that shell, clone your repository:
   ```bash
   git clone https://github.com/hkn-alp/.nixos.git
   cd .nixos
   ```

3. **Create the New Host Directory:**
   Duplicate your existing host folder to create a template for the new one:
   ```bash
   cp -r modules/hosts/Cyron modules/hosts/NewHost
   ```

4. **Update Host-Specific Files:**
   * Edit `modules/hosts/NewHost/configuration.nix` and change `networking.hostName` to `NewHost`.
   * Edit `modules/hosts/NewHost/disko-config.nix` to ensure the `device = "/dev/..."` line matches the target drive of the new machine (e.g., `/dev/vda` for VMs).
   * Edit `flake.nix` to duplicate the `Cyron` configuration block and rename it for `NewHost`.
   * Because Nix flakes ignore untracked files, create an empty placeholder for your hardware config first, then stage it:
   ```bash
   touch hardware/NewHost.nix
   echo "{ ... }: {}" > hardware/NewHost.nix
   git add hardware/NewHost.nix

5. **Format & Mount (Disko):**
   Run Disko using your *local* flake to partition the drive and mount it to `/mnt`:
   ```bash
   sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
     --mode disko \
     --flake .#NewHost
   ```

**Verify partitions:**
To ensure Disko successfully formatted and mounted your drives, check the block device layout:
```bash
lsblk
```


6. **Generate the Hardware Config:**
   Now that the drives are mounted, generate the hardware profile directly into your new hardware folder:
   ```bash
   sudo nixos-generate-config --root /mnt --dir /tmp
   cp /tmp/hardware-configuration.nix hardware/NewHost.nix
   ```

7. **Track Files in Git (Crucial):**
   Nix flakes completely ignore files that are not tracked by Git. Because you are still in your `nix-shell -p git` environment, you can stage the new hardware config:
   ```bash
   git add .
   ```

8. **Install from the Local Flake:**
   Run the installer pointing to your local directory (`.`) instead of GitHub:
   ```bash
   sudo nixos-install --flake .#NewHost --no-root-passwd
   sudo reboot
   ```

9. **Push to GitHub:**
   Once you boot into your new system, open a terminal, commit your changes, and push them to GitHub. Future updates can now be run normally using the `nix-deploy` command.

---

## 4. Gaming & Discrete GPU Guide

PRIME offload and GameMode are configured system-wide.

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

Here is the template used for `supertuxkart` that you can copy and adapt for productivity software like `blender` or `freecad`:

```nix
{ ... }: {
  flake.nixosModules.apps.media.blender = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.symlinkJoin {
        name = "blender-nvidia";
        paths = [ pkgs.blender ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/blender \
            --set __NV_PRIME_RENDER_OFFLOAD 1 \
            --set __VK_LAYER_NV_optimus NVIDIA_only \
            --set __GLX_VENDOR_LIBRARY_NAME nvidia
        '';
      })
    ];
  };
}
```
