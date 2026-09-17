# .nixos

A declarative, modular NixOS configuration featuring the Umbriel compositor, Noctalia Shell, Disko-managed LUKS + Btrfs, and a streamlined GPU offload architecture.

This repository relies on a profile-based module system, allowing seamless deployment across high-performance workstations, virtual machines, and a foundational architecture for a future multi-node home server environment.

---

## 🏗️ System Architecture

To maintain a clean and reproducible system, the configuration has been fully modularized away from strict tiers into a flexible profile system. Configurations are assembled from modular building blocks:

* **Profiles (`modules/profiles/`):** The top-level definitions for specific hardware roles, including `workstation.nix`, `server.nix`, and `vm.nix`.


* **Core (`modules/core/`):** Global, OS-level configurations including bootloaders, networking, Tailscale, Btrfs scrubbing, and custom GitOps bash utilities.


* **Hardware & Desktop:** Specialized modules handling audio, Bluetooth, power management, and the Wayland environment (Umbriel + Noctalia).


* **Programs (`modules/programs/`):** Categorized application suites (gaming, creative, development, productivity).


* **Fallbacks (`modules/fallbacks/`):** Containerized environments managed declaratively via Flatpak and Distrobox/Podman, alongside the global development shell flake.



---

## 🛠️ The GitOps Workflow (Local-First)

System states are managed via custom bash commands embedded in `modules/core/nix-bash.nix`. This enforces a strict "Local-First" rule: changes are built and applied locally, and *only* pushed to the repository if the build succeeds.

| Command | Action |
| --- | --- |
| `nix-test` | Builds the system locally. Changes revert on the next reboot. Perfect for testing breaking changes.

 |
| `nix-test-back` | Scraps uncommitted changes and reverts the live system to the last commit.

 |
| `nix-deploy -m "msg"` | Builds the system locally. If successful, automatically commits and pushes the configuration.

 |
| `nix-deploy-back` | Reverts the last commit, applies the configuration, and pushes the rollback.

 |
| `nix-upgrade -m "msg"` | Fetches the latest Nixpkgs, applies them locally, and pushes the new `flake.lock` upon success.

 |

---

## 🔬 Development Environments (Direnv & Flakes)

Project-specific, isolated toolchains (Python, Julia, Rust, LaTeX, C/C++) are deployed dynamically on a per-folder basis using `direnv` and `nix-ld`, heavily optimized for high-performance astrodynamics computations and space engineering research.

The global flake in `modules/fallbacks/flake.nix` provides dedicated shells:

* **`python` / `jupyter**`: Core scientific Python environments (NumPy, SciPy, Pandas, SpiceyPy).


* **`rust` / `c-cpp**`: High-performance systems development toolchains.


* **`latex`**: Full TeX Live scheme with `texlab` for academic authoring.


* **`jupyter-julia`**: The ultimate astrodynamics shell, integrating Jupyter and Julia within a localized project namespace.



To activate an environment, echo the desired shell into an `.envrc` file and allow it:

```bash
echo "use flake ~/.nixos/modules/fallbacks#jupyter-julia" > .envrc
direnv allow

```

---

## 🎮 Gaming & Dedicated GPUs (PRIME)

This configuration universally applies GameMode, Gamescope, and specific input Udev rules (like 8BitDo Ultimate Controller support) via `modules/programs/gaming.nix`.

### The `gpuWrap` Overlay

Instead of manually crafting `symlinkJoin` wrappers for individual applications, this repository introduces a global `gpuWrap` overlay in `modules/core/gpu-wrapper.nix`. This automatically injects the required `__NV_PRIME_RENDER_OFFLOAD` and `__GLX_VENDOR_LIBRARY_NAME` environment variables into any wrapped package.

To force a standalone application (like Blender, FreeCAD, or SuperTuxKart) to permanently use the discrete GPU, simply call the wrapper in your package list:

```nix
environment.systemPackages = with pkgs; [
  (pkgs.gpuWrap blender)
  (pkgs.gpuWrap freecad)
  (pkgs.gpuWrap supertuxkart)
];

```

If PRIME offload is disabled on a specific host (e.g., a server or VM), the overlay intelligently ignores the wrapper and returns the standard package.

### Game Launchers

* **Steam Games**: Right-click the game in Steam -> **Properties...** -> **General** -> **Launch Options**:
```bash
gamemoderun nvidia-offload %command%

```


*(Or with MangoHud: `gamemoderun mangohud nvidia-offload %command%`)*

---

## 🚀 Scenario A: Reinstalling an Existing Host

Use this method if the machine's profile (like Cyron or VM) and `hardware.nix` already exist in the repository.

### Step 1: Boot & Format (Disko)

Boot the NixOS Minimal ISO and connect to the internet (use `nmtui` for Wi-Fi). Run Disko directly from GitHub to partition and mount the drives:

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake "github:hkn-alp/.nixos#Cyron"

```

*(Enter your chosen LUKS encryption password when prompted).*

### Step 2: Install NixOS

Since the hardware configuration is already tracked, install directly from the remote flake:

```bash
sudo nixos-install --flake "github:hkn-alp/.nixos#Cyron" --no-root-passwd
sudo reboot

```

### Step 3: Post-Installation Setup

Log in and clone your repository locally to manage future updates via the GitOps workflow:

```bash
git clone https://github.com/hkn-alp/.nixos.git ~/.nixos

```

---

## 🚀 Scenario B: Bootstrapping a New Machine

*Use this method if you are installing NixOS on a brand new computer that needs a new `hardware.nix` generated.*

### Step 1: Prep the Live Environment & Clone

Boot the NixOS Minimal ISO, connect to the internet, and spawn a temporary shell with Git:

```bash
nix-shell -p git
git clone https://github.com/hkn-alp/.nixos.git .nixos
cd .nixos

```

### Step 2: Create the Host Profile

Duplicate an existing host folder to act as your template:

```bash
cp -r hosts/Cyron hosts/NewHost

```

**1. Route the Flake**
Open `flake.nix` and add your `NewHost` to the `nixosConfigurations` block:

```nix
NewHost = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux"; 
  specialArgs = { inherit inputs; };
  modules = [ ./hosts/NewHost/default.nix ];
};

```

**2. Update the Hostname**
Open `hosts/NewHost/default.nix` and ensure the hostname matches:

```nix
networking.hostName = "NewHost";

```

**3. Target the Correct Drive with Disko**
List available block devices (`lsblk`). Open `hosts/NewHost/disko.nix` and update the device target:

```nix
disko.devices.disk.main = {
  device = "/dev/YOUR_TARGET_DRIVE"; 
};

```

**4. Stage the Hardware Profile**
Create an empty placeholder for your hardware configuration and track it, otherwise the Nix installer will ignore it:

```bash
touch hosts/NewHost/hardware.nix
echo "{ ... }: {}" > hosts/NewHost/hardware.nix 
git add .

```

### Step 3: Format the Disk (Disko)

Run Disko using your *local* flake to format and mount the drives to `/mnt`:

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake .#NewHost

```

### Step 4: Generate Hardware Config

Generate the hardware profile:

```bash
sudo nixos-generate-config --root /mnt --dir /tmp
cp /tmp/hardware-configuration.nix hosts/NewHost/hardware.nix

```

*Crucial:* Open `hosts/NewHost/hardware.nix` and delete all `fileSystems`, `swapDevices`, and `boot.initrd.luks` blocks, as Disko handles these.

### Step 5: Install & Persist

Stage the newly generated hardware configuration in git:

```bash
git add .

```

Install the system from the local flake:

```bash
sudo nixos-install --flake .#NewHost --no-root-passwd

```

Copy the local repository directly into your new persistent home directory so it survives the reboot:

```bash
sudo cp -r .nixos /mnt/home/hakanalp/
sudo chown -R 1000:1000 /mnt/home/hakanalp/.nixos

```

### Step 6: Reboot & Push

```bash
sudo reboot

```

When the machine restarts, log in, navigate to `~/.nixos`, commit your new hardware configuration, and push it to your repository. Future updates can now be handled via `nix-deploy`.
