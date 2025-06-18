# 🐻 Beargrease Beginner Guide (Unified for Local and CI Use)

> Version: `v1.1.0` • Maintained by: [Cabrillo! Labs](https://github.com/rgmelvin/beargrease-by-cabrillo)  
> 
> This is the canonical beginner guide for Beargrease v1.1.0.  
> If you are using an earlier version, consult the [archive](./archive/).


# Part I: Running Beargrease with Confidence

This first part of the guide walks you through the complete test flow from a clean machine to a passing run. You will install your toolchain, configure your directories, run your test harness in both Local and CI modes, and learn how Beargrease selects and executes your test suite. Every section builds on the last—giving you a working, debuggable, and repeatable test setup that you fully understand.

Even if you are new to Solana, CI, or Anchor, this part of the guide is designed to support you without shortcuts or assumptions. We do not skip steps. We do not hide complexity. Instead, we explain the moving parts, show you the scripts, and prepare you for confident, repeatable usage.

You are not learning “how to use Beargrease.” You are learning how to test correctly—and Beargrease is the tool that lets you do it.

---

📦 **What This Section Covers**

1. [**Introduction to Beargrease**](#1-introduction-to-beargrease)
2. [**Modes of Operation: Local and CI**](#2-modes-of-operation-local:-and-ci)
3. [**Environment Setup**](#3-envronment-setup)
4. [**Directory Layout and Project Prparation**](#4-directory-layout-and-project-preparation)
5. [**Running Beargrease**](#5-running-beargrease)
6. [**Selecting and Controlling the Test Runner**](#6-selecting-and-controlling-the-test-runner)
7. [**You've Run Your First Tests**](#7-you've-run-your-first-tests)
8. [**Configuring Beargrease for GitHub CI**](#8-configuring-beargrease-for-github-ci)
9. [**Saving Logs and Outputs as Artifacts**](#9-saving-logs-and-outputs-as-artifacts)
10. [**You Now Control CI**](#10-you-now-control-ci)
11. [**Didn't Get That Output? Check These Appendices**](#11-didnt-get-that-output-check-these-appendices)



# 1. Introduction to Beargrease

Software should teach as it runs. Tools should not conceal their mechanisms under layers of abstraction, but instead invite the developer to understand them—line by line, step by step. Beargrease is a test harness for Solana smart contract development, but more than that, it is an **ideological departure** from the prevailing culture of opaque automation.

Developed by **Cabrillo! Labs**, Beargrease provides a transparent, script-based workflow for building, deploying, and testing Solana Anchor programs. Whether you are operating on your local machine or integrating tests into a CI pipeline, Beargrease exposes its full process: the validator lifecycle, the wallet funding logic, the test execution path, and the cleanup sequence are all yours to inspect and control.

This guide is written for developers who want to **understand what is happening**, not just confirm that a test passed. You will not be asked to run black-box commands. Instead, you will gain access to every layer of Beargrease’s structure—from shell scripts and test runners to CI workflows and validator state. You will be shown the exact files, logs, and system behaviors that matter. In return, Beargrease asks only one thing: pay attention. If something breaks, we want you to know why. If something succeeds, we want you to understand how.

This document replaces and unifies two previously distinct guides:

- **Local Mode**, which described how to manually run Beargrease from within a test project.
- **Directory Checkout Mode**, which described how to run Beargrease in CI via GitHub Actions.

The new structure treats these not as two separate tools, but as two expressions of a single architecture. Beargrease detects its environment and adapts accordingly. This guide does the same.

------

# 2. Modes of Operation: Local and CI

Beargrease operates in one of two modes: **Local Mode** and **CI Mode**. These modes are not separate products—they are perspectives on the same sequence of events, differing only in how and where they are initiated.

In **Local Mode**, you run Beargrease manually from within a terminal on your own machine. The scripts live inside your project directory. You clone the Beargrease repository, copy its script suite into your test project (usually into `scripts/beargrease/`), and run them directly. The validator starts in Docker, a funded test wallet is created or reused, and your test suite executes in place. This is the right mode for experimentation, development, or working offline.

In **CI Mode**, Beargrease is triggered by a GitHub Actions workflow. You do not copy any scripts. Instead, the workflow checks out the Beargrease repository as a sibling directory alongside your project. The test wallet is injected securely via a GitHub Secret. The validator, funding, program deployment, and test execution all happen inside a clean containerized CI environment. This is the mode for automation, validation of pull requests, and ensuring that your codebase remains continuously testable.

These modes share the same heart. The same `run-tests.sh` script is executed. The same validator is started. The same sequence of steps—fund, build, deploy, test—is followed. What changes is the context. Beargrease detects this context through its environment variables and path assumptions, and adapts accordingly. You, as the developer, are never forced to maintain two separate toolchains.

This guide will follow a single linear narrative, branching only where necessary to accommodate the differences between local and CI workflows. You will not be asked to choose a path and ignore the rest. You will be shown both, and you will understand both.

---

# 3. Environment Setup

Before running Beargrease—whether on your local machine or in a CI pipeline—you must install and verify a handful of tools. These tools are not optional; they are the foundation of a reliable Solana test harness. If any of these components is missing or misconfigured, Beargrease will not run, and the error messages you see will point you directly to the root cause. This section guides you through installing and validating each dependency, with clear instructions and minimal assumptions.

1. **Docker** (for running the Solana validator)
2. **Solana CLI** (for wallet management and program interactions)
3. **Anchor CLI** (for building and testing Anchor programs)
4. **jq** (for parsing and updating JSON and TOML files)

Beargrease does not attempt to work around missing tools or create them on your behalf. Instead, it relies on each tool to be installed correctly so that every step in the test cycle is visible and understandable. Follow these instructions carefully, and verify each installation before proceeding.

---

### Docker: Required for the Validator

Beargrease launches a dedicated Solana validator inside Docker. This isolates your tests from external dependencies and ensures that validator logs, accounts, and program state remain clean between runs.

Install Docker using the official instructions for your platform:
 📎 https://docs.docker.com/get-docker/

If you are using Linux (especially Pop!_OS), we strongly recommend following our dedicated [Docker Installation Guide](docs/DockerInstall.md), which avoids Snap-based installations and addresses common issues with system permissions and kernel modules.

After installation, verify Docker is working:

```bash
docker --version
docker run hello-world
```

You should see two things:

- A version string like `Docker version 26.1.3, build abcdef...`
- A greeting that begins `Hello from Docker!`

If either of these fail, resolve the issue before proceeding. Beargrease relies on Docker from the very first script. Our [Docker Installation Guide](docs/DockerInstall.md), provides some guidance.

---

### Solana CLI: Managing Local Accounts and Validator Interactions

The Solana CLI is required to create keypairs, request airdrops, deploy programs, and query on-chain state. Beargrease invokes these commands under the hood, so the CLI must be installed and accessible. After installation, you must ensure your shell can find the `solana` executable.

#### 1. Install the Solana CLI

Run the Anza installer script:

```bash
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
```

When installation finishes, the script will display a message similar to:

```
pgsqlCopyEditPlease update your PATH environment variable by adding the following line:
export PATH="/home/rgmelvin/.local/share/solana/install/active_release/bin:$PATH"
```

📌 **Important: Add Solana to Your PATH**

1. **Immediate use**
    Copy and paste the export line into your active terminal session:

   ```bash
   export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
   ```

   Doing this will let you run `solana` right away without restarting your shell.

2. **Permanent update**
    To ensure the CLI remains available in future sessions, append the same line to your shell profile:

   - **Bash** users:

     ```bash
     echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
     ```

   - **Zsh** users:

     ```
     echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.zshrc
     ```

3. **Restart your terminal**
    Close and reopen your terminal (or source your profile) to confirm that `solana` is on your PATH.

#### 2. Verify the Installation

With your PATH updated, run:

```bash
solana --version
```

You should see an output like:

```
solana-cli 2.1.21 (src:8a085eeb; feat:1416569292,client:Agave)
```

If the command is not found, your PATH is still not configured correctly. Return to the installation message, copy the export line, and apply it to your shell. Beargrease depends on this CLI—without it, wallet creation and program deployment will fail.

---

### Anchor CLI: Building and Testing Programs

Beargrease is designed around Anchor-based development. To compile, deploy, and test your smart contracts, you need the Anchor CLI. This toolchain sits on top of the Solana CLI and the Rust environment, so ensure Rust and Cargo are already available on your system.

#### 1. Install Anchor

Use `cargo` (the Rust package manager) to install Anchor from its Git repository:

```bash
cargo install --git https://github.com/coral-xyz/anchor anchor-cli --locked
```

- The `--locked` flag ensures that the version used is consistent with Anchor’s published lockfile, reducing unexpected version mismatches.
- This process may take a few minutes, as it compiles Anchor locally.

#### 2. Verify Anchor

After installation is complete, confirm the version:

```bash
anchor --version
```

Expected output:

```
anchor-cli 0.31.1
```

Beargrease is tested against Anchor CLI v0.31.x. Later versions may work, but if Anchor commands change upstream, you may encounter errors. Pinning to the known-working version in CI (as we will show) helps avoid surprises.

---

### jq: Updating JSON and TOML Without Error

Beargrease uses `jq`—a command-line JSON processor—to extract and inject the deployed program ID into your test configuration files (for example, updating a TypeScript test or an `Anchor.toml`). Rather than reinventing JSON parsing, Beargrease delegates that responsibility to `jq`.

#### 1. Install jq

- **Ubuntu / Debian / Pop!_OS**:

  ```bash
  sudo apt update
  sudo apt install jq
  ```

- **macOS** (Homebrew):

  ```bash
  brew update
  brew install jq
  ```

#### 2. Verify jq

Run:

```bash
jq --version
```

A typical output might be:

```
jq-1.6
```

If `jq` is missing, Beargrease cannot modify program IDs automatically. You would receive a clear error (for example, “command not found: jq”) when running the harness. Installing `jq` fixes this immediately.

---

### CI Tooling Note: Installing Dependencies on GitHub Actions

When Beargrease runs in **CI Mode** (via GitHub Actions), every required tool must be installed in the workflow script itself. This may seem repetitive, but it is intentional: each CI run begins with a fresh Ubuntu virtual machine. If you omit any step, the CI logs will clearly indicate which command was not found or which installation failed.

Typical CI steps look like this:

```yaml
- name: 🧾 Checkout code
  uses: actions/checkout@v3

- name: 🧰 Set up Rust toolchain
  uses: actions-rs/toolchain@v1
  with:
    toolchain: stable
    override: true

- name: ⚓ Install Solana CLI (Anza)
  run: |
    sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
    echo "$HOME/.local/share/solana/install/active_release/bin" >> $GITHUB_PATH

- name: 🚀 Install Anchor CLI
  run: |
    cargo install --git https://github.com/coral-xyz/anchor --tag v0.31.1 anchor-cli --locked
    anchor --version

- name: 🔧 Install jq
  run: |
    sudo apt update
    sudo apt install -y jq
```

Each of these commands is executed afresh on every run, ensuring that CI never relies on hidden state or locally cached dependencies. If any of these steps fail, GitHub Actions will mark the job as failed, and you’ll see exactly which tool or command caused the issue.

Beargrease’s philosophy extends to CI: if something is missing, the harness stops immediately and reports the missing piece. You then fix that piece and re-trigger the workflow. Over time, this creates confidence that the CI environment precisely mirrors a correctly configured local environment.

------

### Summary of Environment Setup

By following these instructions:

1. **Docker** is installed and operational, ready to launch a local validator.
2. **Solana CLI** is installed, on your PATH, and returns a valid version string.
3. **Anchor CLI** is installed via Cargo, with a known working version.
4. **jq** is installed and accessible for JSON/TOML manipulation.
5. **CI Workflows** include explicit installation steps to replicate local conditions.

Once you have completed and verified these steps, proceed to the next section—**Directory Layout and Project Preparation**—knowing that your environment is ready for Beargrease.

---

# 4. Directory Layout and Project Preparation

Beargrease expects a project structure that is both minimal and disciplined. Whether you are using Beargrease in Local Mode or Directory Checkout Mode (CI), the validator, program, and test logic must be arranged in a way that lets the harness locate what it needs without guesswork or side effects.

This section outlines how to prepare your working directory so that Beargrease can function without modification. It is not about personal preference or organizational style. It is about satisfying the test harness with a known-good layout that supports repeatable runs.

------

### Project Root: Where Everything Belongs

We recommend placing your Anchor program and the Beargrease harness under a shared parent directory. This applies to both local and CI workflows. The layout should look similar to this:

```
Projects/
└── cabrillo/
    ├── placebo/                  # Your test project
    └── beargrease-by-cabrillo/  # The Beargrease harness
```

- The `placebo` directory contains your Anchor program, tests, and configuration. (These are examples,`placebo` is our demo project, name the directories as you wish.)
- The `beargrease-by-cabrillo` directory contains the harness scripts that run tests against your program.
- The two directories live **side by side**, not nested within each other.

This layout simplifies both local script execution and relative path resolution inside CI workflows. Beargrease expects to find its working project either in the current directory (Local Mode) or in a sibling directory (CI Mode). You do not need to modify any scripts if you maintain this structure.

------

### Step 1: Clone the Beargrease Harness

If you have not already done so, clone the Beargrease repository:

```bash
cd ~/Projects/cabrillo
git clone https://github.com/rgmelvin/beargrease-by-cabrillo.git
```

You now have access to all Beargrease scripts under:

```bash
~/Projects/cabrillo/beargrease-by-cabrillo/scripts/
```

These scripts include the validator lifecycle (`start-validator.sh`, `shutdown-validator.sh`), funding logic (`fund-wallets.sh`), program ID patching (`update-program-id.sh`), and the master runner (`run-tests.sh`). Do not modify them unless you intend to control the full testing lifecycle manually.

------

### Step 2: Clone or Initialize Your Anchor Project

If you are using Beargrease with the included test project, clone it:

```bash
git clone https://github.com/rgmelvin/placebo.git
```

If you are using Beargrease with your own program, you can initialize it like so:

```bash
anchor init myproject
```

You should now have an Anchor project adjacent to the Beargrease harness. For the remainder of this guide, we will refer to your project as `placebo`, but the name is not important—only the structure.

------

### Step 3: Set Up the `scripts/` Directory (Local Mode Only)

If you are using Beargrease in **Local Mode**, you will copy the test harness scripts into your project directly. From the root of your Anchor project:

```
mkdir -p scripts
cp -r ../beargrease-by-cabrillo/scripts ./scripts/beargrease
chmod +x ./scripts/beargrease/*.sh
```

This creates a `scripts/beargrease/` directory inside your project, which is now self-contained. When you run `./scripts/beargrease/run-tests.sh`, the validator and test harness will execute in place.

If you are using **Directory Checkout Mode (CI)**, you do *not* copy any scripts. The CI workflow will call them directly from the cloned Beargrease repository.

------

### Step 4: Create the `.ledger/wallets/` Directory

Beargrease expects at least one funded wallet to exist at:

```bash
.ledger/wallets/test-user.json
```

This wallet is used to pay for deployments and test transactions. To create it:

```bash
mkdir -p .ledger/wallets
solana-keygen new --outfile .ledger/wallets/test-user.json
```

You will see confirmation that the keypair was written, along with the public address. This file will be automatically detected and funded when you run Beargrease.

If you are working in CI, this wallet must be encoded and passed via GitHub Secrets. That process is described in the CI Wallet section of this guide.

------

### Step 5: Confirm the Final Structure

At this point, your directory layout should look like one of the following:

#### Local Mode:

```
pgsqlCopyEditProjects/
└── cabrillo/
    ├── beargrease-by-cabrillo/
    │   └── scripts/
    └── placebo/
        ├── scripts/
        │   └── beargrease/
        ├── .ledger/
        │   └── wallets/
        │       └── test-user.json
        ├── Anchor.toml
        ├── programs/
        └── tests/
```

#### CI Mode:

```
pgsqlCopyEditProjects/
└── cabrillo/
    ├── beargrease-by-cabrillo/
    │   └── scripts/
    └── placebo/
        ├── .ledger/  ← Used locally only, not required if wallet is injected
        ├── Anchor.toml
        ├── programs/
        ├── tests/
        └── .github/
            └── workflows/
                └── test-with-beargrease.yml
```

No symlinks are required. No deep nesting is expected. This layout will support both local execution and CI runs with no change to the Beargrease harness.

------

Once your project is structured and the wallet created, you are ready to begin a full test cycle. Proceed to the next section: **Running Beargrease**.

---



# 5. Running Beargrease

With your environment configured and your project structure in place, you are now ready to run Beargrease in **Local Mode**.

🧭 **Note:** If you are new to GitHub Actions or CI pipelines, do not worry. This guide includes a dedicated section titled **Configuring Beargrease for GitHub CI** that will walk you through every required step, including writing the workflow file and securely injecting your test wallet. You are not expected to have done this yet.

 What follows is not a demonstration—it is the real thing. This section walks through the first complete test cycle using the Beargrease harness, either in **Local Mode** or in **Directory Checkout Mode for CI**. Both modes run the same scripts. Both modes launch the same validator, fund the same wallet, and test the same program. Only the execution context differs.

This section covers both modes side by side. You are not being asked to choose between them—you are being shown how they behave under different conditions, so you can switch between them with confidence.



### Overview of the Test Flow

Beargrease does not wrap or reimplement Solana’s toolchain. It orchestrates it. When you run the harness, it performs the following sequence, visibly and in order:

1. Launches a Dockerized `solana-test-validator`
2. Waits for the validator to become healthy
3. Funds each wallet in `.ledger/wallets/` (or its CI equivalent)
4. Builds your Anchor program using `anchor build`
5. Deploys the program using `solana program deploy`
6. Extracts the deployed `programId` and patches it into your test files
7. Detects your test runner and invokes it (Anchor or TypeScript)
8. Shuts down the validator and removes the container

This sequence is visible in your terminal. No part of it is hidden or abstracted. Every command is recorded in the logs. Every failure is traceable. The scripts do not guess. They act.



### Local Mode: Running the Harness by Hand

In Local Mode, you invoke the test harness directly from your Anchor project root. This assumes that you have already copied the Beargrease scripts into `scripts/beargrease/`.

From the root of your project (e.g., `placebo`), run:

```bash
./scripts/beargrease/run-tests.sh
```

You should see output similar to:

```
🐻 Beargrease Version: v1.1.0
🔧 Launching Solana validator container via Docker...
⏳ Waiting for validator to pass healthcheck...
🔐 Funding wallet: .ledger/wallets/test-user.json
📦 Building Anchor program...
🚀 Deploying Anchor program...
🧬 Injecting programId into test files...
🧪 Running TypeScript tests...
✅ Tests complete.
🧹 Shutting down validator container...
```

If your validator fails to start, your wallet is missing, or your test files are not configured correctly, Beargrease will stop and report the failure. The message will not be vague. The logs will not be silent. This is not a guess-and-check system—it is a declared sequence of commands that either succeeds or tells you precisely why it did not.



### CI Mode: Running the Harness in GitHub Actions

In CI Mode, Beargrease is not run manually. Instead, a GitHub Actions workflow takes responsibility for launching the validator, injecting the test wallet, running your build, and executing the test harness automatically. If you are using Directory Checkout Mode, your repository will eventually include a file like:

```bash
.github/workflows/test-with-beargrease.yml
```

This workflow will:

- Check out your Anchor project
- Check out the Beargrease harness as a sibling directory
- Install all required tools (Rust, Solana CLI, Anchor CLI, jq)
- Decode a base64-encoded wallet secret provided as a GitHub Secret
- Run the test harness using `run-tests.sh` from the Beargrease scripts

The CI logs you see in GitHub will mirror the local output almost exactly:

```
🐻 Beargrease Version: v1.1.0
🔧 Launching Solana validator container via Docker...
⏳ Waiting for validator to pass healthcheck...
🔐 Funding injected wallet from $BEARGREASE_WALLET_SECRET
📦 Building Anchor program...
🚀 Deploying Anchor program...
🧬 Injecting programId into test files...
🧪 Running TypeScript tests...
✅ Tests complete.
🧹 Shutting down validator container...
```

You do not need to worry about constructing this workflow by hand just yet. When you are ready to enable CI, refer to the upcoming section:

> **Configuring Beargrease for GitHub CI**
>  (including: `.yml` file, wallet secret, and environment setup)

For now, continue using Beargrease in Local Mode until your test cycles are working reliably. CI Mode will follow naturally from the same architecture.

---

# 6. Selecting and Controlling the Test Runner

Beargrease is designed to be compatible with both Anchor-based Rust tests and TypeScript-based Mocha tests. It does not favor one over the other, and it does not require you to predeclare your test mode in a configuration file. Instead, Beargrease inspects your project and selects the test runner based on what it finds—automatically, but not silently.

This section explains how that detection works, what Beargrease is actually doing behind the scenes, and how to override its decision when you need to take manual control. If your project contains both TypeScript and Rust tests, or if you are debugging a specific subset, you may want to control the test runner explicitly. You are encouraged to do so.

------

### How Beargrease Detects Your Test Runner

By default, Beargrease looks for the following:

- If a `package.json` file is present in the project root, and it contains a `test` script, Beargrease assumes you are using **TypeScript tests** and invokes `yarn test`.
- If no `package.json` is found, or if no recognizable test script exists, Beargrease defaults to **Anchor tests**, invoking `anchor test`.

This logic is implemented in the `run-tests.sh` script and does not rely on any external configuration files. It is entirely transparent and can be changed by editing the script or setting the environment variable described below.

You will see confirmation of the detected runner in the output:

```
🔁 Detected test runner: yarn
🧪 Running TypeScript tests...
```

or

```
🔁 Detected test runner: anchor
🧪 Running Rust tests...
```

If no valid runner can be detected, Beargrease will report the error and exit.

------

### How to Override the Detection

You can bypass auto-detection and declare your desired test runner explicitly by setting the `TEST_RUNNER` environment variable before invoking the harness. This allows you to run one type of test in isolation, even if your project includes both.

For Anchor (Rust) tests:

```bash
TEST_RUNNER=anchor ./scripts/beargrease/run-tests.sh
```

For TypeScript (Mocha) tests:

```bash
TEST_RUNNER=yarn ./scripts/beargrease/run-tests.sh
```

This pattern works in both Local Mode and CI Mode. If you wish to make the override persistent, you may export the environment variable in your shell profile or embed it into your GitHub Actions workflow under the `env:` section.

The test harness will echo your override explicitly:

```
🔁 TEST_RUNNER override detected: anchor
🧪 Running Rust tests...
```

------

### Requirements for TypeScript Tests

If you plan to run TypeScript tests under Beargrease, your project must include a valid `test` script in its `package.json`. This script is not optional—it is the contract between your project and the test runner. Beargrease looks for this entry and delegates execution to it without modification.

A minimal working example looks like this:

```json
"scripts": {
  "test": "ts-mocha -p ./tsconfig.json -t 1000000 'tests/**/*.ts'"
}
```

If your tests use `.mts` files (ESM-only TypeScript modules), you may need to invoke `ts-node` in ESM mode instead. For example:

```json
"scripts": {
  "test": "node --loader ts-node/esm --test tests/*.mts"
}
```

Beargrease does not care which method you use—as long as your test script executes cleanly and returns a valid exit code. You may use `ts-mocha`, `vitest`, or raw Node.js ESM support. What matters is that your command works without error when you run:

```bash
yarn test
```

or

```bash
npm test
```

from the root of your project.b

🧰 **Dependencies Not Installed for You**

Beargrease does not install `ts-mocha`, `ts-node`, or any other test dependencies. It assumes that if you have chosen to write TypeScript tests, you have already configured your toolchain accordingly. If you are unsure whether your setup is complete, install the following packages manually:

```bash
yarn add --dev ts-mocha ts-node typescript @coral-xyz/anchor @types/mocha chai
```

This command installs the most common dependencies used in Anchor-compatible Mocha test suites.

📚 **New to TypeScript testing in Anchor?**

If you are unfamiliar with how to write Mocha-based Anchor tests in TypeScript, refer to the official Coral Anchor examples:

→ https://github.com/coral-xyz/anchor/tree/master/examples

Many projects use the `basic-1` or `spl` examples as starting points. These demonstrate exactly how to set up the test script, the `tsconfig.json`, and the IDL-based interaction with the deployed program.

------

### Requirements for Anchor (Rust) Tests

If you are writing tests in Rust using the Anchor test framework, Beargrease expects your project to conform to standard Anchor conventions. These expectations are not arbitrary—they are the structure Anchor itself requires for test execution via `anchor test`.

Beargrease invokes this process directly. It does not modify it, wrap it, or bypass it.

✅ **Required Structure for Rust Testing**

Your Anchor project must include:

- An `Anchor.toml` file in the project root
- A `Cargo.toml` file declaring your Anchor dependencies
- A `programs/` directory containing your smart contract code
- A `tests/` directory containing your integration test files

A typical test file might look like this:

```
my-project/
├── Anchor.toml
├── Cargo.toml
├── programs/
│   └── my_program/
│       └── src/
│           └── lib.rs
└── tests/
    └── my_program.rs
```

You must also declare the correct features in your `Cargo.toml` and include the appropriate dependencies. For example:

```toml
[dependencies]
anchor-lang = "0.31.1"
solana-program = "1.18.0"

[dev-dependencies]
anchor-client = "0.31.1"
```

🧪 **Writing a Minimal Rust Test File**

Here is a stripped-down example of what a functional `tests/my_program.rs` might look like:

```rust
use anchor_lang::prelude::*;
use anchor_client::Program;
use solana_sdk::signature::Keypair;
use anchor_client::Client;

#[tokio::test]
async fn test_example() {
    let payer = Keypair::new();
    let client = Client::new_with_options(Cluster::Localnet, Rc::new(payer), CommitmentConfig::processed());
    let program = client.program(Pubkey::from_str("YourProgramIdHere").unwrap());
    
    // Your test logic here
}
```

📎 **Anchor Will Build and Deploy**

When Beargrease detects that you are using Rust tests, it invokes:

```bash
anchor build
anchor test
```

as part of the test flow. This means your contract must compile cleanly, and your `Anchor.toml` must contain the correct `[programs.localnet]` section with the deployed program ID.

Beargrease will patch this `programId` automatically if your harness is set up correctly.

🐛 **If Tests Fail to Run**

If your test fails to compile, Anchor will emit a full build log. Beargrease does not suppress it. If your test runs but panics or fails assertions, the full stack trace will be visible in your output. If you receive confusing errors related to program ID mismatch, it is often because your test files are using a hardcoded ID. Beargrease can dynamically inject the correct ID into TypeScript tests, but Rust test files must be written to load it properly—or manually recompiled.

📚 **Need Help Writing Anchor Tests?**

Refer to the official Anchor documentation for Rust testing best practices:

→ https://book.anchor-lang.com/chapter_3/testing.html

You may also study open-source programs such as [marinade-finance](https://github.com/marinade-finance/liquid-staking-program) or [solana-name-service](https://github.com/bonfida/solana-name-service) for test design patterns in production-scale Anchor code.

---

### 🧭 !Beargrease Is a Test Harness—Not a Test Writing Guide!

Beargrease helps you **run** your tests—but it does not help you **write** them. You must bring your own understanding of how to test Anchor programs, whether in Rust or TypeScript.

Beargrease will not scaffold your test files, mock accounts, or show you how to write assertions. Instead, it ensures that your validator boots, your wallets fund, your program deploys, and your test runner executes—cleanly, visibly, and reliably.

If you need help writing test logic itself, these resources are recommended:

- 📘 **Anchor Book – Chapter 3: Testing**  
  → https://book.anchor-lang.com/chapter_3/testing.html
- 📁 **Official Coral Anchor Examples**  
  → https://github.com/coral-xyz/anchor/tree/master/examples
- 📦 **Marinade Finance** (production-grade Anchor tests)  
  → https://github.com/marinade-finance/liquid-staking-program
- 🧪 **Placebo Project** – A minimal working Anchor test suite  
  → https://github.com/rgmelvin/placebo

Beargrease assumes you have tests. It helps you run them—fast, reproducibly, and in CI.

---

### ⚡ Note on LiteSVM (Advanced)

If your tests are written purely in Rust and do not require a live validator, you may explore [Anchor’s new LiteSVM runtime](https://www.anchor-lang.com/docs/testing/litesvm). It allows tests to run entirely in-memory without Docker, which can speed up development.

Beargrease does not currently integrate with LiteSVM, but may support it in the future. If your project requires TypeScript tests, SPL tokens, or validator bootstrapping, continue using Beargrease’s full Docker-based harness.

For known compatibility issues, see [Appendix B.9: LiteSVM and Mollusk Compatibility Warnings](#-appendix-b.9:-litesvm-and-mollusk-compatibility-warnings)

---

### 🧪 Note on Mollusk (Advanced)

Mollusk is a new test runner introduced by the Anchor team that wraps multiple runtimes (including LiteSVM and the traditional validator) into a single CLI tool. It is designed for Rust developers who want to write tests once and run them across different environments.

Beargrease currently does not integrate with Mollusk, but recognizes it as a promising direction for local runtime flexibility. If you are writing only Rust tests and want to explore runtime switching via CLI, see the Mollusk docs:

→ https://www.anchor-lang.com/docs/testing/mollusk

If your tests require full validator execution, CI reproducibility, multi-wallet funding, or TypeScript/Web3 interaction, Beargrease remains the appropriate tool.

For known compatibility issues, see [Appendix B.9: LiteSVM and Mollusk Compatibility Warnings](#-appendix-b.9:-litesvm-and-mollusk-compatibility-warnings)

---

### When to Override, and Why

In most cases, Beargrease’s default detection is sufficient. However, manual overrides are useful when:

- You want to test only one modality (e.g., TypeScript) in a mixed-mode project
- You are debugging test runner behavior and want to avoid detection logic
- You are running tests in CI and want to enforce deterministic runner selection
- You are preparing a release and want to verify that one mode works before the other

Beargrease exists to give you control, not to assume control. If you know what you want, tell it—and it will obey.

------

Once you have successfully executed your test suite—whether in Anchor, TypeScript, or both—you may want to inspect logs, customize the scripts, or begin testing your own program logic. The next section explores **the anatomy of the Beargrease scripts**, so that you can understand each step in the harness and modify them with confidence.



---

### Mixed Mode Projects

It is entirely valid for a single project to support both TypeScript and Rust-based test suites. Anchor does not forbid this, and neither does Beargrease. In fact, many advanced projects do just that: they run quick integration tests in TypeScript, and then perform deeper behavioral or protocol-level assertions in Rust.

Beargrease does not impose an opinion here. It only asks one thing:

🧭 **Your `test` script must know what to do.**

If your `package.json` points to a TypeScript test runner, Beargrease will invoke it. If you leave no `test` script at all, Beargrease will fall back to `anchor test`. But it will not guess further than that.

If you want to support both testing styles explicitly, you have two options:

1. **Use a custom test script** that runs both suites sequentially:

   ```json
   "scripts": {
     "test": "yarn test:ts && anchor test"
   }
   ```

   Or, more explicitly:

   ```json
   "scripts": {
     "test:ts": "ts-mocha -p tsconfig.json -t 1000000 'tests/**/*.ts'",
     "test:rs": "anchor test",
     "test": "yarn test:ts && yarn test:rs"
   }
   ```

2. **Split the test stages** into different GitHub Actions jobs or test phases. This is useful if you want to control caching, parallelism, or environment differences between the suites.

Beargrease supports either approach without modification.

🔍 **What happens if both test styles exist, but only one is invoked?**

Beargrease will faithfully run whatever you tell it to. If your `test` script runs only TypeScript, your Rust tests will be ignored. If your `anchor test` script runs only Rust, your `.ts` or `.mts` files will be untouched. This is not a bug. It is an explicit trust in your declared test command.

Choose your intent. Declare it. Beargrease will respect it.

---

📄 **CI Example Forthcoming**

This section explains how to support both test styles in local development. If you would like to see a working GitHub Actions configuration that runs both test suites in CI, continue to the next section:

→ **Configuring Beargrease for GitHub CI**

That section includes a complete example of a `.yml` workflow file that supports mixed-mode testing, using one or more jobs.

---

# 7. You’ve Run Your First Tests

If you have followed the steps up to this point, you are no longer looking at a test harness—you are using one.

You have:

- Installed Rust, Solana, Anchor, and jq
- Structured your project for Beargrease compatibility
- Declared a test strategy (TypeScript, Rust, or both)
- Watched a real validator boot up, index your program, and execute your tests
- Seen the logs, the sequence, and the clean teardown

This is the first major milestone in working with Beargrease. You now understand how the harness works locally. You know how to trace each step, how to fix what fails, and how to adjust your test runner when needed. Nothing is hidden behind macros or plugins. You are in command of the test process—not the other way around.

🔜 **Next Up: Configuring Beargrease for GitHub CI**

With local tests running, the next step is to automate them. We will now show you how to set up a GitHub Actions workflow that replicates your local Beargrease run, including:

- Injecting a test wallet via GitHub Secrets
- Running the harness in CI
- Supporting mixed-mode test projects

You will not be copying from StackOverflow. You will be declaring CI the same way you declared your tests: clearly, transparently, and with full control.

---

# 8. Configuring Beargrease for GitHub CI

Once your local test cycles are stable, you are ready to bring Beargrease into CI. This section shows you how to write a GitHub Actions workflow that mirrors your local process—step by step, without abstraction or hidden state. You will:

- Define a complete `.yml` workflow file
- Inject a secure test wallet using GitHub Secrets
- Install all required tools in the CI environment
- Run the Beargrease test harness automatically

This process does not require you to edit any Beargrease scripts. It requires only that you create one workflow file and provide one secret. From that point forward, Beargrease will behave in CI exactly as it does on your machine.

------

### Create the Workflow File

From the root of your Anchor project, create the following file:

```bash
mkdir -p .github/workflows
nano .github/workflows/test-with-beargrease.yml
```

Paste the following structure into the file. It is a complete, minimal working example. Be sure to replace the `your-username/your-project` line with your actual GitHub repository identifier if you are testing from a fork:

```yaml
name: 🔬 Verify Beargrease (on placebo)
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    env:
      BEARGREASE_WALLET_SECRET: ${{ secrets.BEARGREASE_WALLET_SECRET }}

    steps:
      - name: 🧲 Checkout your project
        uses: actions/checkout@v3
        with:
          repository: your-username/your-project
          path: placebo

      - name: 📅 Checkout Beargrease
        uses: actions/checkout@v3
        with:
          repository: rgmelvin/beargrease-by-cabrillo
          path: beargrease-by-cabrillo

      - name: 💠 Set up Rust toolchain
        uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
          override: true

      - name: ⚓ Install Solana CLI (Anza)
        run: |
          sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
          echo "$HOME/.local/share/solana/install/active_release/bin" >> $GITHUB_PATH

      - name: 🚀 Install Anchor CLI
        run: |
          cargo install --git https://github.com/coral-xyz/anchor --tag v0.31.1 anchor-cli --locked

      - name: 🔧 Install jq
        run: |
          sudo apt update
          sudo apt install -y jq

      - name: 🥪 Run Beargrease test harness
        run: |
          bash beargrease-by-cabrillo/scripts/run-tests.sh
```

You can commit this file as-is. It will trigger on every push and pull request to the `main` branch. You can change the trigger conditions as needed.

------

### Provide the Wallet Secret

The only step you must perform manually is injecting a test wallet. This wallet is used by Beargrease to pay for program deployments and transactions during testing. It must be created once, encoded as a base64 string, and saved as a GitHub Secret.

#### 1. Create a Wallet Locally

From your local machine:

```bash
solana-keygen new --outfile .ledger/wallets/test-user.json
```

This creates a keypair file Beargrease can use. Now base64-encode it:

```bash
base64 -w 0 .ledger/wallets/test-user.json > secret.b64
```

🔍 The `-w 0` flag disables line wrapping so that the entire output is written as a single uninterrupted line. GitHub Secrets require this format—if the string is split across multiple lines, the secret will not work.

Once the file is created, display the encoded key with:

```bash
cat secret.b64
```

Copy the entire line of output. This is your encoded wallet.

#### 2. Add the Secret to GitHub

1. Go to your repository on GitHub.
2. Click on **Settings**.
3. In the left sidebar, expand **Security** and click **Secrets and variables → Actions**.
4. Click **New repository secret**.
5. Name the secret:

```
BEARGREASE_WALLET_SECRET
```

1. Paste the full base64 string into the value field.
2. Click **Add secret**.

This secret is now available to your GitHub Actions workflow. It will be decoded and used inside the Beargrease container during test execution.

------

### How Wallet Injection Works

When `run-tests.sh` runs in CI, it detects that `BEARGREASE_WALLET_SECRET` is present. It decodes the base64 string and writes it to `/wallet/id.json` inside the container. The containerized Solana CLI is then pointed to that file using `ANCHOR_WALLET=/wallet/id.json`. All test transactions use this wallet.

You do not need to manage this path. Beargrease handles it automatically.

If the secret is not present or is incorrectly formatted, Beargrease will fail immediately and report a clear error. This is by design.

------

### Confirming CI Success

When your workflow runs, you should see output nearly identical to a local run:

```
🐻 Beargrease Version: v1.1.0
🔧 Launching Solana validator container via Docker...
⏳ Waiting for validator to pass healthcheck...
🔐 Funding injected wallet from $BEARGREASE_WALLET_SECRET
📦 Building Anchor program...
🚀 Deploying Anchor program...
🧬 Injecting programId into test files...
🥺 Running tests...
✅ Tests complete.
🧹 Shutting down validator container...
```

If any tool is missing or misconfigured, the logs will stop at that step and show you exactly what went wrong.

Beargrease does not guess. It does not retry blindly. It fails early, clearly, and traceably.

---

# 9. Saving Logs and Outputs as Artifacts

CI runs are ephemeral—once the job completes, the container and its files vanish. If a test fails or behaves unexpectedly, it is often helpful to preserve logs or other diagnostic output. GitHub Actions supports this through **workflow artifacts**.

Artifacts allow you to download files after the workflow finishes. For Beargrease users, this is particularly useful for:

- Preserving validator logs for debugging
- Saving test output or IDL snapshots
- Archiving deployment metadata from the harness

#### Minimal Example: Uploading Validator Logs

To upload logs or other outputs, append this step at the end of your workflow:

```yaml
- name: 📦 Upload validator logs
  if: always()
  uses: actions/upload-artifact@v3
  with:
    name: validator-logs
    path: /home/runner/.solana/ledger/log/*
```

📌 **Notes:**

- The `if: always()` condition ensures logs are captured even if a prior step fails.
- Adjust the `path:` as needed based on where logs are written. You may also direct Beargrease to pipe output explicitly to a known file for capture.

#### When to Use

- When diagnosing **intermittent failures** that do not reproduce locally.
- When enabling **test traceability**, especially for mission-critical CI runs.
- When developing a program and wanting a clean audit trail of validator state.

Artifacts appear in the GitHub UI under the "Artifacts" section of each workflow run. They can be downloaded as ZIP files for inspection.

---

### Mixed-Mode CI Workflow: Rust and TypeScript Tests Together

Beargrease supports projects that include both Anchor (Rust) and Mocha (TypeScript) tests. In CI, you can run both suites in sequence within the same workflow.

Here is a complete example of a mixed-mode workflow:

```yaml
name: 🔬 Verify Rust and TypeScript Tests
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    env:
      BEARGREASE_WALLET_SECRET: ${{ secrets.BEARGREASE_WALLET_SECRET }}

    steps:
      - name: 🧲 Checkout your project
        uses: actions/checkout@v3
        with:
          repository: your-username/your-project
          path: placebo

      - name: 📅 Checkout Beargrease
        uses: actions/checkout@v3
        with:
          repository: rgmelvin/beargrease-by-cabrillo
          path: beargrease-by-cabrillo

      - name: 💠 Set up Rust toolchain
        uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
          override: true

      - name: ⚓ Install Solana CLI (Anza)
        run: |
          sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
          echo "$HOME/.local/share/solana/install/active_release/bin" >> $GITHUB_PATH

      - name: 🚀 Install Anchor CLI
        run: |
          cargo install --git https://github.com/coral-xyz/anchor --tag v0.31.1 anchor-cli --locked

      - name: 🔧 Install jq
        run: |
          sudo apt update
          sudo apt install -y jq

      - name: 🔧 Install Node.js dependencies
        working-directory: placebo
        run: |
          yarn install --frozen-lockfile

      - name: 🥪 Run Rust + TypeScript tests
        run: |
          cd placebo
          export TEST_RUNNER=yarn
          ../beargrease-by-cabrillo/scripts/run-tests.sh
          export TEST_RUNNER=anchor
          ../beargrease-by-cabrillo/scripts/run-tests.sh
```

🔁 This workflow explicitly runs the Beargrease harness twice:

1. First with `TEST_RUNNER=yarn` to execute Mocha/TypeScript tests
2. Then with `TEST_RUNNER=anchor` to execute Rust/Anchor tests

Each test suite runs in isolation, against the same validator, using the same deployed program ID. You may break these into separate jobs or stages if desired, but this single-job pattern is a good starting point.

No step is assumed. Nothing is guessed. You are not pasting YAML from StackOverflow—you are writing a clear, inspectable test workflow based on tools you already understand.

------

You have now fully configured Beargrease for CI.

- Your workflow is declared.
- Your secret wallet is securely injected.
- Your test runs mirror your local process.
- You support both test styles using a clean, ordered execution.
- You can now preserve logs for later inspection and debugging.

From this point forward, every push to your repository will trigger a complete end-to-end Solana test cycle—built on scripts you understand, logs you can read, and tools you control.

Welcome to verifiable CI.

---



# 10. You Now Control CI

You have now built a real, verifiable, inspectable test pipeline for Solana smart contracts:

- You configured your environment with Rust, Solana, Anchor, Docker, and jq.
- You structured your project to keep Beargrease and your program cleanly separated.
- You declared a GitHub Actions workflow that installs dependencies, injects a test wallet, and runs the test harness end-to-end.
- You configured that workflow to handle both TypeScript and Rust tests, with environment-sensitive logic.
- You captured logs for postmortem debugging, using GitHub’s built-in artifact system.

Nothing was hidden. No framework disguised the process. The test cycle you now control is the same cycle Beargrease runs internally.

You are no longer guessing. You are operating a system you understand.

---



# 11. Didn’t Get That Output? Check These Appendices

If your test run failed—or gave output that does not match the examples—do not guess. Every major failure mode is documented in the appendices.

Each appendix provides:

- A clear description of the problem
- How to recognize it in logs
- What causes it
- Exactly what to do next

| Appendix           | Title                               | When to Check It                                            |
| ------------------ | ----------------------------------- | ----------------------------------------------------------- |
| A.6, B.1, B.5      | Docker Installation and Healthcheck | If validator fails to start or Docker is not responding     |
| A.7, B.2           | Wallet Setup and Funding            | If no wallet is found or airdrops fail                      |
| A.4, A.5, B.4      | Solana and Anchor CLI Problems      | If CLI tools are missing, old, or fail mid-run              |
| A.7, B.2, B.6, C.2 | GitHub Secrets and Wallet Injection | If Beargrease cannot decode or find your injected wallet    |
| A.8, B.6, B.7, C.1 | Workflow and YAML Errors            | If your `.yml` fails to parse or workflows do not trigger   |
| B.3                | Program ID Mismatch                 | If Anchor or Mocha cannot find the right deployed ID        |
| A.1, B.4, C.4      | Test Runner and Language Errors     | If your TypeScript or Rust tests fail to compile or execute |

Each section is designed to be usable under pressure. You will not be told to “check StackOverflow.” You will be told exactly what went wrong and what to do.

This is the contract Beargrease makes with you. You are not just supported—you are respected.

Next up: **Advanced Usage.**

We will now show you how to run tests in parallel, split responsibilities across jobs, and prepare for integration with future modules like `bg-testkit`. You have already built a complete test harness. Now we will show you how to refine it.



---

# Part II: Advanced Beargrease Usage Topics

The previous sections established a fully working, verifiable test harness for Anchor programs on Solana—capable of running locally or inside GitHub Actions with confidence. What follows is not required for getting started, but will greatly expand your fluency and power as a developer.

These advanced usage topics demonstrate how Beargrease can:

- Support multiple wallets and simulate multi-actor scenarios
- Interact with SPL tokens and real-world Solana program APIs
- Preload accounts and simulate persistent state across test runs
- Drive frontend integration tests via `@solana/web3.js`
- Structure complex dApp projects with CI-first thinking
- Run parallel test jobs for speed and modularity
- Prepare for deeper observability and state tracking via future tools like `bg-testkit`

Each section is practical, complete, and ready to use. You are not reading ideas—you are reading tested patterns.

### 🔍 What This Section Covers:

1. [**Running Multiple Wallets in a Single Test Run**](running-multiple-wallets-in-a-single-test-run)
2. **Using Beargrease with SPL Token Programs**
3. **Bootstrap a Ledger with Pre-Loaded Accounts**
4. **Web3.js Integration Tests**
5. **Full Project Integration Example**
6. **Running Tests in Parallel CI Jobs**
7. **Advanced Troubleshooting and Observability**

You are now ready to go beyond basic test execution and begin simulating real-world conditions.



---

# 1. Running Multiple Wallets in a Single Test Run

Beargrease supports multi-wallet testing out of the box. If your project requires simulating multiple actors—such as a user, a delegate, an attacker, or a multisig signer—you can define multiple wallets in your project and Beargrease will fund each of them before running your tests.

#### Step 1: Create Additional Wallets

From the root of your project:

```
mkdir -p .ledger/wallets
solana-keygen new --outfile .ledger/wallets/alice.json
solana-keygen new --outfile .ledger/wallets/bob.json
solana-keygen new --outfile .ledger/wallets/attacker.json
```

These wallets will now be discovered automatically by the Beargrease funding script.

#### Step 2: Funded Automatically at Test Start

When you run:

```b
./scripts/beargrease/run-tests.sh
```

You will see output similar to:

```
🔐 Funding wallet: .ledger/wallets/test-user.json
🔐 Funding wallet: .ledger/wallets/alice.json
🔐 Funding wallet: .ledger/wallets/bob.json
🔐 Funding wallet: .ledger/wallets/attacker.json
```

Beargrease treats all files in `.ledger/wallets/` as active identities. There is no need to hardcode wallet names in the script.

#### Step 3: Accessing Wallets in Your Tests

In your TypeScript test code, load each wallet as needed:

```typescript
import { readFileSync } from 'fs';
import { Keypair, Connection, LAMPORTS_PER_SOL } from '@solana/web3.js';

function loadWallet(name: string): Keypair {
  const raw = readFileSync(`.ledger/wallets/${name}.json`, 'utf8');
  return Keypair.fromSecretKey(Buffer.from(JSON.parse(raw)));
}

const alice = loadWallet('alice');
const bob = loadWallet('bob');

const connection = new Connection('http://localhost:8899');

(async () => {
    const balance = await connection.getBalance(alice.publicKey);
    console.log(`Alice balance: ${balance / LAMPORTS_PER_SOL} SOL`);
})();
```

This demonstrates:

- Loading funded wallets from disk.
- Connecting to the local validator.
- Validating that funds are accessible from each wallet.

In Rust, you may load a wallet like this:

```rust
use std::fs;
use solana_sdk::signature::{Keypair, Signer};

fn load_wallet(path: &str) -> Keypair {
    let json = fs::read_to_string(path).expect("Failed to read keypair");
    let bytes: Vec<u8> = serde_json::from_str(&json).expect("Invalid JSON keypair");
    Keypair::from_bytes(&bytes).expect("Invalid keypair bytes")
}

let alice = load_wallet(".ledger/wallets/alice.json");
println!("Alice pubkey: {}", alice.pubkey());
```

this approach is flexible. You can load different signers for different client calls and simulate full-role test conditions.

#### Why It Matters

Many programs require simulating:

- Token ownership transfer
- Governance votes
- Delegation and revocation
- Cross-role constraints

A single wallet cannot test these interactions. Beargrease encourages realistic test structuring from the beginning.

📌 **Tip:** If your test suite requires a specific initial balance (e.g. for token bonding), modify the `fund-wallets.sh` script to set that amount.

---

# 2. Using Beargrease with SPL Token Programs

Many Solana programs rely on the SPL Token standard for asset transfers, minting logic, governance, or staking. Beargrease fully supports SPL Token interactions during tests. This section provides a complete example of creating a token mint, minting tokens to multiple wallets, and verifying transfers within a Beargrease test cycle.

You will:

- Create an SPL Token mint
- Mint tokens to test wallets
- Transfer tokens between wallets
- Verify balances using `getTokenAccountBalance`

#### Prerequisites

You can use this pattern in your own project, or you may clone a complete working example from the companion repository:

👉 `placebo-spl-token`—  A ready-to-run Anchor project configured for Beargrease SPL Token testing.

This project includes:

- Pre-generated test wallets (`alice`, `bob`, `test-user`)
- The SPL Token mint and  transfer test script
- A Beargrease-ready directory layout

---

Ensure you have installed the `@solana/spl-token` package:

```
yarn add @solana/spl-token
```

You will also need a working Anchor project using Beargrease with at least one test wallet (e.g., `alice.json`, `bob.json`) created as described in the previous section.

#### TypeScript Test Example

```
import { Connection, Keypair, PublicKey, clusterApiUrl } from '@solana/web3.js';
import { createMint, getOrCreateAssociatedTokenAccount, mintTo, transfer, getAccount } from '@solana/spl-token';
import { readFileSync } from 'fs';

function loadWallet(name: string): Keypair {
  const raw = readFileSync(`.ledger/wallets/${name}.json`, 'utf8');
  return Keypair.fromSecretKey(Buffer.from(JSON.parse(raw)));
}

const connection = new Connection('http://localhost:8899');
const payer = loadWallet('test-user');
const alice = loadWallet('alice');
const bob = loadWallet('bob');

(async () => {
  // Step 1: Create a new token mint
  const mint = await createMint(
    connection,
    payer,
    payer.publicKey,
    null,
    6 // 6 decimal places
  );
  console.log('Mint address:', mint.toBase58());

  // Step 2: Create token accounts for Alice and Bob
  const aliceToken = await getOrCreateAssociatedTokenAccount(connection, payer, mint, alice.publicKey);
  const bobToken = await getOrCreateAssociatedTokenAccount(connection, payer, mint, bob.publicKey);

  // Step 3: Mint 1000 tokens to Alice
  await mintTo(connection, payer, mint, aliceToken.address, payer, 1_000_000_000); // 1000 tokens (with 6 decimals)

  // Step 4: Transfer 400 tokens from Alice to Bob
  await transfer(connection, alice, aliceToken.address, bobToken.address, alice, 400_000_000);

  // Step 5: Confirm balances
  const aliceAccount = await getAccount(connection, aliceToken.address);
  const bobAccount = await getAccount(connection, bobToken.address);

  console.log('Alice token balance:', Number(aliceAccount.amount) / 1_000_000);
  console.log('Bob token balance:', Number(bobAccount.amount) / 1_000_000);
})();
```

#### Validator Configuration

Beargrease runs a local validator which accepts SPL instructions by default. There is no need for special startup parameters. Token programs are native to Solana’s runtime.

#### Troubleshooting

- If any token functions fail, ensure that:
  - `@solana/spl-token` is installed
  - Your test wallets are funded via Beargrease (check logs)
  - The connection URI is correct (`http://localhost:8899`)

📌 If you want to test more advanced SPL flows (e.g. freeze authorities, multisig mints), you can integrate those here. Beargrease does not restrict instruction complexity.

📦 Want to preserve your token test state? Use GitHub Actions artifacts to upload the token account state as JSON after tests. For details, see [Saving Logs and Outputs as Artifacts](#saving-logs-and-outputs-as-artifacts). Use GitHub Actions artifacts to upload the token account state as JSON after tests.

---

# 3. Bootstrap a Ledger with Pre-Loaded Accounts

Sometimes, you need your validator to start with a known state: certain accounts initialized, PDAs configured, or program-owned data created before your test begins. This is especially important for programs that manage:

- Governance or registry accounts
- Time-dependent state machines
- DAOs or treasuries
- Token bonding curves

Beargrease allows you to **bootstrap your test ledger** using a setup script that runs immediately after the validator starts, but before any tests execute. This gives you a reliable, inspectable starting state.

#### Step 1: Create a Bootstrap Script

From your Anchor project root, create a script such as:

```
mkdir -p scripts/bootstrap
nano scripts/bootstrap/init-ledger.ts
```

Paste the following setup example:

```
import { Connection, Keypair, PublicKey, SystemProgram, Transaction } from '@solana/web3.js';
import { readFileSync, writeFileSync } from 'fs';

function loadWallet(path: string): Keypair {
  const raw = readFileSync(path, 'utf8');
  return Keypair.fromSecretKey(Buffer.from(JSON.parse(raw)));
}

const connection = new Connection('http://localhost:8899');
const payer = loadWallet('.ledger/wallets/test-user.json');

(async () => {
  // Example: Create a deterministic test account with a PDA-like seed
  const SEED = "demo-account";
  const programId = new PublicKey('11111111111111111111111111111111'); // replace with your actual program ID
  const [pda, _] = await PublicKey.findProgramAddress([Buffer.from(SEED)], programId);

  const lamports = await connection.getMinimumBalanceForRentExemption(128);
  const createIx = SystemProgram.createAccount({
    fromPubkey: payer.publicKey,
    newAccountPubkey: pda,
    lamports,
    space: 128,
    programId
  });

  const tx = new Transaction().add(createIx);
  const sig = await connection.sendTransaction(tx, [payer], { skipPreflight: true });
  await connection.confirmTransaction(sig, 'confirmed');

  console.log(`Initialized PDA at: ${pda.toBase58()}`);
})();
```

This script connects to the local validator, creates a seeded PDA-like account, and initializes it as if it had been written into the chain’s genesis.

#### Step 2: Call the Bootstrap Script from Beargrease

Edit your `run-tests.sh` script to invoke this script after the validator starts:

```
# Inside run-tests.sh, after wait-for-validator.sh

echo "🧵 Bootstrapping ledger with pre-initialized accounts..."
node ./scripts/bootstrap/init-ledger.ts
```

Ensure `ts-node` is installed and accessible if using TypeScript for bootstrapping:

```
yarn add --dev ts-node typescript
```

Or, use a plain `.js` file and Node.js directly if you prefer:

```
node ./scripts/bootstrap/init-ledger.js
```

#### Step 3: Use Bootstrapped State in Your Tests

Whether running locally or in CI, once your bootstrap script executes successfully, the ledger will contain the pre-initialized account(s). You can access them in your tests using the same logic and addresses used during bootstrapping.

In **TypeScript**:

```
const [pda, _] = await PublicKey.findProgramAddress([Buffer.from("demo-account")], programId);
const accountInfo = await connection.getAccountInfo(pda);
console.log("Bootstrapped account found:", accountInfo !== null);
```

In **Rust**:

Use `solana_client` to fetch the account by pubkey, just as you would in production logic:

```
let pda = Pubkey::find_program_address(&[b"demo-account"], &program_id).0;
let account = client.get_account(&pda)?;
println!("Bootstrapped account lamports: {}", account.lamports);
```

This pattern works the same whether you run Beargrease on your local machine or inside GitHub Actions. In CI, the bootstrap script is invoked inside the container, directly against the test validator started by Beargrease.

#### 🧪 For Advanced Users: Capture Bootstrapped State with Artifacts

To inspect or debug the bootstrapped ledger, you can save a snapshot of the relevant account data using GitHub Actions artifacts.

Append a step to your workflow like this:

```
- name: 📦 Upload bootstrapped PDA data
  if: always()
  run: |
    mkdir -p artifacts
    solana account <PDA_ADDRESS> --output json > artifacts/pda.json
  shell: bash

- name: 📦 Upload artifact
  uses: actions/upload-artifact@v3
  with:
    name: bootstrapped-pda
    path: artifacts/pda.json
```

Replace `<PDA_ADDRESS>` with the actual public key (you may generate it in your bootstrap script and write it to a file).

This allows you to download and inspect the exact state of your ledger after initialization.

This pattern scales well as your program logic grows. You may eventually script entire registries, treasuries, or multisigs into the ledger before your actual test begins.

📎 For advanced users: combine this with GitHub Actions artifacts to save the bootstrapped state for inspection.

---

# 4. Web3.js Integration Tests

Beargrease is not limited to testing smart contracts from Rust or TypeScript using Anchor's CLI tools. You can also write and run full integration tests using `@solana/web3.js`—the standard JavaScript client library for Solana. This allows you to:

- Test browser-like behavior using Node.js
- Simulate client-side wallets, instructions, and transactions
- Ensure your deployed contract responds correctly to Web3 interactions
- Validate frontend/backend integration using the same Beargrease-driven validator

This section walks through a complete Web3.js-based test using Beargrease.

#### Prerequisites

Ensure your project includes the required libraries:

```
yarn add @solana/web3.js
```

Also install any testing utilities you wish to use, such as `mocha`, `ts-node`, or `chai`. This example assumes TypeScript:

```
yarn add --dev ts-node typescript @types/node
```

You may use a separate test file or directory from your Anchor tests. This example assumes you are writing `.mts` (ESM-compatible TypeScript modules).

#### Example: Basic Web3.js Test

```
// tests/web3-integration.mts
import { Connection, Keypair, SystemProgram, Transaction, LAMPORTS_PER_SOL } from '@solana/web3.js';
import { readFileSync } from 'fs';

function loadWallet(path) {
  const raw = readFileSync(path, 'utf8');
  return Keypair.fromSecretKey(Buffer.from(JSON.parse(raw)));
}

const connection = new Connection('http://localhost:8899');
const payer = loadWallet('.ledger/wallets/test-user.json');

const recipient = Keypair.generate();

describe('Web3.js Integration Test', () => {
  it('sends 1 SOL from test-user to recipient', async () => {
    const tx = new Transaction().add(SystemProgram.transfer({
      fromPubkey: payer.publicKey,
      toPubkey: recipient.publicKey,
      lamports: LAMPORTS_PER_SOL
    }));

    const sig = await connection.sendTransaction(tx, [payer]);
    await connection.confirmTransaction(sig, 'confirmed');

    const bal = await connection.getBalance(recipient.publicKey);
    console.log('Recipient balance:', bal / LAMPORTS_PER_SOL);
    if (bal !== LAMPORTS_PER_SOL) throw new Error('Transfer failed');
  });
});
```

#### How to Run This Test

Add this test to your `package.json`:

```
"scripts": {
  "test:web3": "node --loader ts-node/esm --test tests/web3-integration.mts"
}
```

Run it manually:

```
yarn test:web3
```

Or integrate into your Beargrease test cycle by setting `TEST_RUNNER=yarn` and ensuring `yarn test` executes the script above.

You may also create a separate CI job to run only Web3.js tests in parallel with your Anchor and Mocha tests. (See upcoming section on parallelization.)

#### When to Use This Pattern

- Your frontend code uses Web3.js directly
- You want to verify that your contract responds correctly to client-side signatures and transaction construction
- You are testing wallet behavior, error recovery, or transaction chains

Beargrease’s containerized validator allows you to simulate these flows in isolation, with complete control over the accounts, timing, and logs.

📦 To inspect Web3-created accounts after your test completes, you can save them using GitHub Actions artifacts. For example:

```
- name: 📦 Upload recipient account data
  if: always()
  run: |
    mkdir -p artifacts
    solana account <RECIPIENT_PUBKEY> --output json > artifacts/recipient.json
  shell: bash

- name: 📦 Upload artifact
  uses: actions/upload-artifact@v3
  with:
    name: web3-recipient
    path: artifacts/recipient.json
```

This allows you to examine balances, ownership, and data fields for accounts created during Web3.js tests.

Replace `<RECIPIENT_PUBKEY>` with the actual public key printed or saved during the test run.

This is your bridge between contract development and full-stack integration.

---

# 5. Full Project Integration Example

This section shows how to structure a real-world dApp repository that integrates smart contract development, test automation, and frontend interaction using Beargrease. This is not a toy scaffold or demo—it is a clean project layout that scales.

We will walk through a complete structure suitable for:

- A production-grade Anchor program
- TypeScript and Rust-based tests
- SPL token support
- Web3.js test integration
- Frontend client (optional but encouraged)
- CI workflows powered by Beargrease

This approach promotes clear separation of concerns while enabling full lifecycle validation.

#### Example Layout

```
my-dapp/
├── programs/
│   └── core/                     # Your Anchor contract
├── tests/                       # Rust and/or Mocha tests
│   ├── rust/
│   └── ts/
├── app/                         # Optional frontend (e.g. React, Next.js)
├── scripts/
│   ├── beargrease/              # Beargrease test harness
│   └── bootstrap/               # Optional pre-test ledger logic
├── .ledger/wallets/            # One or more funded test wallets
├── Anchor.toml                 # Anchor config with dynamic program ID
├── package.json                # TS test scripts + frontend deps
├── .github/workflows/
│   └── test-with-beargrease.yml
└── README.md
```

**Token Testing**
If your program uses SPL tokens, the layout supports this out of the box. You can use the `placebo-spl-token` repository as a starting point or template for your own token-based testing needs.

**Frontend Integration**
The `app/` directory is reserved for an optional frontend client, typically scaffolded using Vite or Next.js. This allows developers to build UI layers that talk directly to the local validator via `@solana/web3.js` or `@coral-xyz/anchor`. See Appendix B.10 for setup and connection tips.

**Production-Grade Anchor Practices**
While `placebo` demonstrates minimal testability, you may wish to study more complete real-world programs. A forthcoming example project, `placebo-pro`, will demonstrate production-grade Anchor design patterns including validation logic, structured account handling, and error code conventions. Until then, you may consult the Anchor cookbook for design guidance.

- Contracts are isolated from frontend logic
- Tests are visible, organized, and independent
- Beargrease remains modular and easy to update
- CI workflows can be reused or extended across forks or environments

#### What to Declare in Anchor.toml

Make sure your `[programs.localnet]` section dynamically receives the Beargrease-injected ID:

```
[programs.localnet]
my_dapp = "<to-be-replaced-by-beargrease>"
```

This avoids hardcoding and ensures accurate deployments for each CI run.

#### Recommended Test Scripts

In your `package.json`:

```
"scripts": {
  "test": "yarn test:ts && yarn test:rust",
  "test:ts": "node --loader ts-node/esm --test tests/ts/*.mts",
  "test:rust": "anchor test -- --nocapture"
}
```

These allow flexible test entry points while keeping Beargrease orchestration consistent.

#### CI Strategy

Use the CI configuration patterns described in Configuring Beargrease for GitHub CI and Uploading Artifacts to:

- Run separate jobs for Rust, TypeScript, and Web3.js suites
- Inject secrets securely
- Upload artifacts for key ledger state

This integration strategy has been validated in projects like `placebo`, `placebo-spl-token`, and the internal scaffolds for `bg-testkit`.

You do not need to invent your own integration model. You can adapt this one, knowing it already works.

---

# 6. Running Tests in Parallel CI Jobs

As your test suite grows in complexity, parallelizing your CI jobs can dramatically reduce total test time. This is especially useful when you maintain multiple test harnesses—for example, Rust and TypeScript—or need to isolate tests across roles, behaviors, or feature gates.

Beargrease is designed for this kind of scale. It uses Docker to fully isolate the Solana validator environment per job and supports secure secret injection and wallet scoping per run. This means you can safely spin up multiple concurrent jobs—each with its own validator and wallets—without risk of collision.

#### Parallelizing by Language

The most common and intuitive way to parallelize your Beargrease test suite is to split by testing language or framework. For example, a real-world project might maintain:

- Rust-based unit and integration tests
- TypeScript Mocha tests using `@coral-xyz/anchor`
- Web3.js-based behavioral tests

Each of these test suites can be placed in its own folder (`/rust-tests`, `/ts-tests`, `/web3-tests`) and run in a separate CI job.

```
jobs:
  test-ts:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run TypeScript tests
        run: |
          cd ts-tests
          ../beargrease/scripts/run-tests.sh mocha 'tests/**/*.mts'

  test-rust:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Rust tests
        run: |
          cd rust-tests
          ../beargrease/scripts/run-tests.sh cargo test -- --nocapture

  test-web3:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Web3.js tests
        run: |
          cd web3-tests
          ../beargrease/scripts/run-tests.sh node test-web3.js
```

Each job initializes its own validator, loads the required wallets, and executes its language-specific tests. If you need to pass environment variables (such as base64 secrets or RPC endpoints), use `env:` blocks per job.

Because Beargrease encapsulates test setup, validator startup, and program ID injection, these jobs remain symmetric, minimal, and easy to extend.

#### Matrix Builds for Scalability

When you want to go beyond language separation—perhaps to test multiple Solana versions, target directories, or test modules—you can use GitHub’s matrix strategy. A test matrix creates multiple jobs from a single definition, injecting variables per run.

Here is an example that runs each test subfolder (`token`, `ledger`, `web3`) in parallel:

```
jobs:
  matrix-tests:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        test-path: [token, ledger, web3]
    steps:
      - uses: actions/checkout@v3
      - name: Run matrix test suite
        run: |
          cd ts-tests
          ../beargrease/scripts/run-tests.sh mocha "tests/${{ matrix.test-path }}/*.mts"
```

This example creates three parallel jobs:

- One running tests in `tests/token/*.mts`
- One in `tests/ledger/*.mts`
- One in `tests/web3/*.mts`

You can expand the matrix with additional fields like Solana version or operating system:

```
strategy:
  matrix:
    solana: [1.18.13, 1.18.14]
    test-path: [token, ledger]
```

And reference these inside the job:

```
run: |
  curl -sSfL https://release.anza.xyz/v${{ matrix.solana }}/install | sh
  ../beargrease/scripts/run-tests.sh mocha "tests/${{ matrix.test-path }}/*.mts"
```

Matrix mode is ideal when you need test coverage across many axes. It keeps your workflow definition tight while offering wide execution spread.

#### Artifact Uploads per Job

When running in parallel—especially with matrix builds—you may want to upload job-specific artifacts, such as test logs, ledger state, or final wallet files. Use unique names to avoid collisions:

```
- name: Upload test output
  uses: actions/upload-artifact@v4
  with:
    name: output-${{ matrix.test-path }}
    path: .ledger/
```

This ensures each parallel job leaves behind distinct and inspectable outputs. These can be downloaded via the GitHub UI or fed into later workflow stages.

Beargrease’s containerized validator, flat script interface, and consistent CLI arguments make parallelism straightforward—even for large, fast-moving teams.

---

# 7. Scaling Coverage with a CI Test Matrix

When your project begins to involve multiple types of tests—Rust, TypeScript, Web3.js, or even language-specific subsets—you will quickly run into the need for scalability. Rather than writing separate workflows or trying to cram everything into one monolithic job, GitHub Actions provides a powerful tool: the **matrix strategy**.

This approach lets you declaratively define all your test dimensions and run them in **parallel jobs**—each one self-contained, isolated, and clean. Beargrease is designed to fit perfectly into this model.

#### Why Use a Matrix?

- **Isolation:** Every test type can run in a fresh environment.
- **Parallelism:** Speed up test runs dramatically.
- **Artifact Clarity:** Upload separate test outputs for each job.
- **Failure Tracing:** You know exactly which test type failed.

#### Matrix Example: TypeScript, Rust, and Web3.js

```
name: 🧪 Matrix Test Run (Beargrease)
on:
  push:
    branches: [main]

jobs:
  test:
    strategy:
      matrix:
        suite: [ts, rust, web3]
    runs-on: ubuntu-latest
    name: Run ${{ matrix.suite }} tests
    steps:
      - name: 🧲 Checkout your project
        uses: actions/checkout@v3

      - name: 🐻 Run Beargrease (${{ matrix.suite }})
        run: ./ci/beargrease-${{ matrix.suite }}.sh
```

Each `beargrease-*.sh` script can:

- Set up only the required toolchain (e.g., `anchor`, `node`, or `wasm`)
- Start the validator
- Deploy the program
- Run the test suite specific to that language

This modular structure keeps your CI environment clean and manageable.

#### Example: `ci/beargrease-ts.sh`

```
#!/usr/bin/env bash
set -euo pipefail

# Set up Anchor + Node toolchain
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
npm ci

# Run tests
npx mocha tests/**/*.mts
```

#### Example: `ci/beargrease-rust.sh`

```
#!/usr/bin/env bash
set -euo pipefail

cargo build --workspace --all-targets
cargo test --workspace
```

#### Example: `ci/beargrease-web3.sh`

```
#!/usr/bin/env bash
set -euo pipefail

npm ci
node tests/web3/setup.mjs
node tests/web3/integration.mjs
```

These examples assume your test scripts are clearly separated and that Beargrease is set up to handle dynamic program ID injection and validator indexing beforehand.



#### Artifact Naming Strategy

You may optionally upload artifacts for each test job with unique names:

```
      - name: Upload test logs
        uses: actions/upload-artifact@v4
        with:
          name: logs-${{ matrix.suite }}
          path: logs/
```

This will produce logs that can be downloaded and viewed per test type. Make sure your tests generate log files in a consistent directory structure.

#### 📚 Further Reading

You can read more about matrix jobs in GitHub’s official documentation: https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs

#### Related Sections

- 6.1. Running Tests in Parallel CI Jobs
- 7. End-to-End Test Orchestration

You are now ready to organize your test suites by type and scale your validation strategy to support robust, production-ready development.

---

# 8. Advanced Troubleshooting and Observability

Beargrease is not a black box, but even a transparent system can mislead when the pressure is on. This section is not a reference—it is a companion for when things go wrong. It assumes that something *is* broken, that the logs are unclear, that CI is failing unexpectedly, or that you simply do not believe the output you are seeing. In those moments, this guide stays with you.

If the beginner appendices tell you **what** failed, this section helps you understand **why**, and walks you through **what to do next**—step by step, without condescension, without guesswork, and without retreating into StackOverflow detours. You are still in command. Let us help you stay there.

------

## 8.1: The System is Misbehaving: Start With Your Own Senses

When a test fails, do not run again. Do not retry. Do not delete and reinstall. **Look.**

Read the last twenty lines of output *as if they were a story*. What was the validator doing? Was the wallet funded? Did the script exit early? Did the test suite run at all?

This is not superstition. It is orientation. Beargrease does not fail silently. It declares its intentions, one symbol at a time:

```bash
🐻 Beargrease Version: v1.1.0
🔧 Launching Solana validator container via Docker...
⏳ Waiting for validator to pass healthcheck...
🔐 Funding wallet: .ledger/wallets/test-user.json
📦 Building Anchor program...
🚀 Deploying Anchor program...
🧬 Injecting programId into test files...
🧪 Running TypeScript tests...
✅ Tests complete.
🧹 Shutting down validator container...
```

If that sequence was interrupted, the interruption is your first clue.

If the test runner began but no assertions were shown, the fault is downstream.

If the validator never passed healthcheck, the fault is foundational.

You do not need to be an expert. You need only to **notice what did not happen.**

------

## 8.2: CI is Failing, but Everything Works Locally

This is the most common Beargrease user report: *“It runs fine on my machine, but CI fails with a vague error.”*

You are not wrong. But you are likely missing a detail that your local shell makes invisible:

### Step-by-step:

1. **Scroll to the CI failure point.**
    Look for the first non-green symbol in your GitHub Actions run. Do not chase downstream errors. Find the first failure.

2. **Find the log group heading above the failure.**
    It will look like `🐻 Beargrease Version: v1.1.0` or `🚀 Deploying Anchor program...`. This tells you what script was running.

3. **Look for `command not found`, `permission denied`, or missing paths.**
    CI environments are clean. Your `.bashrc` and custom `$PATH` are not available. You may have installed Solana locally but forgotten to export its path in CI.

4. **Check your `.yml` file against the guide.**
    Confirm that you:

   - Installed Solana CLI using the Anza script
   - Appended to `$GITHUB_PATH`
   - Exported `ANCHOR_WALLET=/wallet/id.json`
   - Installed `jq` explicitly

5. **Check that your secret was correctly encoded.**
    In CI, a malformed base64 secret will create a silent wallet failure. To test this, add this temporary diagnostic step to your workflow:

   ```yaml
   - name: 📜 Dump decoded wallet
     run: |
       echo "$BEARGREASE_WALLET_SECRET" | base64 -d | jq length
   ```

   You should see `64`—indicating a valid Solana keypair. Anything else is a problem.

This is not about CI magic. It is about **faithfulness to the environment**. CI is a witness that does not improvise. When it breaks, it breaks at the seam between assumption and reality. Beargrease does not patch that seam—it exposes it.

------

## 8.3: The Program ID Looks Wrong

If your test fails with a message like `Program ID mismatch` or `Cannot find deployed program`, this means your test runner is using a different ID than what was deployed. Beargrease solves this—but only if your test files allow it to.

### TypeScript:

Check that you are not hardcoding a `new PublicKey("...")` in your test file. Instead, use a loader like:

```ts
import { readFileSync } from 'fs';
const anchorToml = readFileSync('Anchor.toml', 'utf8');
const match = anchorToml.match(/my_program\s*=\s*"([^"]+)"/);
```

Beargrease patches `Anchor.toml`. Your test must **follow** that patch—not bypass it.

### Rust:

If using `anchor_client`, pass the loaded program ID dynamically, or ensure your `Anchor.toml` has:

```toml
[programs.localnet]
my_program = "<placeholder>"
```

Beargrease replaces this string with the deployed ID. If you override it manually, you must recompile before running.

Do not fight the patch. Beargrease is trying to help.

------

## 8.4: I Cannot Tell Why the Test Failed

This is the most dangerous failure: a vague error with no log. CI says "exit code 1". Local mode prints nothing. You are alone with the result.

You are not. Beargrease leaves clues in the **absence** of output.

If `🧪 Running tests...` is printed, but nothing follows, the test runner was invoked but did not produce output. This means:

- The test suite may be empty
- The runner (e.g. `yarn test`) may be misconfigured
- A fatal exception occurred in a bootstrap script

Add this line *before* test execution in `run-tests.sh`:

```bash
set -x
```

This causes every subsequent command to be printed with its arguments. You will then see the exact call used to invoke your tests.

Use that command manually. Run it in isolation. Does it print? Does it exit?

If you are using `.mts` files, ensure you invoke Node with `--loader ts-node/esm`. If you are using `ts-mocha`, confirm that `tsconfig.json` includes `"module": "ESNext"` and `"target": "ES2020"`.

You do not need to guess the cause. You need to **observe the silence**.

------

## 8.5: I Want to See the Ledger

Then see it.

Inside Beargrease, the validator ledger is a real directory. In CI, it is at `/root/.solana/ledger`. Locally, it lives under your Docker volume or tmpdir. You can inspect it using:

```bash
solana account <PUBKEY> --output json
```

To find accounts:

```bash
solana program show --accounts <PROGRAM_ID>
```

Or add this to `run-tests.sh`:

```bash
solana validators
solana logs
solana block-production
```

If you need to save them:

```yaml
- name: 📦 Upload ledger logs
  if: always()
  uses: actions/upload-artifact@v3
  with:
    name: ledger-logs
    path: /root/.solana/ledger/log/*
```

Logs are not optional. They are not a bonus. They are the true record of what happened.

------

## 8.6: When You Are Tired, Sloppy, or Angry

Stop. Do not make changes. Do not rewire scripts. Do not start fresh.

Open your terminal. Run this:

```bash
bash -x ./scripts/beargrease/run-tests.sh
```

Then **watch.**

It will print every line it executes, every variable, every substitution. You will see the healthcheck loop. You will see the program ID being patched. You will see the moment that control passes to your test runner—and whether it returns.

Beargrease cannot feel your frustration. But it can walk beside you, line by line, until the pattern becomes visible again.

------

## You Are Not Lost

This is the difference between a tool and a harness:

- A tool assumes you know what you are doing.
- A harness assumes you will forget—and **reminds you anyway**.

Beargrease will never hide the command that failed. It will never silence the error that matters. It will not “just work” unless the system is actually working.

This is your system. These are your accounts. This is your validator. And this—this failure, right now—is your chance to understand it more deeply than you did before.

You are not stuck. You are paying attention.

That is how real debugging begins.



------



# 9. End-to-End Test Orchestration

This final section of the advanced usage guide unifies the ideas introduced so far. You now have a complete toolkit: local validator orchestration, wallet management, SPL token workflows, ledger bootstrapping, Web3.js compatibility, and CI parallelization. What remains is integration—not merely of code, but of purpose.

**Beargrease is not just a tool to run tests. It is an architecture to define the shape of your project’s truth.**

Orchestration begins when you stop treating your test layers as isolated components and start viewing them as perspectives on the same object. Rust, TypeScript, and Web3.js are not competing frameworks; they are lenses. Each reveals a distinct quality of your system under test—your contracts, your assumptions, your ledger, your boundaries.

#### The Shape of a Real Project

Imagine a dApp project composed of the following parts:

- A Solana program managing token vaults and cross-role permissions
- A TypeScript frontend with Web3-powered actions
- A ledger initialized with governance PDAs and escrow accounts
- Users that interact as Alice, Bob, Admin, and Attacker
- Tests written in three languages, verifying both logic and behavior

A Beargrease-enabled repository for this system might include:

```
pgsqlCopyEditmy-project/
├── Anchor.toml
├── programs/core/
├── tests/
│   ├── ts/
│   ├── rust/
│   └── web3/
├── scripts/
│   ├── beargrease/
│   └── bootstrap/
├── .ledger/wallets/
│   ├── alice.json
│   ├── bob.json
│   └── admin.json
├── frontend/
│   └── client.ts
├── ci/
│   ├── beargrease-ts.sh
│   ├── beargrease-rust.sh
│   └── beargrease-web3.sh
└── .github/workflows/
    └── test.yml
```

Each layer is modular. Each actor is real. Each test is meaningful. And Beargrease coordinates the entire ensemble: injecting the correct program ID, funding all wallets, bootstrapping the ledger, and launching the validator.

When you run a single command—whether `run-tests.sh` locally or a GitHub workflow remotely—you are not just running tests. You are executing a statement: **this is how my system behaves when all pieces are alive.**

#### Local Confidence, CI Assurance

In development, you may run:

- `create-test-wallet.sh` to generate predictable identities
- `run-tests.sh` to validate logic end-to-end
- Custom test scripts targeting TypeScript, Web3, or Rust

In CI, those same steps play out in parallel. Each job starts from zero, executes deterministically, and leaves behind a full artifact trail: logs, accounts, balances, bootstrapped ledgers. When something fails, you do not guess—you inspect.

This is not a shortcut or a compromise. This is **full-stack truth simulation**. In one CI pass, you validate:

- Cross-role logic
- Token correctness
- Frontend-client behavior
- Program deployment integrity
- Ledger state and account dynamics

No other testing harness makes this guarantee without sacrificing clarity, composability, or reproducibility.

#### Reference Example: `placebo-pro`

To illustrate these orchestration principles, Beargrease will soon include a companion project, `placebo-pro`. It is not a scaffold or template—it is a functioning reference implementation:

- Anchor contract with real instruction flow
- Token mint and transfers
- Bootstrap scripts
- Multi-wallet ledger state
- Web3.js integration tests
- Fully configured matrix-based CI pipeline

You will be able to clone, run, modify, and extend it without retrofitting or deciphering obscure internals.

#### Closing Thought

Beargrease began as a single validator container. It is now a complete integration philosophy.

- It *begins* with a container.
- It *ends* with confidence.

Where other tools give you fragments—an RPC, a logger, a wallet manager—Beargrease gives you **a unified statement of behavior**. You do not test your code in isolation. You prove that your system behaves correctly when it is whole.

From here, we move into the Appendices, where you will find troubleshooting guides, CLI references, environment notes, and deeper insights. But if you have reached this point, you are no longer a beginner. You are orchestrating reality.

# 

---

# Part III: Appendices and Troubleshooting

This section contains troubleshooting and reference appendices that support every phase of Beargrease setup and usage. Each appendix group covers a specific layer of the system:

- [**Appendix A – Installation and Environment Setup**](#appendix-a-environment-setup)
   Covers Docker, Solana CLI, Anchor CLI, jq, Rust, and Node setup.
- [**Appendix B – Troubleshooting and Recovery**](#appendix-b-troubleshooting-and-recovery)
   Diagnoses validator errors, wallet injection failures, program ID mismatches, and test runner issues.
- [**Appendix C – Advanced Use and Integration**](#appendix-c-advanced-use-and-integration)
   Helps you write workflows, upload artifacts, and debug CI behavior.

Each appendix begins with its own mini-TOC. If your Beargrease fails, this is where to begin.

# Appendix A – Environment Setup

These appendices prepare your system to run Beargrease in both local and CI environments. They cover tool installation, environment configuration, and a preflight checklist to ensure test readiness.

| Section | Title                                                        |
| ------- | ------------------------------------------------------------ |
| A.1     | Installing Node.js and enabling ESM mode                     |
| A.2     | Installing Rust and Cargo with stable toolchain              |
| A.3     | Installing Yarn and using it with TypeScript projects        |
| A.4     | Installing Solana CLI (with version locking)                 |
| A.5     | Installing Anchor CLI (matching project expectations)        |
| A.6     | Installing Docker (with platform-specific notes for Linux/macOS) |
| A.7     | Creating and funding a test wallet for Beargrease            |
| A.8     | Testing your environment: Beargrease readiness checklist     |



------

# ✅ Appendix A.1 – Installing Node.js and Enabling ESM Mode

Beargrease test suites are written in modern TypeScript and executed using `.mts` (ECMAScript Module) format. This requires that your Node.js environment:

1. Is a recent version (≥18.0.0)
2. Supports ECMAScript Modules (ESM) natively
3. Handles `import.meta.url`, `ts-node`, and package `exports` correctly

This appendix ensures that Node is installed in the right way—and that ESM mode is enabled system-wide.

------

### 📦 Step 1: Install Node.js (Recommended: Volta or NodeSource)

We recommend installing Node.js using [Volta](https://volta.sh/) or [NodeSource](https://github.com/nodesource/distributions). **Avoid Snap or apt-based installs** on Ubuntu and Pop!_OS, which often result in broken paths, outdated versions, or improper global permissions.

#### Volta (Cross-platform)

```bash
curl https://get.volta.sh | bash
```

Then restart your shell and install Node:

```bash
volta install node@18
```

Volta will pin the version for every project you run.

#### NodeSource (Linux fallback)

```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

After install:

```bash
node -v
# Should be v18.x or greater
```

------

### 📄 Step 2: Confirm ESM Compatibility

You must be able to:

- Run `.mts` files using `ts-node`
- Use `import.meta.url` without failure
- Load packages that define `"type": "module"` in their `package.json`

Create a test file named `esm-test.mts`:

```typescript
// esm-test.mts
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

console.log("✅ ESM is working:");
console.log({ __filename, __dirname });
```

Run it with:

```bash
npx ts-node esm-test.mts
```

You should see a path printed to your console. If this fails, you likely:

- Installed Node via Snap or an outdated source
- Have `type: "commonjs"` in your `package.json`
- Are running an older `ts-node` or incompatible TypeScript config

------

### ⚙️ Optional: Set `"type": "module"` Globally

If you are using ESM in most of your projects, consider setting:

```json
// package.json
{
  "type": "module"
}
```

This is not required by Beargrease, which uses `.mts` for explicit ESM handling, but it helps standardize behavior.





# ✅ Appendix A.2 – Installing Rust and Cargo with Stable Toolchain

Beargrease supports both Rust- and TypeScript-based test suites. Even if you only intend to write tests in TypeScript, many Solana programs include Rust tests or require `cargo` for IDL generation.

This appendix ensures you install Rust **the right way**—with full support for:

- `cargo test`
- Version pinning with `rustup`
- Compatibility with GitHub Actions and Anchor CLI

------

### 📦 Step 1: Install `rustup` and Rust (Stable)

The Rust toolchain is installed via `rustup`, not your system package manager.

Run:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Accept the default (install stable and update PATH).

Then reload your shell:

```bash
source $HOME/.cargo/env
```

Verify the install:

```bash
rustc --version
# rustc 1.7x.x (should be stable release)
cargo --version
# cargo 1.7x.x
```

If this fails, do **not** install Rust via `apt`, `dnf`, or `brew`. Always prefer `rustup`.

------

### 🧰 Step 2: Pin Stable Toolchain and Components

Rust evolves rapidly, so pin your toolchain for consistency across local and CI environments.

Run:

```bash
rustup default stable
rustup update
```

For most Solana development, **nightly is not needed.**

Install common components:

```bash
rustup component add rustfmt clippy
```

These are used by formatters, linters, and pre-push hooks.

------

### 🧪 Step 3: Test Your Setup

Create a minimal test:

```bash
cargo new rust-test
cd rust-test
cargo test
```

You should see:

```
running 0 tests
test result: ok. 0 passed
```

If `cargo` fails to run:

- Ensure `$HOME/.cargo/bin` is in your `$PATH`
- Restart your shell
- Run `source $HOME/.cargo/env` again

------

### 🧼 Optional: Clean up Conflicting Rust Versions

Some users install Rust via Snap or Homebrew. These cause problems later.

To remove system Rust:

```bash
sudo apt remove rustc cargo
# or on macOS
brew uninstall rust
```

Always reinstall using `rustup`.

------

# Appendix A.3 — Installing Yarn and Using it with TypeScript Projects

Yarn is a modern, reliable package manager used by many TypeScript projects. While `npm` (Node’s default) is often acceptable, **Yarn offers faster installs and better reproducibility**, especially in team or CI workflows.

Beargrease is compatible with either, but many example projects—including `placebo` and `placebo-pro`—use Yarn as the default.

------

### ✅ Step 1: Install Yarn (Globally)

You should install Yarn **globally** using `corepack`, which ships with recent Node.js versions.

```bash
corepack enable
corepack prepare yarn@stable --activate
```

This ensures Yarn is available to all projects and avoids mismatches between global and local versions.

------

### 🧪 Step 2: Confirm That xzYarn Works

```bash
yarn --version
```

Expected output:

```
3.x.x
```

You should not see anything referencing `npm` or errors about unknown commands. If you do, see troubleshooting below.

------

### 🧰 Step 3: Use Yarn with Your Project

If your project already has a `package.json`, you can initialize Yarn with:

```bash
yarn install
```

To add a dependency:

```bash
yarn add @coral-xyz/anchor
```

To run a script:

```bash
yarn test
```

All `npm run` commands become `yarn <script>` (no `run` needed).

------

### ⚠️ Notes on Yarn Versions

Yarn has **two major versions**:

- **v1 (Classic)** — Still common but deprecated in new projects.
- **v3+ (Berry)** — Used by default in Beargrease guides and examples.

Beargrease assumes Yarn 3+. You will know you’re using Berry if you see a `.yarnrc.yml` file and `.yarn/` directory.

To upgrade an older project to Berry:

```bash
yarn set version stable
```

This adds the `.yarn` files and pins the version locally—recommended for CI and team environments.

------

### 🧯 Troubleshooting

| Problem                                  | Fix                                                          |
| ---------------------------------------- | ------------------------------------------------------------ |
| `yarn: command not found`                | Run `corepack enable` again. Make sure your shell restarted afterward. |
| Yarn version shows `1.22.x`              | Upgrade with `yarn set version stable` or rerun `corepack prepare`. |
| `yarn install` modifies unexpected files | Check for `.npmrc` or legacy lockfiles. You may need to delete `package-lock.json` or switch fully to Yarn. |
| CI fails with `yarn not found`           | Add `corepack enable && corepack prepare yarn@stable --activate` to your workflow init. |



------

### ✅ Summary

You now have a reliable Yarn installation that:

- Is globally enabled using corepack
- Supports Yarn v3+ with proper version pinning
- Integrates cleanly with TypeScript and Beargrease CLI workflows

This ensures fast, reproducible builds whether working solo or with a team.

------



------

# Appendix A.4 — Installing the Solana CLI and Verifying Installation

Beargrease uses the Solana CLI to:

- Interact with the validator
- Fund local wallets
- Deploy test programs
- Inspect accounts and logs

The Solana CLI changes frequently across versions. Beargrease assumes a **version-aligned installation**, typically the one released by the [Anza team](https://anza.xyz/), not a system package or outdated global install.

------

### ✅ Step 1: Install via Anza (Recommended)

The Anza installation method ensures you get the **latest stable version** with proper profile setup.

```bash
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
```

This script installs the CLI and appends the correct path to your shell config file (e.g., `.bashrc`, `.zshrc`, etc.).

------

### 🧪 Step 2: Activate the New PATH

After installation, **either restart your shell or run this**:

```bash
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
```

Then verify:

```
solana --version
```

Expected output (example):

```bash
solana-cli 1.18.11 (anza 1.18.11)
```

------

### ⚠️ Avoid System Package Managers

Do **not** install the Solana CLI using:

- `apt install solana-cli`
- `brew install solana`
- Snap or Flatpak

These package managers often ship **outdated or unsupported versions**. They may also install to incorrect paths or override custom settings.

------

### 🧯 Troubleshooting

| Problem                                        | Fix                                                          |
| ---------------------------------------------- | ------------------------------------------------------------ |
| `solana: command not found`                    | Re-run the Anza install script and restart your shell.       |
| Old version shown (e.g. 1.10.x)                | You may have an old version from `brew` or `apt`. Run `which solana` to locate and remove it. |
| CLI works but `solana-test-validator` fails    | Likely a partial install. Re-run the script or verify that the binary is in `active_release/bin/`. |
| In CI: command fails even with Anza path added | Ensure the full export line is echoed into `GITHUB_PATH`, not just the local shell path. |



------

### 🧪 Advanced: Version Locking (Optional but Recommended)

To lock your team or CI to a specific CLI version:

```bash
solana-install init 1.18.11
```

Then run:

```bash
solana-install update
```

Beargrease projects can pin this version in a `README` or `.tool-versions` if desired.

------

### ✅ Summary

You now have a fully working Solana CLI setup that:

- Uses the latest stable release from the Anza team
- Avoids broken or outdated system packages
- Supports all Beargrease testing and deployment workflows

This CLI is required for all interactions with test validators and smart contract deployments.

------



------

# Appendix A.5 — Installing Anchor CLI and Version Locking

The **Anchor CLI** is required to build, deploy, and test Solana programs with Beargrease. But not all versions are compatible—newer versions can break IDL output, program layout, or deployment behavior.

Beargrease is version-aligned with **Anchor CLI v0.31.1**.

------

### ✅ Step 1: Install via Cargo

Install Anchor globally using the same `cargo` you configured in Appendix A.2:

```bash
cargo install --git https://github.com/coral-xyz/anchor --tag v0.31.1 anchor-cli --locked
```

This ensures you get **exactly** the supported version. The `--locked` flag prevents Cargo from auto-upgrading dependencies.

------

### 🧪 Step 2: Confirm Installation and Version

Run:

```bash
anchor --version
```

Expected output:

```
anchor-cli 0.31.1
```

If you see a different version or the command is not found:

1. Verify `~/.cargo/bin` is in your `PATH`
2. Run `cargo install` again with the correct tag

------

### 🧯 Troubleshooting

| Problem                                     | Fix                                                          |
| ------------------------------------------- | ------------------------------------------------------------ |
| `anchor: command not found`                 | Add `~/.cargo/bin` to your shell's `PATH` and restart the terminal. |
| Anchor version is too old or too new        | Run the full `cargo install` line again with `--tag v0.31.1 --locked`. |
| Errors about missing Solana binaries        | Ensure Solana CLI (Appendix A.4) is installed and in `PATH`. |
| CI or container build fails on Anchor tasks | Always pin the tag. Do **not** use `cargo install anchor-cli` with no version specified. |



------

### 🧪 Optional: Link Anchor to a Specific Project Version

Beargrease projects can optionally embed a version declaration in their README or scripts:

```bash
# Inside scripts/version.sh
ANCHOR_VERSION="0.31.1"
```

This helps team members verify or match the version during onboarding.

------

### 🚫 Do Not Use `brew install anchor`

The `brew` package for Anchor is often outdated and incorrectly built. It may install to `/opt/homebrew/bin` or interfere with other Solana tools. Always install via Cargo.

------

### ✅ Summary

You now have a **correctly versioned, fully functional Anchor CLI** that is:

- Compatible with Beargrease’s validator orchestration
- Aligned with the supported IDL format and Mocha/Rust tests
- Easy to upgrade or re-install using one locked command

This version will ensure reproducibility across environments and CI runners.

---

# Appendix A.6 — Installing Docker (with platform-specific notes for Linux/macOS/WSL2)

Beargrease runs the Solana test validator inside a Docker container. Docker must be installed correctly for your platform, with systemd integration and volume mounting enabled. This section walks through installation for **Linux**, **macOS**, and **WSL2 on Windows**.



### Linux (Pop!_OS, Ubuntu)

We strongly recommend following Docker’s official instructions for Ubuntu. Do **not** use `snap install`—it will break Beargrease.

#### ✅ Installation (APT-based):

```bash
sudo apt update
sudo apt install \
    ca-certificates \
    curl \
    gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin
```

#### ✅ Enable non-root usage:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Then **reboot your system** or **log out and back in**.

------

### macOS (Intel and Apple Silicon)

Install **Docker Desktop for Mac** from the official site:

📦 https://www.docker.com/products/docker-desktop/

After installation:

- Open Docker Desktop at least once to initialize it.
- Confirm it is running in the menu bar.
- Accept any permissions dialogs.

------

### WSL2 (Windows Subsystem for Linux)

Docker works well under WSL2 **only if configured properly**.

#### ✅ Step 1: Install WSL2 and a Linux Distro

Open PowerShell as Administrator and run:

```powershell
wsl --install
```

This will install WSL2 and a default Linux distro (e.g., Ubuntu). After reboot:

- Open the Linux terminal.
- Let the system finish setup.

If `wsl --install` fails, consult:
🔗 https://learn.microsoft.com/en-us/windows/wsl/install

#### ✅ Step 2: Install Docker Desktop for Windows

Download from:
📦 https://www.docker.com/products/docker-desktop/

During install:

- Enable **“Use the WSL2-based engine”**.
- Enable **integration** with your chosen distro (e.g., Ubuntu).

After installation:

- Start Docker Desktop manually.
- Leave it running in the background.

#### ✅ Step 3: Test Docker from inside WSL2

Launch a new terminal **inside your Linux distro**, then run:

```bash
docker run hello-world
```

You should see the default welcome message.

If you see a socket error like:

```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock
```

then:

- Ensure Docker Desktop is open.
- Ensure your WSL2 distro has integration enabled (check Docker settings).
- See [Appendix B.1](https://chatgpt.com/c/6845fc31-30ac-8010-82f0-cefbc3a45392#) for detailed fixes.

------

### Validation

Run this inside your shell:

```bash
docker --version
docker run hello-world
```

You should see:

- Docker version output.
- A success message from the `hello-world` container.

See our DockerInstall.md document for greater detail.

------

# Appendix A.7 — Creating and Funding a Test Wallet for Beargrease

Beargrease tests are signed by a specific Solana keypair. This wallet must exist, be funded, and be accessible **both outside and inside** the validator container.

This appendix walks you through **how Beargrease handles test wallets**, how to manually inspect or override them, and what to do if funding or mounting fails.



### Purpose of the Test Wallet

The test wallet is used to:

- Sign program deployments.
- Sign transactions in integration tests.
- Validate access control logic.

It is created automatically by Beargrease but can also be overridden in CI or advanced use.

------

### Where It Lives

Beargrease creates and expects the wallet at:

```bash
.ledger/wallets/test-user.json  # on the host
.wallet/id.json                 # inside the container
```

This separation allows full control over mounting and injection.

You may see scripts reference:

```bash
ANCHOR_WALLET=.ledger/wallets/test-user.json
```

This is the active wallet path for running local tests.

------

### How It Is Created

When you run:

```bash
./scripts/init-wallet.sh
```

Beargrease checks if the test wallet exists. If not, it generates a new 64-byte JSON keypair using:

```bash
solana-keygen new --outfile .ledger/wallets/test-user.json --no-passphrase
```

It then ensures `.wallet/id.json` exists and is correctly mounted in the Docker container.

------

### How It Is Funded

The wallet must contain enough SOL to:

- Deploy the program (2 SOL minimum)
- Run transactions (1 SOL or more recommended)

Beargrease funds it using:

```bash
solana airdrop 10 "$TEST_USER_PUBKEY"
```

This happens automatically during:

```bash
./scripts/fund-wallets.sh
```

If you need to fund it manually:

```bash
solana airdrop 10 -k .ledger/wallets/test-user.json
```

You can also check balance with:

```bash
solana balance -k .ledger/wallets/test-user.json
```

------

### What to Do If It Fails

If you see errors like:

- `wallet not found`
- `permission denied`
- `Could not find matching keypair`

Then check:

1. **Does the file exist?**
    Run: `ls .ledger/wallets/test-user.json`
2. **Is it readable by your user and Docker?**
    Run: `chmod 600 .ledger/wallets/test-user.json`
3. **Is it mounted correctly into the container?**
    Run inside container: `ls /wallet/id.json`
4. **Is it funded?**
    Run: `solana balance -k .ledger/wallets/test-user.json`

For more advanced fixes, see [Appendix B.2 — Wallet not found, not funded, or rejected by validator](#).

------

### Validation

You should be able to:

```bash
solana address -k .ledger/wallets/test-user.json
solana balance -k .ledger/wallets/test-user.json
```

You should also see the same wallet appear in test logs or validator logs.



------

# Appendix A.8 — Testing your environment: Beargrease readiness checklist

Before you run Beargrease on a Solana program, you should confirm that your local or CI environment is complete, correctly configured, and interoperable across tools.

This appendix provides a precise, actionable checklist. You will run a sequence of commands that confirm the readiness of:

- Solana CLI
- Anchor CLI
- Node.js and Yarn
- Rust toolchain
- Docker daemon and Compose
- Wallet existence and funding

If any step fails, you will be directed to the appropriate Appendix B entry to resolve it.

------

### ✅ Environment Readiness Checklist

You can run these checks **manually**, or incorporate them into a `scripts/preflight.sh` script in your project.

------

#### 1. Solana CLI is installed and correctly versioned

```bash
solana --version
```

✅ You should see: `solana-cli 1.18.x`
 ❌ If not, see [Appendix A.4](#) or [Appendix B.4](#)

------

#### 2. Anchor CLI is installed and correctly versioned

```bash
anchor --version
```

✅ You should see: `anchor-cli 0.31.1`
 ❌ If not, see [Appendix A.5](#) or [Appendix B.4](#)

------

#### 3. Node.js is installed and supports ESM

```bash
node -v
node -e "import('fs').then(() => console.log('✅ ESM works')).catch(console.error)"
```

✅ Should print version ≥ 18 and the ✅ line
 ❌ If not, see [Appendix A.1](#)

------

#### 4. Yarn is installed and can resolve packages

```bash
yarn --version
yarn install --check-files
```

✅ Should print version and complete successfully
 ❌ If not, see [Appendix A.3](#)

------

#### 5. Rust is installed and usable

```bash
rustc --version
cargo --version
```

✅ Should print stable version like `1.70+`
 ❌ If not, see [Appendix A.2](#)

------

#### 6. Docker is running and Compose is functional

```bash
docker info
docker compose version
```

✅ Should return JSON status and Compose version
 ❌ If not, see [Appendix A.6](#) or [Appendix B.1](#)

------

#### 7. Wallet exists, is funded, and is mounted

```bash
ls -l .ledger/wallets/test-user.json
solana balance -k .ledger/wallets/test-user.json
```

✅ Should list file and show ≥ 5 SOL
 ❌ If not, see [Appendix A.7](#) or [Appendix B.2](#)

------

#### 8. Mocha tests can run (optional dry run)

If you are testing TypeScript:

```bash
npx mocha -v
npx mocha tests/*.test.mts --dry-run
```

✅ Should detect and dry-run the test files
 ❌ If not, see [Appendix B.4](#)

------

### 🟢 Outcome: Ready for Beargrease

If every check passes, you are ready to:

```bash
./scripts/run-tests.sh
```

If any check fails, **do not proceed**. Instead, consult the matching Appendix B entry and fix the problem now.

------

---

# Appendix B – Troubleshooting and Recovery

These sections are designed for **precise diagnosis and resolution** of the most common failure modes encountered while using Beargrease. Each entry maps symptoms to root causes and provides **self-contained solutions**, keeping users within the Beargrease platform and avoiding dead-end external links or generic advice.

| Code | Issue Description                                          |
| ---- | ---------------------------------------------------------- |
| B.1  | Docker not starting or `docker.sock` permission errors     |
| B.2  | Wallet not found, not funded, or rejected by validator     |
| B.3  | `DeclaredProgramIdMismatch`: Program ID patching failure   |
| B.4  | `solana` or `anchor` commands not recognized               |
| B.5  | Validator container hangs or does not pass healthcheck     |
| B.6  | Beargrease test passes locally but fails in GitHub Actions |
| B.7  | File layout or volume mount issues inside the container    |
| B.8  | How to inspect validator logs and test output in CI        |
| B.9  | LiteSVM and Mollusk Compatibility Warnings                 |

------

# Appendix B.1 — Docker not starting or `docker.sock` permission errors

This appendix addresses the most common class of Docker startup and access failures, especially on **Linux** and **WSL2**. These errors often present as:

- `Cannot connect to the Docker daemon`
- `permission denied while trying to connect to the Docker daemon socket`
- `Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock`

------

### 🩻 Diagnosis Matrix

| Symptom                                                    | Environment | Root Cause                                                   |
| ---------------------------------------------------------- | ----------- | ------------------------------------------------------------ |
| Docker is not found                                        | Linux / WSL | Docker is not installed or misconfigured                     |
| `docker.sock` permission denied                            | Linux       | User not in `docker` group                                   |
| Docker works in Windows but not in WSL                     | WSL2        | Integration is not enabled for the selected distro           |
| `iptable_nat` error on Pop!_OS                             | Pop!_OS     | Kernel module missing from custom System76 kernel            |
| Docker container starts but validator cannot mount volumes | CI or WSL2  | Volume mount logic broken due to Docker Desktop configuration |



------

### ✅ Resolution Steps by Environment

#### 🐧 Linux (Pop!_OS, Ubuntu)

1. **Ensure Docker is installed correctly**

   ```bash
   docker --version
   ```

   If not found:

   ```bash
   sudo apt update
   sudo apt install docker.io
   ```

2. **Add your user to the docker group**

   ```bash
   sudo usermod -aG docker "$USER"
   ```

   Then **reboot your machine** or run:

   ```bash
   newgrp docker
   ```

3. **Verify socket accessibility**

   ```bash
   docker run hello-world
   ```

   If it works without `sudo`, Docker is ready.b

4. **Pop!_OS-specific fix** (if you see `iptable_nat` errors):

   ```bash
   sudo apt install linux-modules-extra-$(uname -r)
   sudo modprobe iptable_nat
   ```

------

#### 🪟 WSL2 (Windows Subsystem for Linux)

1. **Verify Docker Desktop is running**

2. **Enable WSL integration for your distro**
    Open Docker Desktop → Settings → Resources → WSL Integration
    Ensure your WSL distro (e.g., `Ubuntu-22.04`) is checked.

3. **From inside your WSL terminal**, run:

   ```bash
   docker run hello-world
   ```

4. If that fails with a socket error:

   ```bash
   sudo chmod 666 /var/run/docker.sock
   ```

   ⚠️ If this does not help, reboot your system and re-check Docker Desktop integration settings.

------

#### 🐙 GitHub Actions / CI

- CI errors related to Docker should not occur, as `docker` is preinstalled and fully privileged.
- If you see permission errors in CI:
  - Check whether **secrets are being injected into `/wallet` or `/app`**.
  - Volume mount logic may be misconfigured in your `docker compose` file or `run-tests.sh`.

Refer to **Appendix B.7** for mount and layout issues in CI.

------

### 🔍 Still Broken?

If `docker run hello-world` fails even after applying the correct fixes:

1. Confirm whether you are on a managed system (e.g., corporate firewall, university-issued device).

2. Try temporarily switching to **Docker Desktop** or a known working VM.

3. As a last resort, you may attempt full removal and reinstallation:

   ```bash
   sudo apt purge docker.io
   sudo apt autoremove
   sudo apt install docker.io
   ```

------

# **Appendix B.2 — Wallet Not Found, Not Funded, or Rejected by Validator**

*Why this matters: If your wallet is missing, unreadable, or lacks SOL, your tests will silently fail or hang. This appendix resolves all known wallet-related problems in both local and CI mode.*

------

## 🩻 Symptom Class

Beargrease and Anchor tests may fail or hang with:

- ❌ `Error: ENOENT: no such file or directory, open '.../id.json'`
- ❌ `solana-keygen: cannot open file`
- ❌ `Permission denied while reading wallet file`
- ❌ `Error: insufficient funds for transaction`
- ❌ `Transaction failed: AccountNotFound`
- 🌀 Test runner appears stuck or hangs forever

------

## 🧠 Root Causes

Wallet issues typically fall into one of four categories:

| Category              | Description                                                  |
| --------------------- | ------------------------------------------------------------ |
| **Missing wallet**    | The file does not exist at the expected location (e.g. `.wallet/id.json`) |
| **Unreadable wallet** | File exists, but permissions or format are invalid           |
| **Not funded**        | Wallet exists but has insufficient SOL to send or sign transactions |
| **Wrong context**     | Wallet was created outside the container and not mounted properly |



------

## 🛠️ Resolution Matrix

| Mode      | Cause                  | Fix                                                          |
| --------- | ---------------------- | ------------------------------------------------------------ |
| **Local** | File not found         | Run `./scripts/create-test-wallet.sh` or ensure `.wallet/id.json` exists |
|           | Wallet has no funds    | Run `./scripts/airdrop.sh` or `solana airdrop 2` (ensure validator is running) |
|           | Permission denied      | Run `chmod 600 .wallet/id.json`; make sure it is not owned by `root` |
| **CI**    | Wallet not injected    | Confirm `id.json` was injected into `.wallet/` using GitHub Actions secrets |
|           | Wallet has wrong perms | Inject using `base64` with `chmod 600` in CI step; avoid `sudo`-owned volumes |
|           | Wallet is unreadable   | Ensure the secret is exported from `solana-keygen` in **raw JSON format** (not hex) |



------

## ✅ Test if Your Wallet Is Present and Usable

### 🔍 From your host machine:

```bash
solana address -k .wallet/id.json
```

- If this returns a public key, the wallet is readable.
- If it throws an error about missing or unreadable file, rerun `create-test-wallet.sh`.

### ⚖️ Check if the wallet has funds:

```bash
solana balance -k .wallet/id.json
```

- If balance is `0 SOL`, airdrop to it while validator is running.

------

## 🧪 CI Injection Verification (GitHub Actions)

Your GitHub workflow should include a base64 wallet secret:

```yaml
env:
  WALLET_B64: ${{ secrets.TEST_WALLET_B64 }}
```

Decode and install it in `.wallet/id.json` like this:

```bash
mkdir -p .wallet
echo "$WALLET_B64" | base64 -d > .wallet/id.json
chmod 600 .wallet/id.json
```

------

## 💡 Additional Tips

- Always run `chmod 600` after creating or decoding a wallet file.
- If the validator rejects the wallet’s signature, verify that the wallet was created with `solana-keygen new --no-bip39-passphrase`.
- The default Beargrease wallet lives at `.wallet/id.json`. If you override this, update `Anchor.toml` and your test config accordingly.

------

## 🧭 Where to Go Next

If your wallet is now readable and funded, retry your test:

```bash
./scripts/run-tests.sh
```

Still failing with program ID errors? → Go to **Appendix B.3**
 Tests hang after the wallet is fixed? → See **Appendix B.5**

------

# **Appendix B.3 — `DeclaredProgramIdMismatch`: Program ID Patching Failure**

*Why this matters: This is the most common CI-specific error in Beargrease. It means your program was deployed, but your test is still pointing to the wrong ID. This appendix shows how Beargrease solves it—and how to confirm that it worked.*

------

## 💥 Error Signature

You will typically see this:

```
AnchorError caused by Account: <program>
Error Code: DeclaredProgramIdMismatch
```

This means:

> The Solana test validator accepted and deployed your program, but the **program ID embedded in the source code (lib.rs)** does not match the ID it was deployed under.

------

## 🧠 Root Cause

Anchor requires your program’s declared ID in two places:

1. **Anchor.toml**

   ```toml
   [programs.localnet]
   your_program = "PROGRAM_ID_HERE"
   ```

2. **lib.rs**

   ```rust
   declare_id!("PROGRAM_ID_HERE");
   ```

If either of these is stale, mismatched, or not patched in time, Anchor throws a `DeclaredProgramIdMismatch`.

This happens most often when:

- The ID in `lib.rs` was hardcoded
- A new deployment occurred, but the old ID remained
- A patch script ran too early, too late, or not at all

------

## 🛠 How Beargrease Prevents This

Beargrease uses this workflow:

```bash
build → deploy → extract new ID → patch Anchor.toml and lib.rs → run tests
```

It updates both files **before tests begin**, using:

- `update-program-id.sh`:
   Extracts the deployed ID from `target/idl/your_program.json`, then rewrites both `Anchor.toml` and `lib.rs`.

This ensures your test uses the actual deployed address, not a stale one.

------

## 🔍 Confirm That the Patch Worked

Run this anytime after a Beargrease test run:

```bash
cat Anchor.toml | grep your_program
cat programs/your_program/src/lib.rs | grep declare_id
```

If they differ: patching failed.

If they match, and the error still occurs, one of the following may be true:

- The test ran before the patch completed
- A cached `.tsbuildinfo` or ESM module was reused
- A rogue `ts-node` call ignored the dynamic ID

------

## 🧪 Manual Recovery

If you see this error repeatedly, do the following:

1. **Rebuild everything cleanly**

   ```bash
   anchor clean && anchor build
   ```

2. **Manually redeploy and extract ID**

   ```bash
   anchor deploy
   grep -o '".*"' target/idl/your_program.json | head -1
   ```

3. **Update both files**
    In `Anchor.toml` and `lib.rs`, paste the new program ID in quotes.

4. **Rerun Beargrease**

   ```bash
   ./scripts/run-tests.sh
   ```

------

## 🧭 Still Not Working?

- Check if `update-program-id.sh` ran at all:

  ```bash
  grep update-program-id scripts/run-tests.sh
  ```

- Open `.github/workflows/ci.yml` or your equivalent. Confirm the `update-program-id.sh` step comes **before** the tests.

- If you are running ESM-based `.mts` tests:

  - Delete `.tsbuildinfo` and any `dist/` or `build/` folders
  - Rerun using `ts-node-esm` directly, not via legacy compilers

------

## 🔐 For CI: Verify Dynamic ID Injection

If your CI flow injects a fixed program ID or pulls one from secrets, it may override Beargrease’s automatic patching.

Make sure:

- You allow Beargrease to deploy normally
- No external config is overwriting `lib.rs` or `Anchor.toml`
- If using a fixed program ID, declare it identically in both files before running

------

# **Appendix B.4 — `solana` or `anchor` Commands Not Recognized**

*Why this matters: Without access to the Solana and Anchor CLI tools, Beargrease cannot deploy, patch, or test your smart contract. This appendix shows how to diagnose CLI command failures across all platforms and environments.*

------

## 🚨 Symptom

You run any of the following:

```bash
solana --version
anchor --version
```

And receive:

- `command not found`
- `'solana' is not recognized as an internal or external command`
- A version that is **incorrect**, e.g., Anchor v0.28.x instead of v0.31.x

These errors mean Beargrease will fail silently or throw cascading deployment/test errors.

------

## 🧠 Root Causes

This typically stems from one of these:

| Cause                                        | Example Error or Effect                      |
| -------------------------------------------- | -------------------------------------------- |
| CLI not installed at all                     | `command not found`                          |
| Wrong CLI version installed                  | Unexpected behaviors or deployment errors    |
| CLI installed, but not in your `$PATH`       | Beargrease cannot access Solana/Anchor tools |
| Conflicting installs (e.g., Snap + Homebrew) | Different tools shadowing each other         |
| VSCode terminal not inheriting environment   | CLI works in one terminal, not another       |



------

## 🧪 Diagnosis Checklist

1. **Open a plain terminal (not inside VSCode)**

2. Run:

   ```bash
   which solana
   which anchor
   ```

   This tells you if the commands are present **and** visible.

3. Run:

   ```bash
   solana --version
   anchor --version
   ```

   Confirm the following:

   - `solana` should be >= `1.18.x`
   - `anchor` must be `0.31.1`

4. If either command fails or reports the wrong version:

   - You must reinstall it.
   - Do **not** skip this. CI will fail later if the wrong version is present.

------

## 🛠️ Fixing Missing or Broken CLI Installs

### 🧰 Fixing Solana CLI

Run this **Anza-based install**, which locks to the latest stable Solana:

```bash
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
echo "$HOME/.local/share/solana/install/active_release/bin" >> ~/.bashrc  # or ~/.zshrc
source ~/.bashrc  # or reload terminal
solana --version  # ✅ confirm
```

If `solana` still not found, use:

```bash
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
```

### 🧰 Fixing Anchor CLI

Run:

```bash
cargo install --git https://github.com/coral-xyz/anchor avm --locked --force
avm install 0.31.1
avm use 0.31.1
```

Then confirm:

```bash
anchor --version  # Should show 0.31.1
```

If you still see the wrong version, you may have an old `anchor` in your path:

```bash
bwhich anchor
# Might show: /usr/local/bin/anchor (bad) or ~/.cargo/bin/anchor (correct)
```

Delete any old versions:

```bash
sudo rm /usr/local/bin/anchor  # only if you installed an old global version
```

------

## 🧪 Confirm Correct CLI Is Used in CI

In GitHub Actions, confirm these install steps are present:

```yaml
- name: ⚓ Install Anchor CLI
  run: |
    cargo install --git https://github.com/coral-xyz/anchor avm --locked
    avm install 0.31.1
    avm use 0.31.1
    anchor --version
```

And for Solana:

```yaml
- name: 🧭 Install Solana CLI
  run: |
    sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
    echo "$HOME/.local/share/solana/install/active_release/bin" >> $GITHUB_PATH
    solana --version
```

Without these, CI will run using the GitHub-hosted runner’s default Solana/Anchor versions, which are often outdated.

------

## 💡 Reminder: Version Drift Can Break Tests

Anchor and Solana frequently introduce incompatible changes. If you update one without the other, you may see:

- IDL generation errors
- Program deployment mismatches
- Test serialization/deserialization failures

Beargrease assumes:

- **Anchor v0.31.1**
- **Solana v1.18.x**

You may use later versions only if you update the test and program code accordingly.

------

# **Appendix B.5 — Validator Container Hangs or Does Not Pass Healthcheck**

*Why this matters: Beargrease relies on a healthy, fully started `solana-test-validator` container before any test or deployment can proceed. If this fails silently or stalls indefinitely, nothing else will work—and worse, no error message may appear unless you know where to look.*

------

## 🚨 Symptom

You run `./scripts/run-tests.sh` and see:

```
⏳ Waiting for validator to pass healthcheck...
```

…but nothing else happens. The script hangs indefinitely, or eventually times out with:

```
❌ Validator did not become healthy after X attempts.
```

------

## 🧠 Root Causes

| Cause                                                        | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Docker not running                                           | Validator container never launched                           |
| Validator container failed to start                          | Port conflict, corrupted ledger, bad Docker network          |
| Healthcheck endpoint is not returning "ok"                   | Container is running, but validator is stuck or not yet indexing |
| Anchor/Cargo deploy or test began before validator was ready | Race condition—program not visible to CLI yet                |



------

## 🧪 Diagnosis Steps

1. **Open a new terminal.**

2. Check whether the validator container is running:

   ```bash
   docker ps
   ```

   You should see:

   ```
   solana-test-validator  ...   healthy
   ```

   If the `STATUS` is `starting`, `unhealthy`, or it is missing entirely, proceed below.

3. Inspect container logs:

   ```bash
   docker logs solana-test-validator --tail=50
   ```

   Look for clues such as:

   - `"ledger path locked"` → another validator is already using that folder
   - `"failed to bind to port"` → port already in use
   - `"unable to read ledger"` → corrupted or mismatched ledger

------

## 🛠️ Fixes Based on Symptoms

### 🔁 Container Does Not Appear At All

This typically means Docker is not running, or a startup failure killed the container early.

```bash
docker start solana-test-validator
```

If this fails:

- Restart Docker Desktop (macOS)
- Run `sudo systemctl restart docker` (Linux)

Then try:

```bash
docker compose ps
docker compose logs
```

------

### 🔥 Container Appears But Remains `unhealthy` or `starting`

This usually means:

- It cannot bind to port `8899`
- Ledger volume is locked or corrupted
- `solana-test-validator` crashed or stuck

Try forcing a full reset:

```bash
docker compose down -v  # removes volumes
docker volume prune -f  # clears orphaned data
docker compose up -d
```

Then re-run:

```bash
./scripts/run-tests.sh
```

------

### 🧪 Validator Is Running, but Not Accepting Commands

Try manually querying it:

```bash
solana cluster-version --url http://127.0.0.1:8899
```

If this fails, wait a moment and retry:

```bash
sleep 3
solana cluster-version --url http://127.0.0.1:8899
```

Beargrease includes this same logic in `wait-for-validator.sh`. If you are debugging a custom fork or CI pipeline, add additional retry or log output:

```bash
curl http://127.0.0.1:8899/health
```

It must return:

```
"ok"
```

If you see `"error"` or no response, the validator is not yet fully started.

------

## 🛡 Best Practice: Never Skip the Healthcheck

Beargrease will **not** proceed to `anchor deploy` or `mocha` tests until the validator is confirmed healthy. If you disable or modify `wait-for-validator.sh`, you must substitute a comparable readiness check.

If you attempt to deploy or test before validator readiness:

- Your program will not be visible
- Airdrops will fail silently
- TypeScript or Rust tests will throw connection or timeout errors

------

## 🧰 CI Notes

GitHub Actions runners are often slower to start Docker containers. If CI fails intermittently due to validator readiness:

- Increase `MAX_WAIT` in `wait-for-validator.sh` (default is 60s)
- Add explicit `sleep 10` before the validator check
- Review `docker compose logs` inside CI to see whether the healthcheck is succeeding but slow

------

# 🛠 Appendix B.6 – Beargrease Test Passes Locally but Fails in GitHub Actions

### 📘 Introduction

This appendix addresses a particularly frustrating case: your tests work perfectly on your machine, but fail inexplicably when run through GitHub Actions.

Beargrease is designed to create parity between local and CI environments. If that parity breaks, something has diverged between the assumptions your code makes and the conditions under which it runs in CI. This section teaches you how to locate that divergence precisely—and how to resolve it without abandoning Beargrease’s architecture.

------

## 🧭 Confirm the Symptom

You have already verified:

- `./scripts/run-tests.sh` runs successfully on your machine.
- Your Beargrease test workflow in `.github/workflows/` fails during or after the validator/test run steps.

Most often, this looks like:

```
Error: Expected program ID to be ..., but got ...
Error: Wallet not found
Error: Connection error: failed to connect to localhost:8899
Mocha timed out after 5000ms
```

These point to differences in wallet paths, timing, file visibility, or the test runner itself.

------

## 🧪 Root Cause Patterns and Resolutions

| **Symptom**                                             | **Likely Cause**                                             | **Fix**                                                      |
| ------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `program ID mismatch`, `DeclaredProgramIdMismatch`      | Dynamic replacement did not occur or occurred too late       | Confirm `update-program-id.sh` is called before the test step. Ensure the GitHub Actions runner uses `rgmelvin/beargrease-by-cabrillo@v1` if calling Beargrease from another repo. |
| Wallet not found                                        | CI wallet was not injected or not readable inside Docker     | Ensure a base64-encoded wallet secret is stored in GitHub Secrets. Confirm `init-wallet.sh` runs and mounts `/wallet/id.json`. |
| `Connection error: failed to connect to localhost:8899` | Test runs before validator is ready                          | Validator healthcheck likely failed. Confirm `wait-for-validator.sh` has correct wait logic and that it is called *before* tests. |
| Mocha or Rust test fails only in CI                     | Test is non-deterministic, time-sensitive, or assumes local file access | Use `.only` or `describe.only` to isolate the failure. Inspect CI logs to verify all test dependencies (e.g., IDL, wallet, paths) are present. |
| `solana` or `anchor` not found                          | PATH is not set in GitHub runner or CLI not installed correctly | Use the Beargrease Action or include CLI install steps (see Appendix A.4–A.5). Use `which solana` and `solana --version` in CI logs to verify install. |



------

## 🔁 Re-Run Locally in CI Mode

Beargrease encourages verifying CI assumptions locally.

Run:

```bash
CI=true ./scripts/run-tests.sh
```

This simulates the CI environment, ensuring that fallback paths and injected variables are used as they would be remotely.

Then inspect `.wallet/id.json`, `Anchor.toml`, and logs. If the local run now fails, you have reproduced the CI condition—this is ideal.

------

## 🧰 Recheck Workflow Ordering

Your CI job should include steps in this order:

1. ✅ Install Solana CLI
2. ✅ Install Anchor CLI
3. ✅ Decode wallet secret (or call `init-wallet.sh`)
4. ✅ Set any required environment variables (e.g. `ANCHOR_WALLET`)
5. ✅ Run Beargrease (`run-tests.sh`) or individual steps (`start-validator.sh`, `update-program-id.sh`, `wait-for-validator.sh`, etc.)
6. ✅ Run the tests (`mocha`, `cargo test`, etc.)

Missing any of these will produce unexpected failures in CI but not locally.

------

## 🔒 Secret Injection Best Practices

- Use GitHub Secrets, not plaintext.
- Inject your wallet secret as `BASE64_WALLET_SECRET`.
- Confirm it is mounted correctly or decoded into the container at `/wallet/id.json`.

If you are using Beargrease as a GitHub Action, this will happen automatically **if** your secret is named correctly.

See Appendix C.2 for more.

------

## ✅ Conclusion

Tests failing in CI but not locally are almost always due to mismatches in timing, secrets, or environment assumptions. Beargrease provides:

- **CI simulation via `CI=true`**
- **Deterministic test harness scripts**
- **Explicit injection points for wallet and program ID**
- **Container isolation that guarantees reproducibility**

You never need to guess or debug from scratch. Every condition that fails in CI can be recreated locally and resolved within Beargrease.

------

✅ **Checklist for CI Failures**

-  Did you simulate CI locally with `CI=true ./scripts/run-tests.sh`?
-  Did you inject the wallet correctly in CI?
-  Did the validator wait succeed before tests ran?
-  Was the dynamic program ID injected into both `Anchor.toml` and `lib.rs`?
-  Are all paths resolvable *inside the container*?

------

# 🛠 Appendix B.7 – File Layout or Volume Mount Issues Inside the Container

### 📘 Introduction

Beargrease runs tests and Solana programs inside a Docker container. If your test files, wallet files, or IDL files cannot be found **inside** that container, your local run will break—even if the files are present on your host system.

This appendix teaches you how to:

- Understand the container’s internal file structure
- Resolve `ENOENT`, `File not found`, or `invalid path` errors
- Conform to Beargrease's expected project layout and mount strategy

Everything here assumes the validator container is running under Beargrease's control via `docker compose`.

------

## 🧭 Confirm the Symptom

The errors you are encountering likely resemble one of the following:

```
Error: ENOENT: no such file or directory, open 'target/idl/myprogram.json'
Error: Could not find wallet at /wallet/id.json
Mocha test failed: Cannot find module '../target/types/myprogram'
solana address -k ... failed: file not found
```

These mean the container cannot see the file at the expected location.

If you enter the container and check the path manually, it will often be missing or mapped incorrectly.

------

## 🧱 Understanding Beargrease Volume Layout

Beargrease maps host folders into the container at specific locations. Inside the container, you will see:

| **Container Path** | **What It Contains**                 | **Source on Host**                         |
| ------------------ | ------------------------------------ | ------------------------------------------ |
| `/project`         | Your test project root               | The directory where Beargrease was invoked |
| `/wallet`          | The injected test wallet (`id.json`) | Mounted by Beargrease or CI                |
| `/usr/local/bin`   | Solana/Anchor tools                  | Installed inside container                 |



Beargrease tests must reference all files relative to `/project`.

For example:

- `target/idl/myprogram.json` becomes `/project/target/idl/myprogram.json`
- `Anchor.toml` becomes `/project/Anchor.toml`

Your test files **must not** use absolute paths or assume they are running on the host system.

------

## 🔍 Diagnosing Layout Errors

Run this command to enter the validator container:

```bash
docker compose exec solana-test-validator bash
```

Then:

```bash
ls /project/
ls /wallet/
cat /project/Anchor.toml
```

If files are missing, symlinked incorrectly, or unreadable from inside the container, the problem lies in your mount or your test assumptions.

------

## 🛠 Solutions

### ✅ 1. Always Use Relative Paths in Tests

In TypeScript:

```typescript
import path from "path";
const anchorToml = readFileSync(path.resolve(__dirname, "../Anchor.toml"), "utf8");
```

In Rust:

```rust
let path = std::path::Path::new("target/idl/yourprogram.json");
```

Never use:

```typescript
readFileSync("/home/user/myproject/Anchor.toml") // ❌ Fails inside container
```

------

### ✅ 2. Use ESM-Compatible IDL Loads

If your `.mts` tests are failing to load the IDL:

```typescript
import yourProgramIdl from "../target/idl/yourprogram.json" assert { type: "json" };
```

Or, if using dynamic load:

```typescript
const idl = JSON.parse(readFileSync(path.resolve(__dirname, "../target/idl/yourprogram.json"), "utf8"));
```

------

### ✅ 3. Do Not Mount `.wallet` or `id.json` Manually

Beargrease handles all wallet mounting via its scripts. You do not need to create a volume manually unless overriding behavior.

Appendix A.7 describes correct wallet creation and usage. Do not copy files manually or alter `/wallet`.

------

### ✅ 4. Anchor.toml Must Live at `/project/Anchor.toml`

Beargrease replaces the program ID in `Anchor.toml`. If you move or rename this file, patching will silently fail and tests may crash.

Keep `Anchor.toml` and `lib.rs` in the standard layout described in the Beginner Guide.

------

## ✅ Conclusion

Beargrease does not run your tests from the host—it stages your project inside a container. All test code, IDL loading, and wallet references **must respect the container’s volume layout**.

If your test runs are failing due to "file not found", the solution is always to inspect what the container can see—not what your local machine sees.

------

✅ **Checklist for File Layout Success**

-  Test files use `path.resolve` or relative paths, not absolute paths
-  IDL is located at `target/idl/*.json`, visible from inside container
-  `Anchor.toml` is in the project root and matches your program name
-  Wallet is available at `/wallet/id.json`, injected automatically
-  You can verify contents by running `docker compose exec solana-test-validator bash`

------

# 🛠 Appendix B.8 – How to Inspect Validator Logs and Test Output in CI

### 📘 Introduction

In local mode, you can inspect the validator’s output directly in your terminal. In GitHub Actions or CI pipelines, however, output is often hidden, truncated, or interleaved with unrelated logs. This appendix shows you how to **extract, read, and interpret** validator and test output when things go wrong in CI.

If your test hangs, exits unexpectedly, or fails silently, this guide gives you the tools to **stay within Beargrease** and pinpoint what happened—without guessing or re-running your workflow blindly.

------

## 🔍 CI Log Visibility Basics

In GitHub Actions, Beargrease prints structured output using emoji-prefixed log steps:

```
🐻 Beargrease Version: v1.1.0
🔧 Launching Solana validator container via Docker...
✅ Wallet injected at /wallet/id.json
⏳ Waiting for program to be visible...
🚀 Running tests with Mocha...
```

After these markers, any failure or stall usually falls into one of the following categories:

| **Symptom**                                 | **Likely Cause**                           |
| ------------------------------------------- | ------------------------------------------ |
| ⏳ Wait-for-program never finishes           | Deployment failed or not indexed in time   |
| ❌ Mocha exits without running any tests     | IDL file missing or import failed          |
| solana address or solana program show fails | Wallet or program path is incorrect        |
| No logs after a certain point               | CI environment lacks needed secret or path |



You can use the CI interface to expand each step. Start with:

- `Run ./scripts/run-tests.sh`
- `Run ./scripts/init-wallet.sh` *(if visible)*
- Any custom step that runs `solana` or `ts-node`

------

## 🔧 Techniques for Recovering Output in CI

### ✅ 1. Add `set -x` to Your Scripts

For deeper traceability, modify any script temporarily:

```bash
#!/usr/bin/env bash
set -euo pipefail
set -x  # Echo all commands
```

This will show every line being executed in GitHub Actions logs.

Recommended for debugging:

- `run-tests.sh`
- `wait-for-validator.sh`
- `update-program-id.sh`

Do **not** leave `set -x` on in production CI unless you scrub secrets.

------

### ✅ 2. Use `docker compose logs`

In local mode:

```bash
docker compose logs -f solana-test-validator
```

In CI, Beargrease prints container logs if the validator fails healthcheck or exits. Look for:

```
solana-test-validator  | Ledger location: /root/.ledger
solana-test-validator  | Blockstore recovered...
solana-test-validator  | JSON-RPC is listening...
```

If these do not appear, the validator likely failed to start. You may also see:

```
solana-test-validator  | Error: Port already in use
solana-test-validator  | Error: Missing syscalls
```

Each is actionable—Appendix B.1 covers Docker start errors.

------

### ✅ 3. Print Anchored File Paths During Test Runs

If your test fails silently:

```typescript
console.log("Reading IDL from", idlPath);
console.log("Program ID:", program.programId.toBase58());
```

This ensures that your test is using the right files and wallet.

In CI logs, these are easily searchable and prove which part failed.

------

### ✅ 4. Use `console.log` Strategically in TypeScript

Do not rely solely on Mocha’s output. You may never see it if the test fails during async setup.

Instead, place `console.log()` calls **before and after** your `setProvider`, IDL load, or wallet usage

```typescript
console.log("Setting Anchor provider...");
setProvider(provider);
console.log("Loading program...");
```

You will know exactly which part failed and can compare CI vs. local.

------

### ✅ 5. Remember: GitHub Logs Are Timestamped

If a test appears to “hang”, check the timestamps on the left of the log. If no new lines have appeared in >60 seconds, the container is likely stalled.

Use this in combination with `set -x` to know what step was last executed.

------

## ✅ CI Output Troubleshooting Checklist

| ✅                                                            | Action |
| ------------------------------------------------------------ | ------ |
| [ ] Add `set -x` to failing scripts                          |        |
| [ ] Use `console.log()` to trace async setup                 |        |
| [ ] Ensure all file paths are relative and container-safe    |        |
| [ ] Check timestamps for last known good output              |        |
| [ ] Expand full logs for `solana-test-validator` and `run-tests.sh` in CI |        |
| [ ] Use `ts-node` or `npx mocha` locally to mirror CI environment |        |



------

### 🧭 Navigating CI Failures Confidently

All output shown in this guide can be recovered **without switching tools**, installing third-party loggers, or re-running CI jobs blindly. Beargrease scripts are designed to emit verbose, readable logs, with clear markers that help isolate failures.

When reviewing logs, return to the last emoji-prefixed marker and consider:

- What script was executing when output stopped?
- Did the script complete or error out?
- What was the last operation shown (e.g., reading an IDL, setting a provider)?

These questions can often clarify the failure path and help resolve the issue directly within the test environment—without extra tools or guesswork.

---

# Appendix B.9 - LiteSVM and Mollusk Compatibility Warnings

Beargrease is a full-system test harness that relies on a running Docker-based Solana validator. It assumes your tests require live RPC calls, wallet provisioning, dynamic program deployment, and validator-indexed state. As such, it **does not currently support runtimes that bypass the validator**, including:

- `anchor test --provider lite` (LiteSVM)
- `mollusk test` (Mollusk CLI)

If you attempt to integrate LiteSVM or Mollusk into your Beargrease workflow—either by overriding `anchor test` in `run-tests.sh`, or modifying the GitHub CI job—you may encounter misleading or silent failures:

- ❌ **Program ID injection will not occur**, because there is no validator process to patch
- ❌ **Tests may panic with “program not found,” “missing account,” or similar runtime errors**
- ❌ **Wallet airdrops, funding logic, and log capture will be skipped**
- ❌ **Validator health checks and startup gates will be bypassed or break unexpectedly**

These errors are not due to bugs in Beargrease or in Anchor—they are the result of incompatible runtime expectations. Beargrease coordinates the launch, funding, deployment, and test phases under the assumption that a validator is present and that test execution will interact with it over RPC.

------

### ✅ Recommended Practice

- Use Beargrease with **standard `anchor test`** for now. If you are using Rust tests, this is already fully supported.
- If you are exploring LiteSVM or Mollusk for ultra-fast in-memory testing, do so **outside the Beargrease flow** until native support is added.
- You may still use these tools for experimentation—but not as replacements for test execution within Beargrease-managed runs.

------

### 📘 External Resources

For more information on the advanced runtimes discussed here:

- **LiteSVM Documentation**
   → https://www.anchor-lang.com/docs/testing/litesvm
- **Mollusk Overview**
   → https://www.anchor-lang.com/docs/testing/mollusk

---



# 📦 Appendix C – Advanced Use and Integration

Beargrease was designed not only as a local testing harness but also as a launchpad for sophisticated, real-world Solana workflows. The appendices below expand beyond first use and explore how Beargrease integrates with CI pipelines, test matrices, frontend apps, and production-like ledgers.

Each entry is written to make these advanced workflows approachable—without sending the reader elsewhere for missing context. These sections assume the user has completed at least one successful test run using Beargrease, locally or in CI.

## Table of Contents

| Ref  | Title                                                    |
| ---- | -------------------------------------------------------- |
| C.1  | Running a Single Test File or Suite (TypeScript or Rust) |
| C.2  | Injecting Secrets in CI: Wallets, Program IDs, and Paths |
| C.3  | Using Matrix-Based Test Jobs in GitHub Actions           |
| C.4  | Customizing the `scripts/` Folder for New Roles or Apps  |
| C.5  | Connecting a Frontend to the Local Beargrease Validator  |
| C.6  | Upgrading Beargrease: Managing Your Version and Changes  |



------



# ✅ **Appendix C.1 — Running a Single Test File or Suite (TypeScript or Rust)**

------

### 🔍 Overview

When debugging a failure, test-driving a new feature, or isolating regressions, you may want to run only a single test file instead of your entire test suite. Beargrease supports this natively for both **TypeScript** and **Rust** tests, whether run locally or inside CI.

This appendix shows how to run individual test files, control which ones are included in CI jobs, and validate that the Beargrease validator correctly supports isolated runs without excess setup.

------

### 🧪 TypeScript (Mocha + .mts)

TypeScript test files in Beargrease-based projects usually live in:

```
tests/
  my-test.mts
  another-test.mts
```

To run only one test file locally, use:

```bash
npx mocha --loader ts-node/esm tests/my-test.mts
```

This command:

- Uses the ESM loader to support `.mts` files.
- Skips `run-tests.sh`, so assumes validator is already running.

You can also inject a single test target into the standard Beargrease test flow using:

```bash
TEST_FILE=tests/my-test.mts ./scripts/run-tests.sh
```

This automatically:

- Starts the validator
- Injects program ID
- Runs the single test file

✅ This works as-is with Beargrease v1.1.0+. No modifications required.

------

### 🔧 Rust Tests

Rust tests that rely on the Anchor testing framework are typically run using:

```bash
anchor test
```

To run a single Rust test file (or test module) manually:

```bash
cargo test --test my_test_file
```

Or to run a specific test case inside a file:

```bash
cargo test test_function_name
```

Beargrease will automatically set up the validator and wallets, but in cases where you want to skip `anchor test` entirely and use `cargo` directly, make sure:

- `solana-test-validator` is running
- Wallet is funded and exported (`ANCHOR_WALLET`)
- The test uses `Anchor.toml` and the IDL from `target/idl`

🛠 Tip: Use `scripts/run-tests.sh` as a reference for how the environment is prepared if you want to mimic it manually.

------

### 🧼 Cleanup and Best Practices

- Do not leave hardcoded test filters or file paths in your CI workflow files.
- Use `TEST_FILE=...` or `TEST_PATTERN=...` in CI scripts to allow selective test runs while keeping configs clean.
- In Rust, use feature flags to isolate integration-heavy tests from fast unit tests.

------

### 📌 Summary

| Language   | Run Single File           | Beargrease-Aware Option                          |
| ---------- | ------------------------- | ------------------------------------------------ |
| TypeScript | `npx mocha tests/foo.mts` | `TEST_FILE=tests/foo.mts ./scripts/run-tests.sh` |
| Rust       | `cargo test --test file`  | Reuse validator setup logic or use `anchor test` |



------

# ✅ **Appendix C.2 — Injecting Secrets in CI: Wallets, Program IDs, and Paths**

------

### 🔍 Overview

Continuous Integration (CI) often requires injecting **secrets** like base64-encoded wallets, program IDs, or runtime paths. If done incorrectly, this can break your pipeline silently or cause security issues.

Beargrease supports **explicit, transparent injection** of secrets using environment variables and mountable volumes. This appendix explains how to:

- Inject a base64 wallet secret in CI
- Confirm it was decoded and mounted correctly
- Override or provide the program ID dynamically
- Maintain clear boundaries between host and container environments

------

### 🔑 Injecting a Wallet Secret

In GitHub Actions, you can store a wallet secret as a base64-encoded string. For security:

1. **Do not store raw JSON** in your GitHub secrets.

2. Use the `base64` command to encode the wallet:

   ```bash
   base64 -w 0 path/to/wallet.json
   ```

3. Store this in GitHub as a secret named, for example, `BG_WALLET_B64`.

#### 🧪 Decoding the Wallet in CI

Beargrease expects this to be injected via:

```yaml
env:
  BG_WALLET_B64: ${{ secrets.BG_WALLET_B64 }}
```

The `init-wallet.sh` script inside Beargrease will:

- Detect the presence of `BG_WALLET_B64`
- Decode it into the container’s `/wallet/id.json` path
- Set up appropriate `ANCHOR_WALLET` and Anchor.toml references

✅ This process requires no manual edits. It is version-locked and CI-safe.

------

### 📛 Injecting a Program ID

If you deploy your program inside CI (e.g., using `anchor deploy`), the resulting `so` file will output a program ID that must be used in:

- `Anchor.toml`
- `lib.rs` (in Rust)
- TypeScript tests

Beargrease handles this by:

1. Reading the `so` metadata after deployment
2. Overwriting `Anchor.toml` with the correct ID
3. Rewriting `lib.rs` using `update-program-id.sh` (if applicable)

If you wish to inject a pre-known program ID instead:

```yaml
env:
  BG_PROGRAM_ID: "YourDeployed111111111111111111111111111111111"
```

Beargrease will detect and use this instead of inferring from deployment.

🛠 Tip: Only use this in workflows where you do **not** deploy dynamically. For dynamic CI testing, let Beargrease manage ID patching.

------

### 📁 Injecting Paths and Mounts

Some CI flows require injecting IDLs, test files, or config paths.

Use GitHub Action mounts and environment variables like:

```yaml
env:
  BG_IDL_PATH: "./target/idl/myprogram.json"
  BG_TEST_FILE: "./tests/quick-check.mts"
```

In your Beargrease-compatible test runner:

```bash
TEST_FILE=$BG_TEST_FILE ./scripts/run-tests.sh
```

Use of `TEST_FILE` is already integrated in Beargrease v1.1.0+.

------

### ✅ Verification Steps in CI

Your logs should confirm:

- `🐻 Found BG_WALLET_B64 in environment`
- `✅ Wallet successfully written to /wallet/id.json`
- `✅ Program ID injected into Anchor.toml and lib.rs`
- `🧪 Running TEST_FILE: ./tests/...`

If these markers are missing, check your CI secrets and `env:` block.

------

### 🧼 Summary

| Secret Type    | Env Var         | Outcome                                       |
| -------------- | --------------- | --------------------------------------------- |
| Wallet         | `BG_WALLET_B64` | Decoded to `/wallet/id.json` inside container |
| Program ID     | `BG_PROGRAM_ID` | Used to patch `Anchor.toml` and `lib.rs`      |
| Test File Path | `TEST_FILE`     | Used by `run-tests.sh` to isolate run         |



------

# ✅ **Appendix C.3 — Using Matrix-Based Test Jobs in GitHub Actions**

------

### 🧬 Overview

Matrix-based test jobs in GitHub Actions allow you to:

- Run multiple test types (Rust, TypeScript, Web3.js) **in parallel**
- Validate across multiple Solana or Anchor versions
- Shorten feedback cycles during pull requests or merges
- Avoid race conditions by isolating environments per job

Beargrease is designed for **matrix execution**. This appendix teaches you how to set it up **safely, efficiently, and transparently**, using only GitHub’s native features and Beargrease’s scripting structure.

------

### 🧩 What Is a Matrix Job?

A matrix job allows one workflow to run **multiple jobs with different parameters**. For example:

```yaml
strategy:
  matrix:
    language: [typescript, rust]
```

This will create two parallel jobs, each with a different value for `matrix.language`.

In Beargrease, this means you can do:

- ✅ TypeScript test suite
- ✅ Rust test suite
- ✅ Optionally, a Web3.js test suite

— all at once, with identical infrastructure.

------

### 🧱 Setting Up a Matrix Job

Here is a minimal matrix-based workflow using Beargrease:

```yaml
name: 🧪 Beargrease Matrix Tests

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    strategy:
      matrix:
        suite: [typescript, rust]

    runs-on: ubuntu-latest

    env:
      BG_WALLET_B64: ${{ secrets.BG_WALLET_B64 }}

    steps:
      - uses: actions/checkout@v4

      - name: 🐻 Set test file per suite
        run: |
          if [ "${{ matrix.suite }}" = "typescript" ]; then
            echo "TEST_FILE=tests/placebo.test.mts" >> $GITHUB_ENV
          elif [ "${{ matrix.suite }}" = "rust" ]; then
            echo "TEST_FILE=" >> $GITHUB_ENV  # Rust will ignore this
          fi

      - name: 🐻 Run Beargrease
        uses: rgmelvin/beargrease-by-cabrillo@v1
        with:
          test-file: ${{ env.TEST_FILE }}
```

------

### 🧪 Expected Behavior

Each matrix job will:

- Decode the injected wallet via `BG_WALLET_B64`
- Spin up a fresh validator
- Run either a `.mts` or Rust test suite
- Exit cleanly, **independently of the other job**

Matrix jobs **do not share containers**, which removes the possibility of test cross-talk or collision.

------

### 🧼 Notes and Customizations

#### 🧪 Run only a single file:

Use `TEST_FILE=tests/myfile.mts` to run only one TypeScript test file in the matrix job.

#### 🔁 Add another test type:

You can expand the matrix:

```yaml
matrix:
  suite: [typescript, rust, web3js]
```

Then add appropriate detection and file path logic.

#### 🧯 Fail-fast behavior:

GitHub supports `fail-fast: false` if you want **all jobs to complete even when one fails**.

```yaml
strategy:
  fail-fast: false
```

This is helpful for teams reviewing multiple test suites across PRs.

------

### 🔒 Security and Consistency

- Use `BG_WALLET_B64` in all jobs to ensure consistent identity.
- Do not share volumes between matrix jobs unless you deeply understand container overlap.
- Beargrease never writes outside its own Docker mounts and project directories—safe for CI.

------

### ✅ Summary

| Feature                 | Behavior in Matrix Mode             |
| ----------------------- | ----------------------------------- |
| Fresh validator per job | ✅ Yes                               |
| Wallet isolation        | ✅ Injected per job via env          |
| Test-type flexibility   | ✅ Supports TS, Rust, Web3.js        |
| Shared volume risk      | ❌ Avoided (container-per-job model) |
| CI compatibility        | ✅ Native GitHub Actions             |



------

# ✅ **Appendix C.4 — Customizing the `scripts/` Folder for New Roles or Apps**

------

### 🧭 Overview

The `scripts/` folder is the **execution heart** of a Beargrease-based test harness. It includes modular shell and TypeScript utilities that:

- Launch the Solana validator
- Fund and manage wallets
- Inject program IDs dynamically
- Run tests (Mocha, Rust, or Web3.js)

To scale Beargrease for **multi-role projects** (like governance, games, or marketplaces), you may need to:

- Add **named roles** (e.g., Alice, Bob, Admin)
- Seed **custom program state**
- Pre-mint SPL tokens or NFTs
- Integrate with complex test setups

This appendix teaches you how to **extend `scripts/` responsibly**, maintaining clarity and reproducibility.

------

### 🧱 Directory Structure

A default Beargrease project includes:

```
scripts/
├── airdrop.sh
├── create-test-wallet.sh
├── fund-wallets.sh
├── init-wallet.sh
├── run-tests.sh
├── update-program-id.sh
├── wait-for-program.ts
├── wait-for-validator.sh
└── version.sh
```

You may safely extend this with custom setup logic:

```
scripts/
├── setup-alice.sh
├── setup-admin-role.sh
└── mint-tokens.sh
```

------

### 🪪 Adding Named Roles (e.g., Alice, Bob)

To create a test wallet and fund it with SOL:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "👤 Creating wallet for Alice..."
solana-keygen new --no-bip39-passphrase --outfile .ledger/wallets/alice.json --force

echo "💰 Airdropping SOL to Alice..."
solana airdrop 5 --keypair .ledger/wallets/alice.json
```

💡 Place this in `scripts/setup-alice.sh`. Then call it from your test script or CI run.

------

### 🧰 Minting Tokens or Initializing Accounts

To set up token accounts or SPL mint authorities:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "🎯 Minting test token..."

TOKEN_PROGRAM=$(solana address -k ~/.config/solana/id.json)
spl-token create-token --url localhost --owner "$TOKEN_PROGRAM"

echo "📦 Creating associated token account..."
spl-token create-account <TOKEN_ADDRESS> --owner "$TOKEN_PROGRAM"
```

Use this as a base for token-based projects.

------

### 🧪 Test Usage Example (TypeScript)

Your `.mts` test file can load these roles:

```typescript
const alice = Keypair.fromSecretKey(
  Uint8Array.from(JSON.parse(fs.readFileSync(".ledger/wallets/alice.json", "utf8")))
);
```

Use Alice’s `publicKey` in cross-role tests or permissioned logic.

------

### 🔁 Best Practices

| Practice                    | Recommendation                                      |
| --------------------------- | --------------------------------------------------- |
| 🔒 Role separation           | One file per role (e.g., `setup-admin.sh`)          |
| 💾 Wallet storage            | Save in `.ledger/wallets/` only                     |
| 📁 Script naming             | Use `setup-*.sh` prefix for clarity                 |
| 🚫 Avoid global side effects | Never write outside the project directory           |
| 🧼 Idempotent logic          | Allow repeated calls without failure                |
| ✅ Validate outcomes         | Check for success conditions and print confirmation |



------

### ⚠️ Anti-Patterns to Avoid

| Bad Practice                  | Reason                                             |
| ----------------------------- | -------------------------------------------------- |
| Hardcoding wallet addresses   | Breaks across environments or key rotations        |
| Using `solana config set`     | Changes global state outside Beargrease            |
| Funding via hardcoded pubkeys | Use `solana address -k ...` instead                |
| Skipping wallet confirmation  | Always print or validate that a wallet was created |



------

### 🧪 Example: Multi-Role CI Job

```yaml
- name: 🛠 Setup Alice and Bob
  run: |
    ./scripts/setup-alice.sh
    ./scripts/setup-bob.sh

- name: 🧪 Run tests with both roles
  run: ./scripts/run-tests.sh
```

------

# ✅  Appendix C.5 — Connecting a Frontend to the Local Beargrease Validator

------

### 🧭 Overview

Beargrease is not just for smart contract developers—it also supports full-stack dApp teams. This appendix teaches you how to:

- Connect a **React, Svelte, or Vue** frontend to the local Beargrease validator.
- Use the same **wallet**, **program ID**, and **network** as the backend tests.
- Develop, debug, and demo your app **without ever touching devnet or mainnet**.

Everything runs locally, fully reproducible, and fast.

------

### 🌐 Why Connect Locally?

| Benefit       | Explanation                                                  |
| ------------- | ------------------------------------------------------------ |
| 🚀 Speed       | No RPC delays, rate limits, or devnet outages                |
| 🔒 Privacy     | Test private contracts and wallet logic without external exposure |
| 🧪 Determinism | The chain resets every run, so you get a known-good state    |
| 📦 CI-ready    | Reuse the same approach for GitHub Actions smoke testing     |



------

### 🧩 Setup Requirements

| Requirement                    | Status                                            |
| ------------------------------ | ------------------------------------------------- |
| 🐋 Docker installed             | See [Appendix A.6](#appendix-a6)                  |
| ✅ Beargrease validator running | Via `./scripts/run-tests.sh`                      |
| 🧪 A valid IDL + program ID     | In `target/idl/` and `Anchor.toml`                |
| 🌐 Web framework                | React/Vite, SvelteKit, or similar with TypeScript |



------

### 🔌 Connecting to the Validator

The Beargrease validator listens at:

```
http://localhost:8899
```

You can connect any Solana frontend like so:

#### TypeScript / React (e.g. `@solana/web3.js`)

```typescript
import { Connection, clusterApiUrl } from "@solana/web3.js";

const connection = new Connection("http://localhost:8899", "confirmed");
```

Do **not** use `clusterApiUrl("devnet")`. You are connecting to a **local test validator**, not a cluster.

------

### 👛 Using the Beargrease Wallet in Your UI

Beargrease writes the test wallet to:

```
.ledger/wallets/test-user.json
```

To load that in the browser (for development only):

```typescript
import { Keypair } from "@solana/web3.js";

const secret = JSON.parse(fs.readFileSync(".ledger/wallets/test-user.json", "utf8"));
const keypair = Keypair.fromSecretKey(Uint8Array.from(secret));
```

If your app runs in the browser, you’ll need to:

- Either import `test-user.json` as a static asset (Vite)
- Or expose its `publicKey` via a dev-only backend bridge

**Never expose the private key in production.**

------

### 💻 Example: Vite + React

```typescript
// vite.config.ts

export default defineConfig({
  define: {
    "process.env.VALIDATOR_URL": JSON.stringify("http://localhost:8899"),
    "process.env.TEST_WALLET": fs.readFileSync("./.ledger/wallets/test-user.json", "utf8"),
  },
});
```

Use these in your app:

```typescript
const connection = new Connection(process.env.VALIDATOR_URL!, "confirmed");
const keypair = Keypair.fromSecretKey(Uint8Array.from(JSON.parse(process.env.TEST_WALLET!)));
```

------

### 🧪 Integration Testing with UI + Beargrease

You can go even further and run **end-to-end UI tests** with Beargrease:

1. Launch the validator via Beargrease.
2. Start your frontend in dev mode.
3. Run your UI tests (e.g., Playwright, Cypress) against that instance.

This enables **true full-stack tests** with:

- On-chain contract logic
- UI interaction
- Wallet simulation
- Isolated validator state

------

### 🧼 Best Practices

| Pattern                     | Guidance                                                     |
| --------------------------- | ------------------------------------------------------------ |
| 🧪 CI smoke testing          | Use Beargrease for CI-based UI sanity checks                 |
| 🚫 Never expose private keys | In frontend, restrict to dev-only builds                     |
| 🔁 Auto-reload IDL           | Use `fs.watch` or `vite-plugin-reload` to pick up contract changes |
| 🔍 Use verbose logs          | Console log transactions and simulate with confirmation      |



------

### 🧱 Advanced: Simulate Phantom

For full UX, you can simulate a wallet adapter:

- Use `@solana/wallet-adapter` in dev mode
- Swap its provider to inject `test-user.json`
- Use mock transaction signing

This allows **realistic UIs** with pre-funded test users and on-chain feedback.

------

### 🔭 What Comes Next

This appendix covers everything required to manually connect a frontend app to the Beargrease validator, but does not yet include a full working example.

That work is being developed under the `beargrease-pro` banner and will include:

- A Vite-based example app (`placebo-ui`) wired to the local validator
- A mock wallet adapter that uses the Beargrease test wallet
- Full-stack tests using Playwright or Cypress

Once published, this appendix will be updated to link to those resources and walkthroughs directly.

---

# Appendix C.6 — Upgrading Beargrease: Managing Your Version and Changes

### 📘 Introduction

Beargrease evolves. New versions may introduce improved CI support, better secrets handling, enhanced error messages, or even whole new test runners. But your project does not need to break each time that happens.

This appendix teaches you how to:

- Lock to a known working version of Beargrease.
- Track future updates without blindly pulling them in.
- Safely upgrade while preserving your custom scripts or configs.

Whether you use Beargrease as a CLI, a GitHub Action, or a cloned harness, these practices will give you control over your environment—even as the ecosystem moves forward.

------

### 📐 Table of Contents

| Section | Description                         |
| ------- | ----------------------------------- |
| 🔖 C.6.1 | Locking a Known Beargrease Version  |
| 🧭 C.6.2 | Understanding What Changed          |
| 🛠 C.6.3 | Upgrading Safely from a Cloned Repo |
| 🔄 C.6.4 | Replacing GitHub Action Versions    |
| 🧪 C.6.5 | How to Verify Upgrades with Tests   |



------

### 🔖 C.6.1 — Locking a Known Beargrease Version

Beargrease versions follow the format:

```
v1.1.0, v1.1.3, v1.2.0, etc.
```

These are Git tags applied directly to the `main` branch of [rgmelvin/beargrease-by-cabrillo](https://github.com/rgmelvin/beargrease-by-cabrillo). When using Beargrease as a GitHub Action or external dependency, **you must lock to a specific version** to avoid unexpected behavior.

**✅ In GitHub Actions:**

```yaml
uses: rgmelvin/beargrease-by-cabrillo@v1.1.0
```

**✅ In a cloned repo (e.g., `git submodule`):**

```bash
git checkout v1.1.0
```

If you do not pin a version, you are accepting the latest changes from the `main` branch—possibly including breaking changes.

------

### 🧭 C.6.2 — Understanding What Changed

Beargrease includes a `CHANGELOG.md` that lists each tagged release, including:

- What changed (features, fixes, removals)
- Why the change occurred
- Whether it introduces a breaking behavior

You can also view these changes using Git directly:

```bash
git log --oneline --decorate --tags
```

Or compare versions visually:

```bash
git diff v1.0.36..v1.1.0
```

We strongly recommend inspecting any update **before** replacing your current version in production CI.

------

### 🛠 C.6.3 — Upgrading Safely from a Cloned Repo

If you cloned Beargrease into your own project (rather than using it as a GitHub Action), follow these steps to upgrade safely:

```bash
# Save your current version
git tag current-safe-version

# Fetch new changes
git remote add upstream https://github.com/rgmelvin/beargrease-by-cabrillo.git
git fetch upstream

# Check the diff
git diff current-safe-version..upstream/v1.1.0

# Merge safely
git merge upstream/v1.1.0
```

If you have customized Beargrease (e.g., changed scripts), **use git diff to resolve those changes manually**.

------

### 🔄 C.6.4 — Replacing GitHub Action Versions

In a GitHub Actions workflow, upgrade Beargrease by editing the `uses:` tag:

```yaml
- name: Run Beargrease
  uses: rgmelvin/beargrease-by-cabrillo@v1.1.0   # Upgrade here
```

Avoid using `@main` in CI unless you are directly developing Beargrease. Always test new tags locally or in a staging branch first.

------

### 🧪 C.6.5 — How to Verify Upgrades with Tests

Once upgraded, run the following checks:

1. **Rebuild your Anchor program:**

   ```bash
   anchor build
   ```

2. **Re-run Beargrease locally:**

   ```bash
   ./scripts/run-tests.sh
   ```

3. **Trigger a CI run on a feature or staging branch.**

4. **Confirm the validator boots, program deploys, and tests pass.**

If anything breaks, you can roll back immediately:

```bash
git checkout current-safe-version
```

Or revert your GitHub Action back to the prior tag:

```yaml
uses: rgmelvin/beargrease-by-cabrillo@v1.0.36
```

------

## 