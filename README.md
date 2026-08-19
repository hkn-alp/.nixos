# .nixos (Host: Cyron)

Declarative NixOS configuration featuring Niri, Noctalia Shell, PRIME offload gaming, and Disko-managed LUKS + Btrfs.

---

## 1. Installation from Live ISO

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
sudo systemctl start NetworkManager
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

Log in as `hakanalp` (default initial password: `1234`) and clone your repository locally to manage future builds:

```bash
git clone [https://github.com/hkn-alp/.nixos.git](https://github.com/hkn-alp/.nixos.git) ~/.nixos
cd ~/.nixos

```

### Rebuilding the System

* **Apply local changes:**
```bash
sudo nixos-rebuild switch --flake ~/.nixos#Cyron

```


* **Update all inputs (Nixpkgs, Disko, Noctalia):**
```bash
nix flake update
sudo nixos-rebuild switch --flake ~/.nixos#Cyron

```


* **Update a single input:**
```bash
nix flake lock --update-input nixpkgs
sudo nixos-rebuild switch --flake ~/.nixos#Cyron

```



---

## 3. Gaming & Discrete GPU Guide

PRIME offload and GameMode are configured system-wide.

* **Steam Games**: Right-click the game in Steam -> **Properties...** -> **General** -> **Launch Options**:
```bash
gamemoderun nvidia-offload %command%

```


*(Or with MangoHud: `gamemoderun mangohud nvidia-offload %command%`)*
* **Heroic Games Launcher**: Go to **Settings** -> **Game Defaults** (or per-game settings) -> **Other** -> toggle **Use Dedicated Graphics Card (PRIME Offload)** and **Use GameMode** to ON.
* **Lutris**: Go to **Preferences** -> **Global Options** -> toggle **Enable NVIDIA Prime Render Offload** and **Enable GameMode** to ON.
* **SuperTuxKart**: Wrapped to launch on the discrete NVIDIA GPU automatically.

```

```
