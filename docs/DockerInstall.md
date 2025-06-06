# Beargrease: Docker Installation Guide
*A Transparent Setup for Solana Developers*             

**Version:** 1.1.0+
**Maintained by:** Cabrillo! Labs
**Contact:** cabrilloweb3@gmail.com
**License:** MIT
**GitHub:** [https://github.com/rgmelvin/beargrease](https://github.com/rgmelvin/beargrease)

**Introduction**
----------------

Beargrease is a script-based test harness for Solana programs that relies on Docker to simulate a clean local validator. This installation guide walks users through installing Docker correctly on Linux, macOS, or WSL — avoiding common issues like Snap-based installs, permission errors, or broken socket access.

The guide is structured to help new developers get started smoothly, while also providing deep, platform-specific troubleshooting for more advanced setups.

---

## Table of Contents

### Docker Installation (Linux)

- [Step 1: Remove Snap-Based Docker](#step-1-remove-snap-based-docker)
- [Step 2: Remove Broken or Partial Installs](#step-2-remove-broken-or-partial-installs)
  - [2.1: Remove Docker-Related Packages](#21-remove-docker-related-packages)
  - [2.2: Clean Up Orphaned Dependencies](#22-clean-up-orphaned-dependencies)
- [Step 3: Install Docker Using apt](#step-3-install-docker-using-apt)
  - [3.1: Update and Install](#31-update-and-install)
  - [3.2: Enable and Start Docker](#32-enable-and-start-docker)
- [Step 4: Add Yourself to the Docker Group](#step-4-add-yourself-to-the-docker-group)
  - [4.1: Modify Group](#41-modify-group)
  - [4.2: Log Out or Reboot](#42-log-out-or-reboot)
  - [4.3: Confirm Group Membership](#43-confirm-group-membership)
- [Step 5: Confirm the Installation](#step-5-confirm-the-installation)
  - [5.1: Version Check](#51-version-check)
  - [5.2: Running Container Table](#52-running-container-table)

### Appendix — Troubleshooting and Platform-Specific Help

- [A.1 — Remove Snap-Based Docker](#a1--remove-snap-based-docker)
- [A.2 — Clean Up Orphan Containers](#a2--clean-up-orphan-containers)
- [A.3 — Apt Cleanup & Orphan Packages](#a3--apt-cleanup--orphan-packages)
- [A.4 — Common Errors After Starting Docker](#a4--common-errors-after-starting-docker)
- [A.5 — Check Docker Group Membership](#a5--check-docker-group-membership)
- [A.6 — Add Yourself to the Docker Group](#a6--add-yourself-to-the-docker-group)
- [A.7 — Log Out or Reboot to Apply Group Change](#a7--log-out-or-reboot-to-apply-group-change)
- [A.8 — Investigate Advanced System Conflicts](#a8--investigate-advanced-system-conflicts)
- [A.9 — `docker --version` Errors](#a9--docker---version-errors)
- [A.10 — Docker Installation on macOS](#a10--docker-installation-on-macos)
- [A.11 — Docker Installation and Troubleshooting on WSL](#a11--docker-installation-and-troubleshooting-on-wsl)
- [A.12  —  Pop!_OS (System76) Troubleshooting](#appendix-a12--popos-system76-troubleshooting)

---------------------------------------------------------- ------



# Docker Installation (Linux)

This section installs Docker using the official Docker repository — the most stable and up-to-date method recommended by Docker.

📦 *For macOS instructions, see [Appendix A.10 — Docker Installation on macOS](#appendix-a10---docker-installation-on-macos).*

---

## Step 1. Remove Snap-Based Docker

Snap-based Docker installs are discouraged. Snap-based Docker installs are sandboxed, meaning they run in isolated environments that restrict access to system resources like Unix sockets and system services. This can break tools like Beargrease that rely on full, low-level Docker integration.

➤ **Check for Snap:**

```bash
snap list docker
```

🧪 **See: [Appendix A.1 — Remove Snap-Based Docker](#appendix-a1---remove-snap-based-docker)**

Remove if present.

➤ **Also check for stale containers:**

```bash
docker ps -a
```

🧪 **See: [Appendix A.2 — Clean Up Orphan Containers](#appendix-a2---clean-up-orphan-containers)**

------



## 2. Remove Partial or Conflicting Installs

Clean up any conflicting or partial installations.

➤ **Remove old packages (safe to run even if not present):**

```bash
sudo apt remove --purge docker docker-engine docker.io docker-doc docker-compose docker-compose-v2 docker-ce docker-ce-cli containerd runc
```

➤ **Remove orphaned packages:**

```bash
sudo apt autoremove
```

🧪 **See: [Appendix A.3 — Apt Cleanup & Orphan Packages](#appendix-a3---apt-cleanup--orphan-packages)**

------



## 3. Set Up Docker’s Official Repository

This step configures your system to install Docker from the official upstream source.

------

### 3.1 Install Required Packages

➤ **Run:**

```bash
sudo apt update
sudo apt install ca-certificates curl gnupg
```

------



### 3.2 Add Docker’s Official GPG Key

➤ **Run:**

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

------



### 3.3 Add Docker Repository to APT Sources

🧭 Adjust `$(. /etc/os-release; echo "$ID")` and `$(lsb_release -cs)` if using a non-Ubuntu base.

➤ **Run:**

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

------



## 4. Install Docker Engine

------

### 4.1 Update APT and Install

➤ **Run:**

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

👀 **Expected output:**

```bash
The following additional packages will be installed:
  docker-ce docker-ce-cli containerd.io ...
Do you want to continue? [Y/n]
```

➤ **Press** Y to proceed.

------



### 4.2 Enable and Start Docker

➤ **Run:**

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

🧪 **See: [Appendix A.4 — Common Errors After Starting Docker](#appendix-a4---common-errors-after-starting-docker)**

------



## 5. Add Yourself to the Docker Group

This allows Docker to run without `sudo`.

------

### 5.1 Add User to Group

➤ **Run:**

```bash
sudo usermod -aG docker $USER
```

------



### 5.2 Log Out and Back In

🔁 Reboot or log out/in to apply the group change.

------



### 5.3 Confirm Group Membership

➤ **Run:**

```bash
groups
```

👀 **You should see:**

```bash
adm sudo docker ...
```

🧪 **See:**

- [Appendix A.5 — Check Docker Group Membership](#appendix-a5---check-docker-group-membership)
- [Appendix A.6 — Add Yourself to the Docker Group](#appendix-a6---add-yourself-to-the-docker-group)
- [Appendix A.7 — Log Out or Reboot to Apply Group Change](#appendix-a7---log-out-or-reboot-to-apply-group-change)

------



## 6. Confirm the Installation

------

### 6.1 Confirm Docker Version

➤ **Run:**

```bash
docker --version
```

👀 Expected:

```plaintext
Docker version 26.1.3, build ...
```

🧪 **See: [Appendix A.9 — docker --version Errors](#appendix-a9---docker---version-errors)**

------



### 6.2 Confirm Working Docker CLI

➤ **Run:**

```bash
docker run hello-world
```

👀 Output should end with:

```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

✅ You are now ready to use Beargrease.

---



# **Appendix: Troubleshooting for Docker Installation.**



## 🧩 Appendix A.1 — Remove Snap-Based Docker

If you previously installed Docker via **Snap**, you must remove it before proceeding. Snap-based Docker often creates permission issues and fails to integrate cleanly with system services like `systemctl`.

### 🔍 Step A.1.1 — Check for Snap-Based Docker

➤ Run:

```bash
snap list docker
```

👀 If Docker **is** installed via Snap, you will see output like:

```
Name    Version    Rev    Tracking       Publisher   Notes
docker  20.10.12   1234   latest/stable  canonical✓  -
```

🧹 You must now remove it.



### 🧨 Step A.1.2 — Remove Docker Snap Package

➤ Run:

```bash
sudo snap remove docker
```

✅ You should see:

```
docker removed
```

 If you get errors like `snap "docker" is not installed`, you can safely ignore them and continue with the installation.

📌Why this matters:** Snap-based Docker installs often lack full permissions and can block Beargrease’s validator container from launching properly. Removing it now avoids future problems.

---



## 🧩 Appendix A.2 — Clean Up Orphan Containers

Sometimes remnants of older Docker installs are still running, even if Docker was uninstalled. These leftover containers can interfere with your new setup.

### 🔍 Step A.2.1 — Check for Orphaned Containers

➤ Run:

```bash
docker ps -a
```

👀 Output may look like:

```
CONTAINER ID   IMAGE          COMMAND       CREATED       STATUS       PORTS     NAMES
4a6d89bc3a2d   hello-world    "/hello"      2 weeks ago   Exited (0)             blissful_euler
```

If the table is **empty**, you can skip to the next step. Otherwise:

### 🧨 Step A.2.2 — Remove Old Containers

➤ To remove all exited containers:

```bash
docker container prune
```

👀 You will be prompted:

```
WARNING! This will remove all stopped containers.
Are you sure you want to continue? [y/N]
```

➤ Press `y`.

👍 Once cleared, your container list should be empty:

```bash
docker ps -a
```

✅ Output:

```
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
```

📌 **Note:** This does not affect volumes or images. You are simply clearing inactive containers that could conflict with new ones.

------



## 🧩 Appendix A.3 — Apt Cleanup & Orphan Packages

After uninstalling Docker or removing partial installs, some system packages and dependencies may remain. Cleaning them up ensures you have a clean foundation before reinstalling.

### Remove Residual Packages

➤ Run:

```bash
sudo apt autoremove
```

👀 You may see output like:

```
The following packages will be REMOVED:
libslirp0 libnftnl11
After this operation, 35.2 MB disk space will be freed.
Do you want to continue? [Y/n]
```

➤ Press `Y`.

📌 If nothing is listed for removal, that is fine — it just means your system was already clean.

✅ **You are now ready to install Docker cleanly using the instructions in Step 3.**

---



## 🧩 Appendix A.4 — Common Errors After Starting Docker

After running:

```bash
sudo systemctl start docker
```

you may encounter one of the following issues:

------



### ❌ **Error:** `Unit docker.service could not be found`

🧭 This means Docker is not installed or the service file is missing.

✅ Fix:

- Go back and repeat **Step 3.1**: [Install Docker Using apt](#31-update-package-lists-and-install-docker)
- Confirm installation with:

```bash
apt show docker.io
```

------



### ❌ **Error:** `Job for docker.service failed`

🧭 This may be due to lingering Snap Docker remnants or misconfigured containers.

✅ Fix:

1. Double-check that Snap Docker is fully removed:

```bash
snap list docker
```

If it still appears, remove it:

```bash
sudo snap remove docker
```

1. Clean up any stale containers:

```bash
docker container prune
```

Then re-enable Docker:

```bash
sudo systemctl daemon-reexec
sudo systemctl start docker
```

------



### ❌ **Error:** Bridge network or rootless Docker conflicts

🧭 If you see obscure errors about `cgroups`, `slirp4netns`, or networking bridges, this likely stems from a conflicting Docker or container engine installation.

✅ Fix:

- Follow [**Appendix A.1**](#a1--remove-snap-based-docker) and [**Appendix A.3**](#a3--apt-cleanup--orphan-packages) to fully remove Snap-based Docker and run:

```bash
sudo apt purge podman
```

------

📌 These fixes resolve 99% of startup issues. If you continue having trouble, see Appendix A.8 for deep system conflicts.

------

## 

## 🧩 Appendix A.5 — Check Docker Group Membership

This appendix helps you confirm that your user was successfully added to the `docker` group so that you can run Docker without `sudo`.

------

### Check User Groups

➤ Run:

```bash
groups
```

👀 Look for:

```
docker
```

✅ Example:

```bash
rgmelvin adm cdrom sudo dip plugdev docker
```

If you **see `docker`**, you are ready to run:

```bash
docker ps
```

without `sudo`.

------



### ❌ If You **Do Not** See `docker`:

➡️ See [Appendix A.6](#appendix-a6---add-yourself-to-the-docker-group)

---



## 🧩 Appendix A.6 — Add Yourself to the Docker Group

If you forgot to add your user or need to fix group membership manually:

### Run Group Add Command

➤ Run:

```bash
sudo usermod -aG docker $USER
```

📌 `$USER` automatically expands to your current username.

🧪 This command **does not take effect until logout or reboot.** See next appendix.

------



## 🧩 **Appendix A.7 — Log Out or Reboot to Apply Group Change**

After adding your user to the Docker group (Step 5.1), the group change will not take effect until you **start a new login session**. This is a common source of confusion — many users assume the change is immediate.

------

### 🔁 **Why You Need to Log Out**

Group membership in Linux is determined **at login**. If you modify your groups while a session is active, the current session will not "see" the change. This means:

- You might still get `permission denied` errors when running `docker` commands without `sudo`
- Running `groups` might not show `docker` yet
- Beargrease may fail with silent permission errors

------

### ✅ **How to Apply the Change**

You have two reliable options:

#### Option 1: Reboot the system

This is the most foolproof approach.

```bash
sudo reboot
```

#### Option 2: Log out of all terminal and desktop sessions

1. Exit all open terminals.
2. Log out of your desktop session (e.g., from the menu).
3. Log back in and open a new terminal.

Either approach will ensure your user session includes the updated `docker` group membership.

------

### 👀 **How to Verify It Worked**

After logging back in:

```bash
groups
```

Expected output should include:

```
yourusername adm sudo docker
```

If `docker` appears in the list, your membership is active and ready for Beargrease use.

------

### 🧪 **Still Not Working?**

If you **still** cannot run `docker` without `sudo` after rebooting:

- Recheck Step 5.1: `sudo usermod -aG docker $USER`
- Make sure you are running `groups` **as your normal user**, not via `sudo`
- See:
   🧩 [Appendix A.5 — Check Docker Group Membership](#appendix-a5---check-docker-group-membership)
   🧩 [Appendix A.6 — Add Yourself to the Docker Group](#appendix-a6---add-yourself-to-the-docker-group)



## 🧩 Appendix A.8 — Investigate Advanced System Conflicts

If Docker continues to fail **after correct installation**, system-level conflicts may be to blame.

------

### ⚠️ Symptoms:

- `docker ps` hangs or returns `Cannot connect to the Docker daemon`
- `docker.service` crashes or exits immediately
- Errors referencing `overlayfs`, `slirp4netns`, or `cgroups`
- `/var/run/docker.sock` does not exist or is inaccessible

------

### ✅ Step A.8.1 — Check Docker Daemon Logs

➤ Run:

```bash
journalctl -u docker.service --no-pager --since "10 minutes ago"
```

👀 Look for errors near the bottom of the output. Common culprits include:

- `failed to start daemon: error initializing graphdriver`
- `permission denied` on `/var/run/docker.sock`
- dependency errors on `containerd`

------

### ✅ Step A.8.2 — Test Docker Socket

➤ Run:

```bash
ls -l /var/run/docker.sock
```

✅ Expected:

```
srw-rw---- 1 root docker 0 Jun  4 20:13 /var/run/docker.sock
```

If your user is not in the `docker` group or permissions are wrong, fix group membership and reboot. (See [Appendix A.6](#appendix-a6---add-yourself-to-the-docker-group) and [Appendix A.7](#appendix-a7---log-out-or-reboot-to-apply-group-change)).

------

### ✅ Step A.8.3 — Check for Conflicts with Podman or rootless Docker

Run:

```bash
which podman
```

If installed, remove it:

```bash
sudo apt remove podman
```

Also inspect:

```bash
ps aux | grep docker
```

If you see processes like `dockerd-rootless.sh`, kill them and reboot.

------

🧭 These steps usually resolve lingering or invisible Docker failures caused by permission conflicts, alternative runtimes, or socket issues.

If problems persist, re-run full steps from [Step 2](#2-remove-broken-or-partial-installs) to [Step 5](#5-confirm-the-installation).

#### **Research specific errors**

Use the exact output of any error message to search:

- Docker Forums: https://forums.docker.com

- Stack Overflow: https://stackoverflow.com

- Reddit r/docker: https://www.reddit.com/r/docker/

- Solana Discord: https://discord.com/invite/solana

  

  #### 🔚 **Final Advice**

Beargrease requires Docker to start, pull images, and launch containers. If your system can't do that --- Beargrease cannot proceed.



#### **🧭 You may need to:**

-  Consult your system administrator or IT support.

- Reinstall your operating system's container subsystem.

- Move to a clean development environment (e.g., virtual machine or cloud instance).


Once Docker is working normally, return to the installation steps and resume.

#### 👍 **We want you to succeed** --- and we're cheering for you!



## Appendix A.9 — `docker --version` Errors

If `docker --version` fails or returns an error, it usually means that Docker was not installed properly or your system is still referencing an older, broken installation (such as `docker.io`).

------

### 🔍 Common Error Messages

```
docker: command not found
```

This means Docker is not installed or is not on your PATH.

```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

This usually means Docker is installed but not started, or your user is not part of the `docker` group.

------

### ✅ Fix Instructions

#### 1. Confirm whether Docker is actually installed

```bash
which docker
```

- If it returns nothing: Docker is not installed or not on your path.
- If it returns a path like `/usr/bin/docker` or `/usr/local/bin/docker`, Docker may be present but still broken.

#### 2. Check if the version is working

```bash
docker --version
```

If this fails, uninstall any old or broken Docker installation before continuing.

#### 3. Remove legacy or broken installations

Remove packages that may be blocking the proper install:

```bash
sudo apt remove --purge docker docker-engine docker.io containerd runc
sudo apt autoremove
```

> 📌 `docker.io` is **not** the official Docker package — avoid reinstalling it unless you have a specific reason.

#### 4. Reinstall Docker using the official instructions

Return to the main [Step 3: Install Docker Using `apt`](#step-3-install-docker-using-apt) section of this guide and **reinstall using Docker’s official repository**, not the `docker.io` package.

If you already followed those steps but are still seeing problems, return to [Appendix A.4 — Common Errors After Starting Docker](#appendix-a4---common-errors-after-starting-docker) to continue troubleshooting.

---



### Appendix A.10 — Docker Installation on macOS

This appendix provides detailed, step-by-step instructions for installing Docker on macOS, including first-run expectations and common permission prompts. If you are on Linux, return to the main [Docker Installation (Linux)](#docker-installation-linux) section.

------



### 🧭 Notes for macOS Developers

Beargrease works via the same `docker compose` commands and shell scripts as on Linux. File paths,however, may differ slightly. If using Beargrease in CI or shell mode, test with a small project first to confirm local compatibility.

---



### ✅ Step 1: Download Docker Desktop

➤ **Go to the official download page:**
 https://www.docker.com/products/docker-desktop/

🧭 Docker will auto-detect your OS and offer the macOS `.dmg` file. If not, scroll down and choose the correct version for your system:

- **Apple Silicon (M1, M2, M3 chips)**: Choose the Apple chip version
- **Intel Mac**: Choose the Intel chip version

> 🧪 You can confirm your Mac’s chip type by selecting ** → About This Mac**

------

### ✅ Step 2: Install Docker Desktop

1. **Open the `.dmg` file** you downloaded
2. **Drag the Docker icon into your `Applications` folder** when prompted
3. **Launch Docker Desktop** from `Applications` or Spotlight (`⌘ + Space`, then type `Docker`)

> ⌛ The first time Docker runs, it may take several seconds to initialize and prompt you to grant permissions.

------

### ✅ Step 3: Handle Permission Requests

When launching Docker Desktop for the first time:

- You may be asked to **enter your macOS password** to approve privileged actions
- You may be prompted to allow **system extensions** (for virtualization support). If so:

➤ Go to **System Settings → Privacy & Security**
 ➤ Look for a message like **“System software from Docker was blocked”**
 ➤ Click **Allow**

> 🔁 You may need to **restart your Mac** after allowing extensions.

------

### ✅ Step 4: Confirm Docker is Installed and Running

After Docker finishes starting:

➤ Open a terminal and run:

```bash
docker --version
```

👀 **Expected output:**b

```
Docker version 26.1.3, build 6f5f45b
```

➤ Also try:

```bash
docker ps
```

👀 **Expected output:**

```
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
```

✅ If both commands return without errors, Docker is working correctly on your system.

------

### ✅ Step 5: Optional — Disable Autostart

If you do not want Docker Desktop to launch on every reboot:

➤ Go to **Docker Desktop → Settings → General**
 ➤ Uncheck **“Start Docker Desktop when you log in”**

------

### ✅ If Problems Occur

🧪 **See [Appendix A.9 — `docker --version` Errors](#appendix-a9---docker---version-errors)**

If you see errors like `command not found`, Docker not running, or permission denied:

- Ensure Docker Desktop is actually running in the background
- Reboot if necessary
- Re-run `docker --version` and `docker ps`
- If problems persist, consult Docker’s macOS support pages or reinstall

------

### Appendix A.10.3 — macOS Troubleshooting

If `docker --version` or `docker ps` failed to return expected results, this section helps diagnose and resolve the most common macOS-specific issues.

------

#### ❌ **Error: `docker: command not found`**

🤔 This usually means Docker Desktop is not fully installed, or it has not been launched.

🔧 **Fix:**

- Confirm Docker Desktop is installed in `/Applications`
- Launch **Docker Desktop** manually (search using Spotlight or open from Launchpad)
- Wait until the **whale icon** appears in the top menu bar (this indicates Docker is running)

------

#### ❌ **Error: Cannot connect to the Docker daemon**

🤔 Docker is not running yet, or system permissions are blocking the daemon.

🔧 **Fix:**

- Ensure Docker Desktop is **running** (whale icon visible)
- Restart Docker Desktop from the menu bar icon
- Disable VPN or antivirus software that may block local ports
- Reboot your Mac and try again

------

#### ❌ **Docker commands hang or timeout**

🤔 This may indicate issues with macOS system extensions or virtualization.

🔧 **Fix:**

- Open **System Settings → Privacy & Security**
- Look for a warning like **“System software from Docker was blocked”**
- Click **Allow** and reboot
- On Intel Macs, ensure virtualization is enabled (BIOS or bootloader settings if running virtualized)

------

### ✅ You're Done!

If the following work correctly:

- Docker Desktop is **installed and running**
- `docker --version` returns expected version info
- `docker ps` displays a container table (even if empty)

✅ Then Docker is correctly installed and ready for Beargrease.

------

🧭 **macOS Users Note:**

- You can **skip** Linux-only steps like `sudo`, `usermod`, or `systemctl`
- You do **not** need to add yourself to the Docker group on macOS

------

🔗 **Related Appendices:**

- 🧪 [Appendix A.9 — `docker --version` Errors](#appendix-a9---docker---version-errors)
- 🧪 [Appendix A.2 — Clean Up Orphan Containers](#appendix-a2---clean-up-orphan-containers)

---



## **Appendix A.11 – Docker Installation and Troubleshooting on WSL**

Beargrease supports development on Windows via **WSL (Windows Subsystem for Linux)**, but you must install Docker using **Docker Desktop with WSL 2 integration**. This setup allows your WSL environment to use the Windows Docker daemon as if it were native.

This appendix walks you through the correct installation steps and helps diagnose common issues such as **“Cannot connect to the Docker daemon”**, **permissions problems**, and **WSL integration errors**.

> ⚠️ This guide assumes you are using **WSL 2**, not WSL 1. If you are unsure which version you have, run:
>
> ```bash
> wsl --list --verbose
> ```



### ✅ A.11.1 – Prerequisites for WSL 2 Docker Support

To use Docker with Beargrease in WSL, ensure that the following are true:

- You are running **WSL 2**, not WSL 1
- **Docker Desktop for Windows** is installed
- Docker is configured to **integrate with your WSL distro**
- Your distro appears in Docker Desktop’s list of integrated environments

---



### 🧭 A.11.2 – Check WSL Version and Docker Availability

From PowerShell or CMD:

```bash
wsl --list --verbose
```

Expected output:

```
  NAME                   STATE           VERSION
* Ubuntu                 Running         2
```

> ✅ You must see **VERSION = 2**. If your distro shows **VERSION = 1**, follow Microsoft’s [Upgrade to WSL 2 guide](https://learn.microsoft.com/en-us/windows/wsl/install) before continuing.

Then, inside your WSL shell:

```bash
docker --version
```

Expected output:

```
Docker version 26.1.3, build 26.1.3-0ubuntu1~22.04.1
```

👍 This means the CLI inside WSL is talking to Docker Desktop successfully.

------

### ⚠️ A.11.3 – Fixing “Cannot connect to the Docker daemon” in WSL

If you run `docker ps` or `docker --version` in WSL and get:

```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock
```

this means Docker Desktop is not properly integrated with WSL.

#### 🔧 Fix:

1. Open **Docker Desktop** on Windows
2. Go to **Settings → Resources → WSL Integration**
3. Enable integration for your distro (e.g., “Ubuntu”)
4. Click **Apply & Restart**

Now, back in your WSL shell:

```bash
docker ps
```

Should return:

```
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
```

(Even if empty, that means success.)

------

### 🧭 A.11.4 – Launching Docker Desktop Manually (if needed)

Sometimes Docker Desktop does not auto-start when you reboot Windows.

If `docker ps` hangs in WSL or fails:

1. Open the Windows **Start Menu**
2. Search for and launch **Docker Desktop**
3. Wait for the **whale icon** to appear in the taskbar and stop animating

Then retry:

```bash
docker ps
```

✅ If the output is correct, Docker is working inside WSL.

------

### 🧪 A.11.5 – Testing WSL + Docker + Beargrease Readiness

After completing installation:

➤ **In WSL shell:**

```bash
docker run hello-world
```

Expected result:

```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

✅ If this works, you are ready to use Beargrease inside WSL.

------

### ✅ You're Done!

If:

- `docker --version` works in WSL
- `docker ps` shows a valid container table (even if empty)
- `docker run hello-world` completes successfully

➡️ You can now proceed with the Beargrease Beginner Guide from inside WSL.

> 🧭 You do **not** need to use `sudo` with Docker inside WSL — the CLI runs as your user with access to the shared daemon.
>
> You also do **not** need to run `systemctl`, `usermod`, or `apt install docker.io` — Docker Desktop manages all of this outside WSL.

------

### 🔗 Related Appendices

- 🧪 [Appendix A.9 — docker --version Errors](#appendix-a9---docker---version-errors)
- 🧪 [Appendix A.2 — Clean Up Orphan Containers](#appendix-a2---clean-up-orphan-containers)
- 🧪 [Appendix A.10 — Docker Installation on macOS](#appendix-a10---docker-installation-on-macos) (similar architecture via Docker Desktop)

------



## 🧩 Appendix A.12 — Pop!_OS (System76) Troubleshooting

> **Applies to:** Pop!_OS 22.04+, System76 laptops/desktops, custom kernels like `6.12.10-76061203-generic`

------

### ❗ Common Error Symptoms on Pop!_OS

If you see any of the following errors when installing or running Docker:

```
modprobe: ERROR: could not insert 'iptable_nat': Invalid argument
```

or

```
docker: permission denied while trying to connect to the Docker daemon socket...
```

or

```
E: Package 'linux-modules-extra-6.12.10-76061203-generic' has no installation candidate
```

You are likely running a **System76 kernel** that is missing Docker-required kernel modules — such as `iptable_nat`.

------

### 🧪 Step A.12.1 — Confirm Kernel Version

To check whether you are on a System76-specific kernel, run:

```bash
uname -r
```

Expected output (example):

```
6.12.10-76061203-generic
```

If your kernel contains a long string like `-7606xxxx` or `system76`, you are using a **custom Pop!_OS kernel** that may not include `linux-modules-extra`.

------

### 🧪 Step A.12.2 — Check for Missing Modules Package

Run:

```bash
sudo apt update
sudo apt install linux-modules-extra-$(uname -r)
```

Expected outcome on affected systems:

```
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
E: Package 'linux-modules-extra-6.12.10-76061203-generic' has no installation candidate
```

> ✅ **If you see this error**, it confirms that your current kernel is missing required modules. Docker networking and other functionality may fail.

------

### ✅ Step A.12.3 — Install a Compatible Mainline Kernel

Install a supported, module-complete Ubuntu kernel with:

```bash
sudo apt install linux-image-generic linux-headers-generic
```

You should see something like:

```
The following additional packages will be installed:
  linux-image-6.5.0-41-generic linux-headers-6.5.0-41-generic ...
Do you want to continue? [Y/n]
```

➤ Press `Y` and allow installation to complete.

------

### 🔁 Step A.12.4 — Reboot into New Kernel

Once installed, **you must reboot** to use the new kernel.

Run:

```bash
sudo reboot
```

🧭 Your system will restart and boot into the new kernel by default (assuming no GRUB modifications). If you see your login screen, continue with the next step.

------

### 👣 Step A.12.5 — Confirm Kernel and Docker Work

After reboot, open a terminal and run:

```bash
uname -r
```

Expected output (example):

```
6.5.0-41-generic
```

Now try:

```bash
docker run hello-world
```

Expected:

```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

✅ If you see this, Docker is now fully functional under the mainline Ubuntu kernel.

------

### 🔁 Optional: How to Switch Back to System76 Kernel (via GRUB)

If you want to temporarily boot back into your original Pop!_OS kernel:

1. Reboot your computer.
2. At the boot splash screen, **hold down the `Shift` key** until the GRUB menu appears.
3. Select `Advanced options for Pop!_OS` using arrow keys.
4. Choose the **older** kernel (likely listed with `7606xxxx` or `system76`) from the submenu.
5. Press `Enter` to boot into that kernel.

To verify:

```bash
uname -r
```

It should now match your older Pop!_OS custom kernel version.

------

### 💡 Recommendation

You can switch back and forth using GRUB, but for Beargrease and Docker development, it is best to **stick with the Ubuntu mainline kernel** to avoid missing modules and low-level system integration errors.

------

### 🧭 Still Having Issues?

If `docker run hello-world` still fails:

- See:
  - [Appendix A.4 — Common Errors After Starting Docker](#appendix-a4---common-errors-after-starting-docker)
  - [Appendix A.8 — Investigate Advanced System Conflicts](#appendix-a8---investigate-advanced-system-conflicts)
- Or return to [Step 2 — Remove Partial or Conflicting Installs](#2-remove-partial-or-conflicting-installs)