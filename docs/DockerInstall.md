**Beargrease: Docker Installation Guide\
*A Clean, Transparent Setup for Solana Developers***

**Version:** 1.0\
**Maintained by:** Cabrillo!\
**Contact:** cabrilloweb3\@gmail.com\
**License:** MIT\
**GitHub:** <https://github.com/rgmelvin/beargrease>

This guide walks new users through installing Docker for use with Beargrease --- a script-driven test harness for Solana development. It includes platform-specific guidance, common pitfalls, and troubleshooting tips for Linux, macOS, and WSL environments.

**Introduction**
----------------

Beargrease is a script-based Solana test harness that relies on Docker to simulate a clean validator environment. This installation guide ensures users --- whether on Linux, macOS, or WSL --- can correctly and securely install Docker without falling into common traps like Snap-based packages, permission issues, or broken socket access.

This document is structured to be friendly for new developers while also offering depth and platform-specific instructions. It is intended as a standalone installation reference for teams and individuals preparing to use Beargrease on their projects.

### **General Table of Contents**

(Use this for quick navigation or front matter)



----------------------------- ------
  Section					
  - [Introduction](#introduction)
  - [General Table of Contents](#general-table-of-contents)
  - [Docker Installation (Linux)](#docker-installation-linux)
  - [Appendices](#appendix-a-troubleshooting-for-docker-installation)
----------------------------- ------

### Detailed Table of Contents

(Includes subsections and page-level detail for ease of print/PDF
navigation)

----------------------- ------

#### Docker Installation (Linux)

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
- [Step 5: Confirm the Installation](#5-confirm-the-installation)
  - [5.1: Version Check](#51-confirm-the-docker-version)
  - [5.2: Running Container Table](#52-check-for-running-docker-containers)

#### Appendices: Troubleshooting and Platform-Specific Help

- [Appendix A.1 --- Remove Snap-Based Docker](#a1---remove-snap-based-docker)
- [Appendix A.2 --- Clean Up Orphan Containers](#a2---clean-up-orphan-containers)
- [Appendix A.3 --- Apt Cleanup & Orphan Packages](#a3---apt-cleanup--orphan-packages)
- [Appendix A.4 --- Common Errors After Starting Docker](#a4---common-errors-after-starting-docker)
- [Appendix A.5 --- Check Docker Group Membership](#a5---check-docker-group-membership)
- [Appendix A.6 --- Add Yourself to the Docker Group](#a6---add-yourself-to-the-docker-group)
- [Appendix A.7 --- Log Out or Reboot to Apply Group Change](#a7---log-out-or-reboot-to-apply-group-change)
- [Appendix A.8 --- Investigate Advanced System Conflicts](#a8---investigate-advanced-system-conflicts)
- [Appendix A.9 --- docker --version Errors](#a9---docker---version-errors)
- [Appendix A.10 --- Docker Installation on macOS](#a10---docker-installation-on-macos)

---------------------------------------------------------- ------

# **Docker Installation.**

This guide will help you to install Docker on your Linux system using `apt`. 

(For macOS installation instructions, please see [Appendix A.10](#appendix-a10---docker-installation-on-macos).)



1: Remove Snap-Based Docker
---------------------------

Check if Docker is installed via Snap.

➤ **Run:** 

```bash
snap list docker
```

🧪 **See: [Appendix A.1 --- Remove Snap-Based Docker](#appendix-a1---remove-snap-based-docker)**

If Docker was installed via Snap then follow the instructions in the appendix to remove it cleanly.

🧭 Even if Snap-based Docker is not present, check for old containers:

➤ **Run:** 

```bash
docker ps -a
```

🧪 **See: [Appendix A.2 --- Clean Up Orphan Containers](#appendix-a2---clean-up-orphan-containers)**

Stale containers can interfere with new installations. Prevent this by removing them.



2: Remove Broken or Partial Installs
------------------------------------

Old or partial Docker packages may have been installed during previous attempts. These leftovers can block a clean installation or interfere with system services.



### 🧭 2.1: Remove All Docker-Related Packages

➤ **Run:** 

```bash
sudo apt remove \--purge docker docker-engine docker.io docker-ce docker-ce-cli containerd runc
```

👀 If Docker components were installed via apt, you will see output like:

```bash
The following packages will be REMOVED:
docker-ce docker-ce-cli containerd docker.io runc
After this operation, 319 MB disk space will be freed.
Do you want to continue? \[Y/n\]
```

➤ **Press** Y and allow the removal to complete.

👀 If nothing was installed, you will see:

```bash
Package \'docker.io\' is not installed, so not removed.
...
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
```

🤔 This simply means that no apt-based Docker install was found --- that's okay.



### 🧭 2.2: Clean Up Orphaned Dependencies

➤ **Run:** 

```bash
sudo apt autoremove
```

👀 You may see output like:

```bash
The following packages will be REMOVED:
libslirp0 libnftnl11 \...
After this operation, 35.2 MB disk space will be freed.
Do you want to continue? \[Y/n\]
```

➤ **Press** Y to allow cleanup to complete.

🧪 **See: [Appendix A.3 --- Apt Cleanup & Orphan Packages](#appendix-a3---apt-cleanup--orphan-packages)** 

The appendix provides examples of expected output and clarifies when it is safe to continue.

✅ Once this step is complete, continue to step 3: Install Docker Using `apt`.



3: Install Docker Using `apt`
---------------------------

This step installs Docker using the standard `apt` method --- preferred for compatibility with Beargrease and system-level services like`systemctl`.



### **🧭 3.1: Update Package Lists and Install Docker**

➤ **Run:** 

```bash
sudo apt update
sudo apt install docker.io
```

👀 **You should see output like:**

```bash
The following additional packages will be installed:
containerd runc \...
After this operation, 400 MB of additional disk space will be used.
Do you want to continue? \[Y/n\]
```

➤ **Press** Y and let the installation complete.



### 🧭 3.2: Enable and Start Docker

➤ **Run:** 

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

👀 **You see:** No output.

If everything works, these commands will silently complete and Docker will now be running in the background.

🧪 **See: [Appendix A.4 --- Common Errors After Starting Docker](#appendix-a4---common-errors-after-starting-docker)**

If you encounter any error messages (e.g. `Unit not found`, `Job failed`, or bridge network issues), consult the appendix to diagnose and resolve them.

✅ Once you've installed and started Docker, continue to step**4: Add Yourself to the Docker Group**



**4: Add Yourself to the Docker Group**
---------------------------------------

By default, only users in the docker group can run Docker without `sudo`. To allow Beargrease scripts to work properly, your user must be added to that group.



### 🧭 4.1: Add Your User to the Docker Group

➤ **Run:** 

```bash
sudo usermod -aG docker \$USER
```

🤔 This command appends your current user to the docker group. However, group changes don't take effect immediately.



### 🧭 4.2: Log Out and Log Back In

🔁 You **must** log out of all terminal sessions and log back in for group changes to take effect. Alternatively, a full reboot is the surest way to ensure that group changes will take effect.



### 🧭 Step 4.3: Confirm Docker Group Membership

After logging back in**,**

➤ **run:** 

```
groups
```

👀 **You should see output like:**

```bash
adm sudo docker libvirt
```

👍 This means your user is now a member of the docker group.**These appendices explain how to verify success and what to do if it didn't work:**

🧪 **See:** 

[Appendix A.5 --- Check Docker Group Membership](#appendix-a5---check-docker-group-membership)

[Appendix A.6 --- Add Yourself to the Docker Group](#appendix-a6---add-yourself-to-the-docker-group)

[Appendix A.7 --- Log Out or Reboot to Apply Group Change](#appendix-a7---log-out-or-reboot-to-apply-group-change)

✅ Once you've confirmed that you are in the docker group, continue to Step **5: Confirm the Installation**.



## **5: Confirm the Installation**

This final step verifies that Docker is installed correctly and that your user can access it without `sudo`. If this step fails, Beargrease
will not function properly.

### 🧭 Step 5.1: Confirm the Docker Version

➤ Run: 

```bash
docker \--version
```

👀 **Expected output** (yours may differ slightly)**:**

```bash
Docker version 26.1.3, build 26.1.3-0ubuntu1\~22.04.1
```

👍 **Success:** Docker is installed and the CLI is accessible.

🧪 **See:** [Appendix A.9 --- docker --version Errors](#appendix-a9---docker---version-errors)

If you get any errors instead of a version string, consult the appendix.



### 🧭 5.2: Check for Running Docker Containers

➤ **Run:** 

```bash
docker ps
```

👀 **Expected output:** Table headers with no entries.

```
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
```

🤔 This output is empty by default --- that's good. It means Docker is running and no containers are currently active.

✅ If both commands work correctly, Docker is fully installed and operational.

➡️ You're now ready to **begin using Beargrease** or continue to the**Beargrease Beginner Guide.**



# **Appendix A: Troubleshooting for Docker Installation.**



## **A.1 - Remove Snap-based Docker.**

This appendix explains how to identify and remove Docker if it was installed via Snap, which is not compatible with Beargrease.

### 🧭 **Step 1: Check for Snap-based Docker**

➤ **Run:** 

```bash
snap list docker
```



👀 **Possible Output 1:**

```bash
Command \'snap\' not found, but can be installed with:
sudo apt install snapd
```

🤔 **Meaning:** Your system does not use Snap at all.

🔁 **Skip to:** [Appendix A.2 --- Clean Up Orphan Containers](#appendix-a2---clean-up-orphan-containers).



👀 **Possible Output 2:**

```bash
No snaps are installed yet. Try \'snap install helloworld\.
```

\- or -

```bash
error: no matching snaps installed
```

🤔 **Meaning:** Snap is present but Docker was not installed with it.

🔁 **Skip to:** [Appendix A.2 --- Clean Up Orphan Containers](#appendix-a2---clean-up-orphan-containers)



👀 **Possible Output 3:**

```bash
Name Version Rev Tracking Publisher Notes
docker 20.10.x \... latest/stable canonical✓ -
```

🤔 **Meaning:** Docker is installed via Snap. This can cause permission errors and prevents systemd integration required by Beargrease.

➡️ **Proceed to:** Step 2: Remove Snap Docker.



### 🔧 **Step 2: Remove Snap Docker**

➤ **Run:** 

```
sudo snap remove docker
```



### 🧭 **Step 3: Confirm Removal**

➤ **Run:** 

```bash
snap list docker
```

👀 **Expected Output:** 

```bash
error: no matching snaps installed
```

👍 **Success:** The Snap version of Docker has been removed.

✅ **You may now continue** with **[Appendix A.2 --- Clean Up Orphan Containers](#appendix-a2---clean-up-orphan-containers)**

 before proceeding to Step 2 of the installation guide.



## **A.2 - Clean Up Orphan Containers.**

Old or exited Docker containers can interfere with fresh Docker installations or Beargrease test runs. This appendix helps you identify and safely remove them.



### 🧭 **Step 1:** **List All Containers (Active and Inactive)**

➤ **Run:** 

```bash
docker ps -a
```



👀 **Expected Output** (No containers, table headers only):

```
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAME
```

👍 **Success:** There are no orphan containers on your system.

➡️ You may return to **Docker Installation** and proceed to the next step**.**



👀 **Expected Output** (Containers present):

```bash
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
abc123def456 solanalabs/solana \"solana-test-validator\" 10 minutes ago Exited (1) 5 minutes ago beargrease-validator
789ghi012jkl hello-world \"/hello\" 2 hours ago Exited (0) 2 hours ago hopeful\_morse
```

🤔 **Meaning**:

\- `Exited (1)` or `Exited (non-zero)` → failed container or one killed during execution.

\- `Exited (0)` → successful test container (e.g., `hello-world`).

\- `Up` → still running container.

\- Look for any `beargrease-validator` containers that might blockstartup.



### 🔧 **Step 2: Remove Stale Containers**

➤ **Run:** 

```b
docker rm -f beargrease-validator 2\>/dev/null
```

🤔 This will force-remove any validator containers from previous Beargrease runs.



### **🧭 Step 3: Confirm Removal**

➤ **Run:** 

```bash
docker ps -a \| grep beargrease-validator
```



👀 **Expected Output:** (Nothing Returned, no beargrease-validator container)

👍 **Success:** The container was successfully removed.

➡️ Return to **Docker Installation** or continue to the next troubleshooting step.



#### ❌👀 **Output Still Shows a Container?**

Try:

➤ **Run:** 

```bash
sudo docker rm -f beargrease-validator
```

Or restart Docker:

➤ **Run:** 

```bash
sudo systemctl restart docker
docker rm -f beargrease-validator
```

Then re-check:

➤ **Run:** 

```bash
docker ps -a \| grep beargrease-validator
```

🔥 If the container still won\'t clear, and the validator won't start,

➡️ Proceed to **[Appendix A.4 --- Common Errors After Starting Docker](#appendix-a4---common-errors-after-starting-docker)**.



## **A.3 --- Apt Cleanup & Orphan Packages**

This appendix helps you safely remove old Docker-related packages and clean up unnecessary dependencies.



### **🧭 Step 1: Remove Docker Packages via apt**

➤ **Run:** 

```bash
sudo apt remove \--purge docker docker-engine docker.io docker-ce docker-ce-cli containerd runc
```



👀 **Expected Output** (If Docker Packages Are Present):

```bash
The following packages will be REMOVED:
docker-ce docker-ce-cli containerd docker.io runc
After this operation, 319 MB disk space will be freed.
Do you want to continue? \[Y/n\]
```

➤ **Press** Y and let the process complete.

👀 You should then see:

```bash
Removing docker-ce \...
Removing containerd \...
Purging configuration files for docker-ce \...
...
```

👍 **Success:** All Docker-related packages were removed cleanly.



👀 **Expected Output** (If Docker Is Not Installed):

```bash
Package \'docker.io\' is not installed, so not removed.
Package \'containerd\' is not installed, so not removed.
...
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
```

🤔 **Meaning:** There is nothing to remove --- that\'s okay. You can continue.



### 🧭 **Step 2: Clean Up Orphaned Dependencies.**

After removing packages:

➤ **Run:** 

```bash
sudo apt autoremove
```

👀 **Example Output** (When Clean-Up Needed):

```bash
The following packages will be REMOVED:
libslirp0 libnftnl11 \...
After this operation, 35.2 MB disk space will be freed.
Do you want to continue? \[Y/n\]
```

➤ **Press** Y and let the process finish.

👍 **Success:** Orphaned or unused packages were cleaned up.

👀 **Example Output** (When Nothing to Remove):

```bash
Reading package lists\... Done
Building dependency tree\... Done
Reading state information\... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
```

🤔 **Meaning:** Nothing needed to be removed --- that's fine.

✅ When finished, return to **step 3** of the **Docker Installation** guide: **Install Docker Using** `apt`



## **A.4 --- Common Errors After Starting Docker**

This appendix helps troubleshoot issues that can occur when enabling or starting the Docker service after installation.

🧭 **When you run:**

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

You may encounter errors related to misconfiguration, Snap conflicts, or broken service files.



❌ **Error 1: Unit Not Found**

👀 **You see:** 

```bash
Failed to start docker.service: Unit docker.service not found.
```

🤔 **Meaning:** Docker may not have been installed correctly, or the system did not register the service.

🔧 **Fix:** ➤ **Run:** 

```bash
sudo apt install \--reinstall docker.io
```

🔁 **Then retry:**

➤ **Run:** 

```bash
sudo systemctl start docker
```



❌ E**rror 2: Job Failed** **--- See status /** `journalctl`

👀 **You see:**

```bash
Job for docker.service failed because the control process exited with error code.
See \"systemctl status docker.service\" and \"journalctl xe\" for details.
```

🤔 **Meaning:** The Docker daemon failed to start. Often due to:

- leftover Snap conflicts

- broken config files in `/etc/docker/`

- system permission issues

  

  🔧 **Fix:** ➤ **Run:** 

```bash
sudo systemctl status docker
```

🧭 **Look for messages such as:**

```bash
failed to start daemon: error initializing graphdriver
```

```bash
permission denied
```

```bash
overlay not supported
```

These indicate problems with the Docker runtime or underlying filesystem. Try rebooting, then rerun the start command.



❌ **Error 3: Network Controller or Bridge Error**

👀 You see:

```
Error starting daemon: Error initializing network controller: Error
creating default \"bridge\" network: could not create

bridge network\...
```

🤔 **Meaning:** Docker's networking backend is being blocked or misconfigured.

🔧 **Fix:** ➤ **Run:** 

```bash
sudo lsof -i :2375
```

This checks whether another process is using Docker\'s default API port.

🔥 If none of the above resolve the issue,

➡️ Proceed to [Appendix A.8 --- Investigate Advanced System Conflicts](#appendix-a8---investigate-advanced-system-conflicts)



## **A.5 --- Check Docker Group Membership**

This appendix helps verify whether your user has been successfully added to the docker group.



### **🧭 Step 1: Run the** groups **Command**

➤ **Run:** 

```bash
groups
```

This will list all groups your current user belongs to.



👀 **Expected Output** (something like)**:**

```bash
adm sudo docker libvirt
```

🤔 **Meaning**: Your user is now a member of the docker group. You should be able to run Docker commands without sudo, and Beargrease scripts should work without permission errors.



❌ **Problem Output:** Docker Group Missing

```bash
adm sudo libvirt
```

🤔 **Meaning:** Your user is **not** in the docker group.

🔧 **Fix:** 🧪 **Proceed to: [Appendix A.6 --- Add Yourself to the Docker Group](#appendix-a6---add-yourself-to-the-docker-group)**

✅ Once your group membership includes docker, you may return to the step
that brought you here (*e.g.*, Step 4.3) and continue.



## **A.6 --- Add Yourself to the Docker Group**

If your user is not part of the docker group, you won't be able to run Docker commands without sudo. Beargrease will fail if permissions are blocked.



### **🧭 Step 1: Add Your User to the Group**

➤ **Run:** 

```bash
sudo usermod -aG docker \$USER
```

🤔 **Meaning:** This command adds your current user to the docker group.



### **🔁 Step 2: Apply Group Changes**

Group changes won't apply until you completely log out and back in --- or reboot.

🧪 **See: [Appendix A.7 --- Log Out or Reboot to Apply Group Change](#appendix-a7---log-out-or-reboot-to-apply-group-change)**



✅ Once you've logged back in, continue to:

➤ **[Appendix A.5 --- Check Docker Group Membership](#appendix-a5---check-docker-group-membership)**

to verify that the change took effect.



## **A.7 --- Log Out or Reboot to Apply Group Change**

Group membership changes (like adding yourself to the docker group) do not take effect until you fully log out and back in.



### **🧭 Step 1: Log Out or Reboot**

You must **log out of all terminal sessions** or **reboot** your computer to activate the group membership.

🤔 If you skip this step, docker commands may still fail with "`permission denied`\" errors --- even though the group change appears correct.



### **🔁 Step 2: Re-Check Membership**

After logging back in:

➤ **Run:** 

```bash
groups
```

👀 You should now see:

```bash
adm sudo docker libvirt
```

👍 **Success:** Your user is now fully in the docker group.

✅ **Continue to:** **[Appendix A.5 --- Check Docker Group Membership](#appendix-a5---check-docker-group-membership)** to verify, or return to the installation guide step that referred you here.



### **A.8 --- Investigate Advanced System Conflicts**

If Docker still fails to start or function correctly despite following all prior instructions, your system may have deeper configuration issues.



### **🧭 Possible Underlying Problems**

#### 🤔 **These may include:**

- AppArmor or SELinux restricting Docker daemon access.

- Custom or broken /etc/docker/daemon.json settings.

- Filesystem incompatibility with Docker storage drivers.

- Kernel module issues (e.g., missing overlay support).

-  Non-standard shell environments blocking permissions.

- Firewall or antivirus software interfering with local ports or sockets.

- A prior Snap install of Docker leaving misconfigured remnants.

  

  ### **🔧 Diagnostic Suggestions**

#### **1. Try launching the validator manually**

➤ **Run:** 

```bash
solana-test-validator
```

If this fails immediately, it may point to a conflict with your Docker daemon or container runtime.



#### **2. Run an isolated Docker container**

➤ **Run:** 

```bash
docker run -it \--rm solanalabs/solana solana-test-validator
```

👀 This bypasses Beargrease scripts and lets you check whether Docker is fundamentally capable of launching the required validator image.



#### **3. Check Docker service logs**

➤ **Run:** 

```bash
sudo journalctl -xe \| grep docker
```

👀 Look for permission denied, overlay, graphdriver, or bridge errors. These can help you determine which layer is blocking Docker.



#### **4. Confirm kernel modules and storage drivers**

➤ **Run:**

```bash
 lsmod \| grep overlay
 docker info \| grep -i storage
```

These help confirm that Docker can mount container file systems correctly.



#### **5. Research specific errors**

Use the exact output of any error message to search:

- Docker Forums: https://forums.docker.com

- Stack Overflow: https://stackoverflow.com

- Reddit r/docker: https://www.reddit.com/r/docker/

- Solana Discord: https://discord.com/invite/solana

  

  #### 🔚 **Final Advice**

Beargrease requires Docker to start, pull images, and launch containers. If your system can't do that --- Beargrease cannot proceed.



#### **🧭 You may:**

-  Consult your system administrator or IT support.

- Reinstall your operating system's container subsystem.

- Move to a clean development environment (e.g., virtual machine or cloud instance).


Once Docker is working normally, return to the installation steps and resume.

#### 👍 **We want you to succeed** --- and we're cheering for you!



## **A.9 ---** docker \--version **Errors**

If running docker \--version returns an error or unexpected output, it usually means Docker is not correctly installed or accessible.



### ❌ **Case 1: Command Not Found**

👀 **You see:** 

```bash
docker: command not found
```

🤔 **Meaning:** Docker is not installed or the binary is not in your `PATH`.

🔧 **Fix:** ➤ **Run:** 

```bash
sudo apt install \--reinstall docker.io
```

🔁 Then try again:

➤ **Run:** 

```bash
docker \--version
```



### **❌ Case 2: Dash Typo (Copy-Paste Error)**

**You typed:** 

```bash
docker ---version
```

(Using an en-dash -- instead of double hyphens \--)

👀 **You may see:**

```bash
docker: invalid option -- '--'
See 'docker --help'.
```

🤔 **Meaning:** A non-standard dash was used.

🔧 **Fix:** ➤ **Use the correct command:**

```bash
docker --version
```



### **❌ Case 3: Removed or Missing Docker**

👀 **You see:**



```bash
The program 'docker' is currently not installed. You can install it
by typing: sudo apt install docker.io
```

🤔 **Meaning:** Docker was removed or never installed.

🔧 **Fix:** ➤ **Run:**

```bash
sudo apt install docker.io
```

🔥 If errors persist even after reinstalling, proceed to:

🧪 **Appendix A.8 --- Investigate Advanced System Conflicts**



## **A.10 --- Docker Installation on macOS**

This appendix provides a step-by-step guide for macOS users who want to install Docker to use Beargrease. It also includes verification steps and macOS-specific troubleshooting advice. You should follow this appendix**instead of Steps 1--5 in the Linux Docker Installation guide**.



### **🧭 A.10.1 --- Install Docker Desktop for macOS**

🔗 Visit the official Docker Desktop for Mac installation page:

<https://docs.docker.com/desktop/mac/install/>

➤ Download the installer for your architecture:

-   Apple Silicon (M1, M2): download the Apple chip version.

-   Intel Macs: download the Intel chip version.

➤ Open the .dmg file and follow the installation prompts:

-   Drag Docker into /Applications

-   Launch Docker Desktop from the Applications folder

💡 If prompted:

-   Grant permission for **system extensions**

-   Approve **network access**

-   Install **Rosetta** (for Apple Silicon) if requested

-   

### **🧪 A.10.2 --- Verify Docker Installation**

Open **Terminal** and:

➤ **Run:** 

```bash
docker \--version
```

👀 Expected output:

```bash
Docker version 26.1.x, build abc123
```

➤ **Run:** 

```bash
docker ps
```

👀 Expected output:

```bash
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
```

✅ If both commands work, Docker is installed correctly.

🔁 You may now return to the **Beargrease Beginner Guide** and proceed with Beargrease setup.

**⚠️ If either of the above commands fails, Proceed to A.10.3 Troubleshooting.**



### **⚠️ A.10.3 --- macOS Troubleshooting**

If either of the above commands failed, try the following:



#### ❌ Error: docker: command not found

🤔 Docker Desktop may not have been installed correctly or theapplication wasn't launched.

🔧 **Fix**:

-   Ensure Docker Desktop is installed in /Applications.

-   Launch **Docker Desktop** manually (search in Spotlight).

- Wait until the whale icon appears in your top menu bar.

  

#### ❌ Error: Cannot connect to the Docker daemon

🤔 Docker Desktop hasn't fully started or there's a permission problem.

🔧 **Fix**:

-   Check for firewall, antivirus, or VPN software that may block local network ports.
    
-   Restart Docker Desktop.

- Reboot your machine if problems persist.

  

#### ❌ Docker commands hang or time out

🤔 This may indicate a problem with virtualization or system permissions.

🔧 **Fix**:

-   Open **System Settings \> Privacy & Security** and verify that Docker has permission to run system extensions.
    
-   Restart your computer.

- Ensure **Virtualization** is enabled on Intel Macs (check BIOS if running in Bootcamp or VM).

  

### **✅ You're Done!**

If you've verified:

-   Docker Desktop is running.

-   docker \--version returns expected output.

- docker ps shows a container table (even if empty).

  

➡️ Then you\'re ready to use Beargrease!



🧭 When following the rest of the Beargrease guide:

-   You may skip Linux-specific steps like sudo, usermod, or systemctl.

-   You do **not** need to add yourself to the Docker group on macOS.

-   

**🔗 Related Appendices**

🧪 **[Appendix A.9 --- docker --version Errors](#appendix-a9---docker---version-errors)** (if the CLI command fails)

**[Appendix A.2 --- Clean Up Orphan Containers](#appendix-a2---clean-up-orphan-containers)** (if leftover containers block validator startup)
