Beargrease Beginner Guide (Local Mode v1.0 - v1.1)
=================================
> ⚠️ **Archived Guide**
> 
> This document was part of a prior working draft or release.
> 
> Please use the updated version here: [📘 Beginner Guide v1.1.0](../BeginnerGuide.md)

> ⚠️ **Notice: Two Modes of Use**
>
> This guide describes **Local Mode (v1.0.x–v1.1.x)** of Beargrease. In this mode, you manually copy Beargrease scripts into your test project (e.g., *placebo*) and > run them locally using Bash.
>
>
> If you are using Beargrease for **GitHub CI**, please refer instead to the new companion document:
>
> 👉 **[Beginner’s Guide to v1.1.0 Directory Checkout Mode for CI](./BeginnerGuide-CI.md)**  
>
> The two guides are complementary but distinct. Follow the one that matches your environment.


### Transparent Solana Testing Infrastructure

**Developed by Cabrillo!**\
**Contact:** cabrilloweb3\@gmail.com\
**License:** MIT License\
**Repository:** <https://github.com/rgmelvin/beargrease-by-cabrillo>

Beargrease is a transparent, script-based test harness for Solana smart contract development. It provides a complete test cycle using Docker, supporting both Anchor and TypeScript test runners, and integrates seamlessly into CI/CD pipelines. Every step is inspectable and modifiable, empowering developers to understand and control their test environments.

This guide introduces new users to Beargrease step by step, with comprehensive explanations, working examples, CI integration
instructions, and advanced test scenarios. It is written in the spirit of Cabrillo!\'s philosophy: helpful, transparent tools that empower developers, not abstract away their control.



## Table of Contents

### General Structure

- [Part I — Getting Started with Beargrease](#beargrease-beginner-guide-part-i)
- [Part II — Exploring Advanced Usage](#beargrease-beginner-guide---part-ii-exploring-advanced-usage)
- [Part III — CI & Multi-Wallet Testing](#beargrease-beginner-guide---part-iii)
- [Part IV — Advanced Scenarios & Real-World Integration](#beargrease-beginner-guide-part-iv)
- [Appendix A — Tool Comparison](#appendix-a-tool-comparison)
- [Appendix B — Troubleshooting and Technical Reference](#appendix-b-troubleshooting-beargrease)

---

### Part I — Getting Started with Beargrease

- [Step 0: What is Beargrease?](#step-0-what-is-beargrease)
- [Step 1: Install Required Tools](#step-1-install-required-tools)
- [Step 2: Clone and Inspect Beargrease](#step-2---clone-and-inspect-beargrease)
- [Step 3: Clone the Example Project (*placebo*)](#step-3-clone-the-example-test-project-placebo)
- [Step 4: Copy Beargrease into *placebo*](#step-4-copy-beargrease-scripts-into-placebo)
- [Step 5: Check Project Requirements](#step-5-check-placebo-requirements)
- [Step 6: Run the Test Harness](#step-6-run-the-beargrease-test-harness)
- [What Just Happened?](#what-just-happened)

---

### Part II — Exploring Advanced Usage

- [Step 7: Use TEST_RUNNER](#step-7-use-test_runner-to-select-a-test-mode)
- [Step 8: Anatomy of Beargrease Scripts](#step-8-anatomy-of-beargrease-scripts)
- [Step 9: Debugging and Logs](#step-9-debugging-and-logs)
- [Step 10: Use Beargrease with Your Own Project](#step-10-use-beargrease-with-your-own-project)

---

### Part III — CI & Multi-Wallet Testing

- [Section 1: GitHub Actions Integration](#section-1-github-actions---continuous-integration-ci)
- [Section 2: Multi-Wallet Test Setup](#section-2-multi-wallet-test-setup)
- [Part III Summary](#part-iii-summary-ci-and-multi-wallet-testing)

---

### Part IV — Advanced Scenarios & Real-World Integration

- [Preloading the Validator](#1-preloading-the-validator)
- [Testing SPL Token Flows](#2-testing-spl-token-interactions-with-beargrease)
- [Full Integration Testing (web3.js)](#3-full-integration-testing-with-web3js)
- [Multi-Service Project Testing](#4---full-project-integration-multi-service-app-testing-with-beargrease)
- [Part IV Summary](#part-iv-summary---advanced-test-scenarios-with-beargrease)

---

### Appendix A — Tool Comparison

- [Appendix A.1: Beargrease vs Solana Playground vs Anchor CLI vs Amman](#appendix-a-tool-comparison)

---

### Appendix B — Troubleshooting and Technical Reference

- [B.1 — If the First Run Fails](#appendix-b1---if-the-first-run-of-beargrease-fails)
- [B.2 — Validator Startup Issues](#appendix-b2---troubleshooting-validator-startup)
- [B.3 — Wallet Not Found](#appendix-b3---wallet-not-found-or-improperly-named)
- [B.4 — Wallet Funding Failed](#appendix-b4---wallet-funding-failed)
- [B.5 — Anchor Build Fails](#appendix-b5---jq-or-program-id-script-errors)
- [B.6 — Anchor Deploy Fails](#appendix-b6---final-hand-off-validator-will-not-start)
- [B.7 — Examining Test Logs](#appendix-b7---examining-beargrease-test-logs)
- [B.8 — Manual Script Execution Flow](#appendix-b8---manual-script-execution-flow)
- [B.9 — GitHub Actions and Secure CI](#appendix-b9---github-actions-and-secure-continuous-integration)
- [B.10 — Migration Guide: Beargrease ↔ Amman](#appendix-b10---migration-guide-beargrease--amman)



Cabrillo! proudly builds tools like Beargrease in service of a more transparent, accountable, and community-friendly Web3 development culture. We believe tools should teach and reveal --- not hide and abstract. Join us in making development easier to inspect, safer to test, and better to share.



## Abstract

**Beargrease** is a fully scriptable, transparent test harness for Solana smart contract development. Designed to work seamlessly with Anchor and Docker, it provides a complete testing environment that can be inspected, modified, and integrated into real-world CI pipelines. This guide serves as a comprehensive tutorial for developers ranging from beginners to advanced users. It walks through installation, test execution, multi-wallet scenarios, CI integration, and advanced use cases such as SPL token testing and full-stack application workflows. Each section is enriched with practical examples, deep troubleshooting appendices, and thoughtful guidance to help developers gain confidence and control over their Solana testing workflow.



****

## Introduction

Solana development is powerful, but the local testing environment can often feel opaque or fragile. **Beargrease** was created to fix that. It offers a transparent, script-based harness that lets you run local validators, fund wallets, build programs, and execute tests---all in a clearly auditable and customizable sequence.

**Beargrease** shows its work. Every operation is a shell script you can read, edit, and debug. This **Beginner Guide** is your key to mastering Beargrease. From a simple first run with the placebo demo, all the way to multi-service integration testing, we'll walk you through real workflows that real developers use.

Beargrease isn't just about testing. It's about teaching. Whether you're a student, a researcher, a solo builder, or a member of a growing team, this guide will give you confidence in your tools and clarity in your process.

Welcome to Beargrease.

**About Cabrillo!**

Cabrillo! is an initiative devoted to building open, transparent, and professionally-structured development tools for the Solana ecosystem and beyond. We believe in clarity over magic, learnability over abstraction, and craftsmanship over shortcuts.

Beargrease is part of our broader mission to support developers with tools that respect their curiosity, their need to learn, and their desire to build robust, maintainable applications. If something goes wrong, we want you to know how to fix it. If something works, we want you to know why.

We hope Beargrease becomes your go-to tool not just because it works, but because it teaches you what working means.



****

Beargrease Beginner Guide: Part I
-----------------------------------------



****

### Step-by-Step Introduction for New Users



### Step 0: What is Beargrease?

**Beargrease** is a transparent, script-based test harness designed to run **Solana smart contract **tests in a local **Docker** environment. It simplifies the development workflow by automating the setup, funding, deployment, and teardown of a **Solana** validator --- all while staying readable and editable.

There is no abstraction layer or hidden scaffolding. You can inspect and modify every script it uses.

**Beargrease** performs the following operations in order:

1.  🐳 Starts a Dockerized Solana test validator

2.  💰 Funds one or more test wallets with SOL

3.  🔨 Builds your Anchor program

4.  🚀 Deploys the program to the local validator

5.  🧬 Updates the program ID in your source code

6.  ✅ Runs tests using **anchor test** or **yarn test**

7.  🧹 Shuts down and cleans up the validator

Once you\'ve walked through this guide, you\'ll understand how to:

-   Use Beargrease with the included example project (*placebo*).

-   Run full test cycles against your own Solana Anchor programs.

-   Troubleshoot and customize Beargrease scripts.

➡️ Let's begin with tool installation.



### Step 1: Install Required Tools

Beargrease relies on a handful of CLI tools. Please install these first.



#### 1.1: Docker

Beargrease runs a Solana validator using Docker.

🧪 **See: Docker Installation Guide** for step-by-step instructions, including cleanup of Snap-based installs, user permissions, and
troubleshooting tips.

Once Docker is installed:

➤ **Run:**

```bash
docker --version
docker run hello-world
```

👀 **You should see:**

-   A version string like `Docker version 26.1.3, build \...`
-   A message that begins `Hello from Docker!`

👍 **Success: **Docker is ready.



#### 1.2: Solana CLI

This CLI is used to manage wallets and validator interactions.

➤ **Run:**

```bash
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
```

📌 **Important: Add Solana to Your PATH**

After installation, the script will print a message like this:

```
Please update your PATH environment variable by adding the following line:
export PATH="/home/rgmelvin/.local/share/solana/install/active_release/bin:$PATH"
```

To make `solana` work **right away**, you can paste this line into your terminal:

```bash
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
```

To make this change **permanent**, add the line to your shell profile:

- If you use Bash:

  ```bash
  echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
  ```

- If you use Zsh:

  ```zsh
  echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.zshrc
  ```

Then **restart your terminal** to apply the change.

After installation:

➤ **Run:**

```bash
solana --version
```

👀 **You should see:**

```bash
*solana-cli 2.1.21 (src:8a085eeb; feat:1416569292,client:Agave)*
```



#### 1.3: Anchor CLI

Anchor is used to build and deploy Solana programs. It must be installed using Cargo (Rust's package manager).

➤ **Run:**

```bash
cargo install --git https://github.com/coral-xyz/anchor anchor-cli --locked
```

After installation:

➤ **Run:**

```bash
anchor --version
```

👀 **You should see something like**:

```bash
anchor-cli 0.31.1
```



#### 1.4: jq (JSON Query Tool)

Beargrease uses *jq* to update program IDs inside your source files.

**On Linux**:
➤ **Run:**

```bash
sudo apt install jq
```

**On macOS**:
➤ **Run:**

```bash
brew install jq
```

➤ **Run:**

```bash
jq -- version
```

👀 **You should see something like**:

```bash 
jq-1.6
```

✅ Once all tools are installed, you\'re ready to move on.

➡️ Proceed to **Step 2: Clone and Inspect Beargrease**



Step 2 --- Clone and Inspect Beargrease
-----------------------------------------------

****

Beargrease is stored in a public GitHub repository. In this step, you'll create a working project directory, then clone Beargrease into it.

🧠 **Why this matters**: You'll be adding Beargrease scripts into your own projects later, so having a clean and well-organized workspace helps avoid path confusion.

 

### 2.1: Create a Working Directory

We suggest organizing your projects under something like:



```bash
mkdir -p ~/Projects/cabrillo
cd ~/Projects/cabrillo
```

👀You are now inside: *\~/Projects/cabrillo/*

This is where you will put both Beargrease and the example project (*placebo*) in the next steps.



### 2.2: Clone Beargrease

➤ **Run:**

```bash
git clone https://github.com/rgmelvin/beargrease-by-cabrillo.git
```

**Then:**

```bash
cd beargrease-by-cabrillo
```

👀 You should now be inside: *\~/Projects/cabrillo/beargrease-by-cabrillo/*

📁 Here is what your structure looks like so far:

Projects/
└── cabrillo/
    └── beargrease-by-cabrillo/
        └── scripts/
            ├── run-tests.sh
            ├── start-validator.sh
            ├── shutdown-validator.sh
            ├── fund-wallets.sh
            ├── update-program-id.sh
            ├── version.sh
            ├── create-test-wallet.sh
            ├── airdrop.sh
            └── wait-for-validator.sh

 

### Step 2 is complete. You are now ready to clone the test project that will use these scripts.

➡️ Continue to **Step 3: Clone the Example Test Project**.



Step 3: Clone the Example Test Project (*placebo*)
------------------------------------------------------------------------

****

To verify that Beargrease works correctly, we provide a minimal example project called *placebo*. *placebo* is a simple Anchor program that has no external dependencies --- it is built to test whether your environment is correctly configured.



### 🧭 Step 3.1 --- Navigate to the Projects Directory

➤ **Run:**

```bash
cd ~/Projects/cabrillo
```

This is the same folder you created in Step 2.1. If you're not sure, go back and verify the folder structure.

 

### 🧭 Step 3.2 --- Clone `Placebo`

➤ **Run:**

```bash
git clone https://github.com/rgmelvin/placebo.git
cd placebo
```

You now have a minimal Anchor test program called *placebo* on your machine.

##### 🗂️ Directory Structure

Projects/
├── cabrillo/
│   ├── beargrease-by-cabrillo/
│   │   └── scripts/
│   │       ├── run-tests.sh
│   │       ├── start-validator.sh
│   │       ├── shutdown-validator.sh
│   │       ├── fund-wallets.sh
│   │       ├── update-program-id.sh
│   │       ├── version.sh
│   │       ├── create-test-wallet.sh
│   │       ├── airdrop.sh
│   │       └── wait-for-validator.sh
│   └── placebo/
│       ├── Anchor.toml
│       ├── Cargo.toml
│       ├── migrations/
│       ├── programs/
│       ├── scripts/        ← (to be created in Step 4)
│       └── tests/



✅ You've now cloned both **Beargrease** and the example *placebo* test project.

➡️ Continue to **Step 4: Copy Beargrease Scripts into *placebo***.



Step 4: Copy Beargrease Scripts into *placebo*
----------------------------------------------------------

****

To use Beargrease with the *placebo* test project, you need to copy the Beargrease script directory into *placebo*. These scripts will control the validator, fund your test wallets, update your deployed program ID, and execute your tests.

 

### 🧭 Step 4.1 --- Create the **scripts/** Directory in Placebo

If the **scripts/** directory doesn't already exist inside the *placebo* project folder, create it:

➤ **Run:**

```bash
mkdir -p ./scripts
```

This is where Beargrease scripts will live inside *placebo*.



### 🧭 Step 4.2 --- Copy the Beargrease Scripts

From inside the *placebo* directory:

➤ **Run: **

```bash
cp -r ../beargrease-by-cabrillo/scripts ./scripts/beargrease
```

This copies the full Beargrease test harness into your *placebo*project.

👉 You do **not** need to copy scripts if you're using Beargrease in GitHub CI — see [CI Beginner Guide](./BeginnerGuide-CI.md).




### 🧭 Step 4.3 --- Make the Scripts Executable

➤ **Run:**

```
chmod +x ./scripts/beargrease/*.sh
```

This allows the shell to run the Beargrease scripts directly.

##### 🗂️ Updated Directory Structure

Projects/
└── cabrillo/
    ├── beargrease-by-cabrillo/
    │   └── scripts/
    │       ├── run-tests.sh
    │       ├── start-validator.sh
    │       ├── shutdown-validator.sh
    │       ├── fund-wallets.sh
    │       ├── update-program-id.sh
    │       ├── version.sh
    │       ├── create-test-wallet.sh
    │       ├── airdrop.sh
    │       └── wait-for-validator.sh
    └── placebo/
        ├── Anchor.toml
        ├── Cargo.toml
        ├── migrations/
        ├── programs/
        ├── scripts/
        │   └── beargrease/
        │       ├── run-tests.sh
        │       ├── start-validator.sh
        │       ├── shutdown-validator.sh
        │       ├── fund-wallets.sh
        │       ├── update-program-id.sh
        │       ├── version.sh
        │       ├── create-test-wallet.sh
        │       ├── airdrop.sh
        │       └── wait-for-validator.sh
        └── tests/

👍 **Success:** Beargrease is now integrated into the *placebo* project.

➡️ Continue to **Step 5: Check Placebo Requirements**.



Step 5: Check Placebo Requirements
----------------------------------

Before running Beargrease, make sure the *placebo* project has the necessary configuration and test wallet.



### 🧭 5.1: Confirm Anchor Configuration

Beargrease expects an Anchor project to be properly initialized.

✅ Check for the presence of this file:*Anchor.toml*

This file should be located at the root of your *placebo* project
directory. If it\'s missing, re-initialize the project with:

**➤ Run:**

```bash
anchor init
```

**Note: You don't need to run **`anchor init` if you cloned the**placebo** demo --- it should already be **configured.**



### 🧭 5.2: Create a Test Wallet

Beargrease needs at least one test wallet to fund and run transactions with.

The test wallet should be saved to:

```bash
.ledger/wallets/test-user.json
```

To create it manually,

➤ **Run:***

```bash
mkdir -p .ledger/wallets
solana-keygen new --outfile .ledger/wallets/test-user.json
```

This creates a new keypair and saves it as `test-user.json`.

::: tip
`scripts/airdrop.sh` is a container-aware, interactive script.  
It guides you through SOL airdrops with input validation, safe defaults, and fallback to local or Docker mode - no guesswork required.
:::




### 🧪 Optional: Set Up TypeScript Testing

If your project includes TypeScript tests, make sure your *package.json*
includes the *test runner* configuration.

Look for (or add) the following section:

```json
"scripts": { 
"test": "ts-mocha -p ./tsconfig.json -t 1000000 'tests/**/*.ts'" 
}
```

This allows Beargrease to run tests with *yarn test*.



### ✅ Once these requirements are met:

-   You have an Anchor project with **Anchor.toml**
-   You have a test wallet at **.ledger/wallets/test-user.json**
-   (Optional) Your test runner is configured

➡️ You are ready for **Step 6: Run the Test Harness**.



### Step 6: Run the Beargrease Test Harness

At this point, you have all Beargrease scripts installed, your projectrequirements set up, and your wallet ready. You are now ready to run Beargrease for the first time.

👉 If you're using GitHub CI instead of local testing, Beargrease runs as part of your CI workflow — see the [CI Beginner Guide](./BeginnerGuide-CI.md).


#### 6.1: Basic Usage

From the root of the *placebo* directory,

➤ **Run:**

```bash
./scripts/beargrease/run-tests.sh
```



This is the default launch mode. Beargrease will:

1. Start a Dockerized *solana-test-validator*

2. Wait for the validator to become healthy

3. Fund all wallets in *.ledger/wallets/*

4. Build and deploy your Anchor program

5. Update the program ID in your source code

6. Run tests using either ***anchor test*** or **yarn test**

7. Shut down the validator cleanly

   

#### 6.2: Choose a Test Runner (Optional)

By default, Beargrease will auto-detect your test runner. If it finds TypeScript tests (via *yarn.lock* and *package.json*), it will run them. Otherwise, it falls back to Rust/Anchor tests.

You can override this by setting the *TEST\_RUNNER* environment variable:

```bash
*TEST\_RUNNER=anchor ./scripts/beargrease/run-tests.sh*

*TEST\_RUNNER=yarn ./scripts/beargrease/run-tests.sh*
```

This is useful if you want to test only one mode explicitly.



#### 6.3: What to Expect

If everything is working, you will see output like:

```shell
🌟 Starting solana-test-validator via Docker...
✅ Docker container 'beargrease-validator' is running.
```

*\...*

```shell
🌟 Starting solana-test-validator via Docker...
✅ Docker container 'beargrease-validator' is running.
🔐 Funding wallet: .ledger/wallets/test-user.json*
```

*\...*

```shell
🌟 Starting solana-test-validator via Docker...
✅ Docker container 'beargrease-validator' is running.
🔐 Funding wallet: .ledger/wallets/test-user.json*
📦 Building Anchor program
```

*\...*

```shell
🌟 Starting solana-test-validator via Docker...
✅ Docker container 'beargrease-validator' is running.
🔐 Funding wallet: .ledger/wallets/test-user.json*
📦 Building Anchor program
🚀 Deploying Anchor program to local validator
```

*\...*

```shell
🌟 Starting solana-test-validator via Docker...
✅ Docker container 'beargrease-validator' is running.
🔐 Funding wallet: .ledger/wallets/test-user.json*
📦 Building Anchor program
🚀 Deploying Anchor program to local validator
🔁 Detected test runner: yarn
🧪 Running TypeScript tests...
```

*\...*

```shell
🌟 Starting solana-test-validator via Docker...
✅ Docker container 'beargrease-validator' is running.
🔐 Funding wallet: .ledger/wallets/test-user.json*
📦 Building Anchor program
🚀 Deploying Anchor program to local validator
🔁 Detected test runner: yarn
🧪 Running TypeScript tests...
✅ Tests complete
🧹 Shutting down validator...
```

At the end of the process, the Docker container will be cleaned up and you will return to the command prompt.

✅ **Success:** Beargrease has completed a full run. Your program has been built, deployed, and tested against a local validator.

🧪 **See: **Appendix B.1 --- Troubleshooting First Beargrease Run



### What Just Happened?

You just used Beargrease to perform a full-cycle local test of your Anchor program. Here\'s what Beargrease actually did, step-by-step:

1.  🐳 **Launched a Dockerized Solana validator**
2.  ⏳ **Waited for the validator to become healthy**
3.  💰 **Funded your test wallet** from *.ledger/wallets/*
4.  🛠️ **Built your Anchor program** using *anchor build*
5.  🚀 **Deployed your program** to the local validator
6.  🧬 **Updated the on-chain *programId*** in your source files using *jq*
7.  🧪 **Ran your test suite** (TypeScript or Rust)
8.  🧹 **Shut down the validator container** cleanly

If everything worked, you should have seen:

```shell
✅ Docker container 'beargrease-validator' is running.
...
✅ Tests completed.
🎉 Done.
```



### Didn't Get That Output?

If any step failed, consult these appendices based on what went wrong:

🧪 **Tests didn't run or the process failed mid-way?**

👉 Appendix B.1 - Troubleshooting First Beargrease Run



🧪 **No validator output or Docker failed?**

👉 Appendix B.2 - Validator Startup Issues



🧪 **Wallet missing or corrupt?**

👉 Appendix B.3 - Wallet Not Found or Missnamed



🧪 **Wallet couldn't be funded?**

👉 Appendix B.4 - Wallet Funding Failed



🧪 **Anchor failed to build the program?**

👉 Appendix B.5 - Anchor Build Fails



🧪 **Deploy phase failed or crashed?**

👉 Appendix B.6 - Anchor Deploy Fails



🧪 **Tests fail with errors, unexpected output, or panics?**

👉 Appendix B.7 - Examining Test Logs



### 👍 If everything worked

You now have:

- A working Beargrease installation.

- A test wallet ready for reuse.

- A passing Anchor program.

- A fully functional local Solana validator environment.

  

➡️ Continue to: **Part II --- Exploring Advanced Usage**



Beargrease Beginner Guide --- Part II: Exploring Advanced Usage
-------------------------------------------------------------------

This section expands on what you learned in Part I. Now that you have completed a full run of Beargrease using the *placebo* example project, you are ready to explore custom test setups, script internals, and integration into your own projects.

Our goal here is to demystify each component of Beargrease so you can:

-   Choose between different test runners.
-   Modify the script behavior to fit your project.
-   Debug and analyze failures.
-   Use Beargrease with your own smart contracts.

We'll walk through each capability step by step, using examples and clear instructions.



### Step 7: Use *TEST\_RUNNER* to Select a Test Mode

Beargrease supports both Rust-based (Anchor) tests and TypeScript tests. By default, it will try to auto-detect your test type. However, you can manually override this with the *TEST\_RUNNER* environment variable.



#### 7.1 Anchor Mode

```bash
TEST_RUNNER=anchor ./scripts/beargrease/run-tests.sh`
```

This will run: `anchor test` against your program.



#### 7.2 Yarn Mode

```bash
*TEST_RUNNER=yarn ./scripts/beargrease/run-tests.sh*
```

This will run: `yarn test` from the root of your project.



#### Why it Matters

If you have both TypeScript and Anchor tests in your project, the auto-detection might pick the wrong one. Setting the environment variable ensures Beargrease runs the right tests for your debugging session.



### Step 8: Anatomy of Beargrease Scripts

Beargrease is completely script-driven. Each shell script performs a clear, modular task. This makes it easy to inspect, debug, and
customize.



#### 8.1 Core Script: `run-tests.sh`

This script coordinates the entire test run. It:

- Starts the validator (via `start-validator.sh`)

- Waits for the validator to be ready

- Funds all wallets in `.ledger/wallets`

- Builds your Anchor program

- Deploys your Anchor program

- Detects the test runner and runs your tests

- Shuts down the validator (via `shutdown-validator.sh`)

  

#### 8.2 Beargrease Supporting Scripts

------------------------- -------------------------------------------------------------
| Script Name           | Purpose                                                   |
| --------------------- | --------------------------------------------------------- |
| start-validator.sh    | Launches Docker validator container                       |
| shutdown-validator.sh | Stops and removes validator container                     |
| fund-wallets.sh       | Airdrops SOL to all wallets in .ledger/wallets/           |
| update-program-id.sh  | Updates your local source files with the new program ID   |
| create-test-wallet.sh | Generates new Solana keypair for use as a test wallet     |
| airdrop.sh            | Simple wrapper to airdrop 2 SOL to a given pubkey         |
| wiat-for-validator.sh | Waits for the validator to be reachable at localhost:8899 |
| version.sh            | Prints the Beargrease version                             |

#### Pro Tip:

All of these scripts are plain Bash scripts and can be opened, modified, and run individually. Beargrease is designed to be learnable --- not magical.

🧪 See: Appendix B.8 --- Manual Script Execution Flow



### Step 9: Debugging and Logs

Beargrease emits all logs to *stdout*. If a test fails or a step is skipped, the log will show the reason.



#### 9.1 Inspect Test Output

Look for error messages, failed test cases, or unexpected output in the terminal. Scroll up from the failure point to see what led up to it.



#### 9.2 View Validator Logs Directly

```bash
docker logs beargrease-validator
```

This gives you full access to:

-   Solana runtime errors.
-   Anchor program logs (*e.g.* *msg!()*).
-   Validator startup issues.

🧪 See: Appendix B.7 --- Examining Beargrease Test Logs



###

### Step 10: Use Beargrease with Your Own Project

Once you're comfortable running Beargrease with *placebo*, you can adapt it to test your own Solana programs.

#### 10.1 Initialize a New Anchor Project

```bash
anchor init myproject
cd myproject
```



#### 10.2 Copy Beargrease Scripts

```bash
mkdir -p scripts
cp -r ../beargrease-by-cabrillo/scripts ./scripts/beargrease
chmod +x ./scripts/beargrease/*.sh
```



#### 10.3 Create a Test Wallet

```bash
mkdir -p .ledger/wallets
solana-keygen new --outfile .ledger/wallets/test-user.json
```



#### 10.4 Run Beargrease

```bash
./scripts/beargrease/run-tests.sh
```

🎉 If everything is configured correctly, your project will build, deploy, and test just like *placebo*.

🧪 See: Appendix B.1 --- Troubleshooting First Beargrease Run



****

## Beargrease Beginner Guide --- Part III



Section 1: GitHub Actions --- Continuous Integration (CI)
---------------------------------------------------------

**Continuous Integration (CI)** ensures that your Solana smart contract project remains buildable and testable --- even as you or your team make changes. Beargrease fits naturally into this workflow because its scripts are non-interactive and containerized.

This section will walk you through setting up Beargrease on GitHub Actions.



### Why CI Matters for Solana Projects

CI automatically:

- Builds your program.

- Deploys it to a Docker-based validator.

- Runs tests on every push or pull request.

- Catches regressions early.

- Keeps your project reliable and collaboration-friendly.

  

GitHub Actions provides a free, cloud-based environment to run this.



Step 1: Create Your Workflow File
---------------------------------

GitHub Actions workflows live in the *.github/workflows/ folder*.

From the root of your project, create the directory and file:

```bash
mkdir -p .github/workflows
touch .github/workflows/beargrease.yml
```



Sample Workflow: **beargrease.yml**
-----------------------------------

```yaml
name: Beargrease Tests

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: 📥 Checkout Code
        uses: actions/checkout@v3

      - name: 🔧 Install System Dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y curl jq libssl-dev pkg-config build-essential
          sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
          cargo install --git https://github.com/coral-xyz/anchor anchor-cli --locked
          yarn install

      - name: 🧪 Run Beargrease
        run: ./scripts/beargrease/run-tests.sh

```



Required Project Structure for CI
---------------------------------

To run Beargrease in CI, your repository must include:

- Beargrease scripts in *./scripts/beargrease/.*

- *.ledger/wallets/* directory with one or more test wallets.

- Anchor project with *Anchor.toml* at the root.

- TypeScript tests (optional).

  

CI Environment Notes
--------------------

- GitHub Actions starts with an empty environment. You must install all tools each time.

- Use *yarn install* if you have a **package.json** with test dependencies.

- You may want to pin versions of Solana CLI, Anchor, and Rust for reproducibility.

- You can add caching later for faster runs.

  

Success Case
------------

If everything is working, your GitHub Action run will output:

```none
🌟 Starting solana-test-validator via Docker...
✅ Docker container 'beargrease-validator' is running.
🔐 Funding wallets...
📦 Building program...
🚀 Deploying...
🧪 Running tests...
🎉 Done.
```



Common CI Pitfalls
------------------

-   Docker permissions denied? Use *runs-on: ubuntu-latest* --- it has Docker.
-   "*Command not found*"? Check that Anchor, Solana CLI, and Cargo are installed.
-   *Wallet not found*? Ensure *.ledger/wallets/test-user.json* exists and is checked in (or generated).

🧪 For a more detailed treatment of GitHub Actions, **See: Appendix B.9 --- GitHub Actions and Secure Continuous Integration**



****

When This Works...
------------------

You now have:

-   End-to-end CI for your smart contracts.
-   Automatic test validation on every push.
-   Early failure detection for regressions or broken commits.

**➡️  When ready, continue to Section 2: Multi-Wallet TestSetup**



****

## Section 2: Multi-Wallet Test Setup.

Beargrease supports multiple test wallets out of the box. This allows you to test scenarios that involve different actors with different permissions and account states. Whether you\'re building DAOs, marketplaces, or collaborative applications, testing multi-wallet flows is crucial.

This section walks you through everything you need to know to:

- Create and manage multiple wallets.

- Fund them automatically before tests.

- Load them inside TypeScript or Rust tests.

- Use them in GitHub Actions securely.

  

Step 1: Create Multiple Wallets
-------------------------------

Beargrease provides a script to make wallet creation painless.

From the root of your project, run:

```bash
./scripts/beargrease/create-test-wallet.sh alice
./scripts/beargrease/create-test-wallet.sh bob
```

This will generate:

*.ledger/wallets/alice.json*

*.ledger/wallets/bob.json*

Each is a valid Solana keypair file.



Step 2: Fund All Wallets Automatically
--------------------------------------

Beargrease includes a wallet funding script that airdrops SOL to every keypair found in *.ledger/wallets/*. You do not need to modify this script to support multiple wallets.

```bash
./scripts/beargrease/fund-wallets.sh
```

This script will:

-   Iterate over every *.json* file in *.ledger/wallets/*.
-   Extract the public key.
-   Use **solana airdrop** to fund it with 2 SOL.

You will see output like:

```none
📬 Funding wallet: .ledger/wallets/alice.json
📬 Funding wallet: .ledger/wallets/bob.json
```



Step 3: Load Multiple Wallets in Your Tests
-------------------------------------------

In your TypeScript tests, load wallets like this:

```typescript
import * as anchor from "@coral-xyz/anchor";
import fs from "fs";

const aliceKeypair = anchor.web3.Keypair.fromSecretKey(
  Uint8Array.from(
    JSON.parse(fs.readFileSync(".ledger/wallets/alice.json", "utf8"))
  )
);

const bobKeypair = anchor.web3.Keypair.fromSecretKey(
  Uint8Array.from(
    JSON.parse(fs.readFileSync(".ledger/wallets/bob.json", "utf8"))
  )
);

const provider = anchor.AnchorProvider.local();
const program = anchor.workspace.MyProgram as anchor.Program;

it("Alice sends to Bob", async () => {
  const tx = await program.methods
    .someInstruction()
    .accounts({
      sender: aliceKeypair.publicKey,
      recipient: bobKeypair.publicKey
    })
    .signers([aliceKeypair])
    .rpc();

  console.log("TX:", tx);
});

```

This allows you to sign with different wallets per instruction.



Step 4: Use Multi-Wallet in GitHub Actions
------------------------------------------

In GitHub CI, you must pass in each wallet as a secret.

### 4.1: Create and Export Wallets

```bash
solana-keygen new --outfile alice.json
solana-keygen new --outfile bob.json
cat alice.json | jq -c . > alice-secret.txt
cat bob.json | jq -c . > bob-secret.txt
```



### 4.2: Store Secrets in GitHub

Go to:

-   GitHub Repo \> Settings \> Secrets \> Actions

-   Create secrets:

    - *ALICE\_WALLET*
    
    - *BOB\_WALLET*
    
      

Paste the contents of each *\*-secret.txt* file.



### 4.3: Restore in Workflow

In your GitHub Actions *.yml* file:

```yaml
- name: Restore multiple test wallets
  run: |
    mkdir -p .ledger/wallets
    echo "$ALICE_WALLET" > .ledger/wallets/alice.json
    echo "$BOB_WALLET" > .ledger/wallets/bob.json
  shell: bash
  env:
    ALICE_WALLET: ${{ secrets.ALICE_WALLET }}
    BOB_WALLET: ${{ secrets.BOB_WALLET }}

```

This setup gives you multi-wallet test support in CI without exposing private keys.



Final Thoughts
--------------

Multi-wallet testing is essential for serious Solana applications. Beargrease was built to make this straightforward:

- Use *.ledger/wallets/* for organizing keys.

- Fund automatically before each run.

- Load wallets explicitly in your tests.

- Use GitHub Secrets for secure automation.

  

🧪 You can extend this approach to 3, 5, or 20 wallets as needed. The funding and access model remains the same.



📌 If your multi-wallet tests aren't behaving as expected:

- Re-check wallet ordering and file names.

- Confirm public keys match expected roles.

- Review test logs for anchor errors (e.g., constraint violations).

  

Beargrease will test what you teach it to test. Multi-wallet workflows are just another script away.



Part III Summary: CI and Multi-Wallet Testing
-------------------------------------------------

By completing Part III, you've now equipped your Solana project with a full Continuous Integration (CI) pipeline, and unlocked powerful multi-wallet testing capabilities.

You have learned how to:

-   🔧 Set up GitHub Actions to run Beargrease on every push or pull request.
-   🔐 Store and retrieve wallet keypairs securely using GitHub Secrets.
-   🚀 Run Beargrease inside GitHub's CI environment --- no extra Docker configuration needed.
-   📦 Use caching for Node and Rust dependencies to speed up builds.
-   👥 Run complex tests using multiple simulated users (wallets) via TypeScript or Anchor.
-   🧪 Keep every test run isolated, reproducible, and easy to inspect.

Beargrease turns your test harness into a portable, automated, team-friendly environment that mirrors the reality of multi-user Solana applications.

### What Comes Next?

In **Part IV: Advanced Test Scenarios**, you'll explore how to:

-   Preload the validator with existing on-chain state.
-   Simulate SPL token flows within tests.
-   Run full integration tests with *web3.js* transactions.
-   Extend Beargrease to real-world project setups, where frontends and contracts must cooperate.

Beargrease is not just for toy projects --- it's designed to scale with you as your architecture becomes more complex.

🔁 Missed a step or want to add CI to a new project? You can copy your*.github/workflows/beargrease.yml*, *.ledger/wallets*, and
*scripts/beargrease/* directory into any Anchor project --- it's fully portable.

💬 Need help? Reach out to me at cabrilloweb3\@gmail.com or open an issue in the GitHub repository. I will do my best to help you.

➡️ Continue to **Part IV: Advanced Test Scenarios**.



****

## Beargrease Beginner Guide: Part IV



Advanced Test Scenarios and Real-World Integration
--------------------------------------------------

Beargrease isn\'t just for toy projects. This section explores how to integrate Beargrease into complex, real-world Solana workflows, including scenarios involving frontend coordination, token mechanics, and preloaded ledger state.

These are the kinds of tests you will need if you\'re building production systems --- DAOs, full-stack dApps, DePIN protocols, or
multi-role applications.

### 1. Preloading the Validator

This section helps users simulate existing on-chain state by preloading accounts, mints, or ledgers into the **solana-test-validator**. It is especially useful for:

- Testing programs that depend on pre-initialized accounts or config.

- Simulating minting, staking, governance, or token registries.

- Running integration tests against known state.

  

#### Why preload state?

Some programs expect accounts to already exist before they can be tested (*e.g.*, admin config accounts, SPL mints, program-owned registries). Instead of initializing those during the test itself, you can **bootstrap** them into the validator ahead of time using a **custom ledger directory**.



#### 🛠 How to do it with Beargrease:

### Step 1: Create a Bootstrap Ledger Locally

You will manually launch a validator, initialize your accounts, and
export them.

```bash
mkdir -p custom-ledger
solana-test-validator --ledger custom-ledger --reset
```

Open a second terminal:

```bash
# Example: create and save a config account to preload later
solana-keygen new --outfile my-config-keypair.json
solana address -k my-config-keypair.json

# Use your Anchor client or solana CLI to initialize it:
anchor run initialize-config
```

After initializing:

```bash
solana account <YOUR_CONFIG_PUBKEY> --output json-compact > my-config.json
```

Repeat for any accounts you want to preload. Save each to its own file.



### Step 2: Mount Accounts into Docker via Beargrease

Once your account dumps are ready, copy them into a dedicated folder:

your-project/
├── custom-state/
│   ├── my-config.json
│   └── another-preloaded-account.json

Now update the *start-validator.sh* script in Beargrease:

```shell
# In scripts/beargrease/start-validator.sh

docker run --rm -d \
  --name beargrease-validator \
  -p 8899:8899 -p 8900:8900 \
  -v "$PROJECT_DIR/custom-state:/custom-state" \
  solanalabs/solana \
  solana-test-validator \
    --account <CONFIG_PUBKEY> /custom-state/my-config.json \
    --reset

```

You can use multiple *\--account* flags to preload more accounts.

**Note**: The pubkeys must match the keys inside the **.json** account dumps.



### Best Practices

- Do not commit private keypairs to GitHub. Only store account dumps.

- Use real devnet-exported accounts for complex simulations.

- You may volume-mount entire ledgers if your tests require complete devnet state.

- Consider writing a *prepare-ledger.sh* script that generates state on demand.

  

### Final Thoughts

Beargrease gives you full control over the validator's launch process. Preloading state is a powerful way to test real application behavior under realistic conditions. It allows you to simulate DAO governance, token distributions, or config patterns **before** your program logic executes.



### 2. Testing SPL Token Interactions with Beargrease

SPL tokens are at the heart of most Solana programs. Whether you're building a DEX, DAO, NFT mint, or reward system, you'll need to mint, send, and inspect token balances inside your tests.

Beargrease makes this easy --- but it doesn't **abstract away** the process. Instead, you get a clean, fully controllable setup that
prepares the test environment, funds wallets, deploys your program, and runs your SPL tests just like any other Anchor or TypeScript test.



### How SPL Testing Fits into the Beargrease Flow

Here's what happens when you run:

`./scripts/beargrease/run-tests.sh`



1.  **Beargrease launches a Solana validator in Docker**
    -   A local, isolated blockchain with full SPL token support
    
2.  **Beargrease funds all wallets in *.ledger/wallets/* with SOL**
    -   Ensures your test users (like *alice.json*, *bob.json*) have SOL to pay fees
    
3.  **Beargrease builds and deploys your Anchor program**

4.  **Beargrease detects your test runner (*yarn* or *anchor*) and runs your tests**
    -   Your TypeScript test files (*e.g.* *tests/token\_flow.ts*) are executed

5.  **Validator is shut down and cleaned up**

****

Because Beargrease mimics *localnet*, everything in your SPL token test happens inside a containerized test environment --- **no Devnet risk, no real tokens, no external dependencies**.



### Step-by-Step Setup

#### Step 1: Install Required Libraries

In your project root:

```bash
*yarn add @solana/web3.js @solana/spl-token*
```

These will be used inside your test files to perform SPL operations.



#### Step 2: Create a TypeScript Test File

Beargrease will automatically run any file in your *tests/* folder that matches the pattern *\*.ts*.

Example: `tests/token\_transfer.ts`

Here is a minimal working SPL token test using Beargrease-prepared wallets:

```typescript
import { Connection, Keypair } from "@solana/web3.js";
import {
  createMint,
  getOrCreateAssociatedTokenAccount,
  mintTo,
  transfer,
} from "@solana/spl-token";
import * as anchor from "@coral-xyz/anchor";
import fs from "fs";
import { assert } from "chai";

const alice = anchor.web3.Keypair.fromSecretKey(
  Uint8Array.from(
    JSON.parse(fs.readFileSync(".ledger/wallets/alice.json", "utf-8"))
  )
);

const bob = anchor.web3.Keypair.fromSecretKey(
  Uint8Array.from(
    JSON.parse(fs.readFileSync(".ledger/wallets/bob.json", "utf-8"))
  )
);

describe("SPL Token Flow", () => {
  const provider = anchor.AnchorProvider.env();
  anchor.setProvider(provider);
  const connection = provider.connection;

  let mint;
  let aliceTokenAccount;
  let bobTokenAccount;

  it("Creates SPL mint and accounts", async () => {
    mint = await createMint(connection, alice, alice.publicKey, null, 6);

    aliceTokenAccount = await getOrCreateAssociatedTokenAccount(
      connection,
      alice,
      mint,
      alice.publicKey
    );

    bobTokenAccount = await getOrCreateAssociatedTokenAccount(
      connection,
      alice,
      mint,
      bob.publicKey
    );

    await mintTo(
      connection,
      alice,
      mint,
      aliceTokenAccount.address,
      alice,
      1_000_000_000
    );

    const aliceBalance = await connection.getTokenAccountBalance(
      aliceTokenAccount.address
    );

    assert.equal(aliceBalance.value.uiAmount, 1000);
  });

  it("Transfers tokens from Alice to Bob", async () => {
    await transfer(
      connection,
      alice,
      aliceTokenAccount.address,
      bobTokenAccount.address,
      alice,
      100_000_000 // 100 tokens
    );

    const bobBalance = await connection.getTokenAccountBalance(
      bobTokenAccount.address
    );

    assert.equal(bobBalance.value.uiAmount, 100);
  });
});

```



### How Beargrease Helps

Beargrease ensures that `.ledger/wallets/alice.json` and `bob.json` are present and funded, that your validator is running and SPL-compatible, and that all test output is captured cleanly inside CI and logs. There is no need to mock token state — you're running real token logic inside a live Solana validator.

### Extra Tips for Beargrease Integration

-   Include your SPL token tests alongside regular tests in the *tests/* folder
-   Beargrease auto-detects TypeScript tests if *package.json* includes:

```json
"scripts": {

"test": "ts-mocha -p ./tsconfig.json -t 1000000 'tests/**/*.ts'"
}
```

- Set multiple test wallets with:

  ```bash
  ./scripts/beargrease/create-test-wallet.sh alice
  ./scripts/beargrease/create-test-wallet.sh bob
  ./scripts/beargrease/fund-wallets.sh
  ```

- Use *describe.only()* and *it.only()* to isolate failing SPL tests

  

### Run It All Together

After setting up your wallets and tests, run:

```bash
./scripts/beargrease/run-tests.sh
```

If *yarn.lock* is present, Beargrease will automatically run the SPL token test suite via *yarn test*.



### 🧪 Still Debugging?

See:

- **Appendix B.3** --- Wallet not found

- **Appendix B.4** --- Wallet funding failed

- **Appendix B.7** --- Examining Beargrease test logs

  

### 📧 Support

Still stuck? Reach out to the Beargrease maintainer (Rich) at **cabrilloweb3\@gmail.com** or open an issue in the GitHub repo.



### 3. Full Integration Testing with web3.js

### Why Full Integration Testing?

Most real-world Solana projects go beyond program logic. They include a frontend dApp written in React, Svelte, or a similar framework; a client library built with `@solana/web3.js`; and a requirement to verify that everything works end-to-end.

Beargrease supports full-stack test loops that confirm the correct transaction instructions are constructed, that wallets sign properly, that transactions reach the validator and succeed, and that state changes are verifiable on-chain.

This section demonstrates how to simulate that entire flow **inside a Beargrease test environment** using `@solana/web3.js`.



### How to Use *web3.js *with Beargrease

Beargrease launches a full Solana validator inside Docker and updates your local *programId*. Once this is done, **your TypeScript tests can talk to the validator just like your frontend would.**

Here's what to do:

#### 1. Use a **Connection** that talks to the local validator

```typescript
import { Connection } from "@solana/web3.js";

const connection = new Connection("http://localhost:8899",
"confirmed");


```

This ensures you're testing against the same instance that Beargrease is running.

#### 2. Load the deployed program ID from *target/idl/\<program\>.json*

```typescript
import { readFileSync } from "fs";
const idl = JSON.parse(
readFileSync("target/idl/your_program.json", "utf8")
);
const programId = new PublicKey(idl.metadata.address);
```

Beargrease's *update-program-id.sh* script ensures this matches what was deployed in the test run.



#### 3. Load a keypair from your Beargrease wallet directory

```typescript
import * as anchor from "@coral-xyz/anchor";
import * as fs from "fs";
const user = anchor.web3.Keypair.fromSecretKey(
Uint8Array.from(JSON.parse(fs.readFileSync(".ledger/wallets/test-user.json","utf-8")))
);
```

You can do this for multiple users if testing interactions.



#### 4. Send an instruction using the standard web3.js flow

```typescript
import {
  Transaction,
  TransactionInstruction,
  sendAndConfirmTransaction
} from "@solana/web3.js";

const instruction = new TransactionInstruction({
  programId,
  keys: [
    {
      pubkey: user.publicKey,
      isSigner: true,
      isWritable: true
    },
    // Add your program-specific accounts here
  ],
  data: Buffer.from([]) // Replace with real instruction data
});

const tx = new Transaction().add(instruction);
await sendAndConfirmTransaction(connection, tx, [user]);

```



### Example Test File

Here's a minimal TypeScript test file you might place in **tests/web3\_integration.ts**:

```typescript
import {
  Connection,
  Keypair,
  PublicKey,
  Transaction,
  TransactionInstruction,
  sendAndConfirmTransaction
} from "@solana/web3.js";

import { readFileSync } from "fs";
import { expect } from "chai";

describe("web3.js integration", () => {
  const connection = new Connection("http://localhost:8899", "confirmed");

  const user = Keypair.fromSecretKey(
    Uint8Array.from(
      JSON.parse(readFileSync(".ledger/wallets/test-user.json", "utf8"))
    )
  );

  const idl = JSON.parse(readFileSync("target/idl/placebo.json", "utf8"));
  const programId = new PublicKey(idl.metadata.address);

  it("sends an instruction using web3.js", async () => {
    const ix = new TransactionInstruction({
      programId,
      keys: [
        { pubkey: user.publicKey, isSigner: true, isWritable: true },
        // Additional accounts...
      ],
      data: Buffer.from([]) // Customize for your instruction
    });

    const tx = new Transaction().add(ix);
    const sig = await sendAndConfirmTransaction(connection, tx, [user]);
    
    expect(sig).to.be.a("string");

  });
});
```



### How Beargrease Fits In

This test file will be picked up automatically when Beargrease runs **yarn test** as part of the harness flow:

```
./scripts/beargrease/run-tests.sh
```

Beargrease ensures that your validator is ready and pre-funded, your program is deployed with the correct ID, and that wallets are already available and funded. This setup allows your tests to interact with a fully live, local blockchain — making Beargrease the **ideal tool to simulate a frontend–program interaction** inside a fully local test loop.



### Summary

With this setup, you can test `web3.js` instructions in a local environment, simulate frontend-to-program logic, and verify real-world usage scenarios like multisig flows, token transfers, or PDA checks. This is not a mock — it's the same blockchain logic your frontend would use, just executed in a test file inside the Beargrease validator sandbox.



4 --- Full Project Integration: Multi-Service App Testing with Beargrease
-------------------------------------------------------------------------

### Overview: Why This Matters

In real-world Solana projects, you're rarely working with smart contracts in isolation. You often need to test a full stack that includes Solana programs (Anchor-based or otherwise), web frontends that interact with programs via `@solana/web3.js`, and backend services or orchestrators that handle off-chain computation, API endpoints, or batched transactions. These setups often involve multi-user scenarios, wallet authorization flows, or role-based behavior.

In this section, we show how to use Beargrease to support this kind of **multi-service testing**. This approach works whether your services are collocated or split into conventional folders like `/smart-contracts`, `/frontend`, and `/backend`.

We'll refer to our fictional case study as **"Lighthouse"** — a project composed of a smart contract to manage courses, a backend service that registers students and instructors, and a frontend app where users interact with their wallet.

Goal: Coordinated, Multi-Component Test Harness

We want Beargrease to:

-   Set up the validator.
-   Fund and deploy the program.
-   Provide shared state to both frontend and backend.
-   Allow any component to run tests against a live blockchain.

Architecture Layout
-------------------

/lighthouse
├── smart-contracts/           	 # Anchor program
│   └── scripts/beargrease/         # Beargrease harness lives here
├── frontend/                  	      # React app with wallet integration
├── backend/                                 # Node/Express or Python API
└── .github/workflows/                # Unified GitHub Actions pipeline. All subprojects can point to the same local validator URL

​								(*http://localhost:8899*) and wallet location during integration tests.



Step-by-Step: Full Project Integration
--------------------------------------



### Step 1: Use Beargrease in *smart-contracts/*

This remains your Beargrease anchor point. Place your wallet files in `.ledger/wallets/` here. Then, use Beargrease to start the validator, build and deploy your Anchor program, and expose the program ID using a command like:

```bash
cat target/idl/your_program.json | jq .metadata.address
```

You can share this with other components (see Step 3).



### Step 2: Add Shared Environment Config

In *lighthouse/.env.test* (or similar):

```bash
ANCHOR_PROVIDER_URL=http://localhost:8899

TEST_USER_KEYPAIR=.ledger/wallets/test-user.json

PROGRAM_ID=Extracted from target/idl/your_program.json
```

You can source this *.env.test* in frontend/backend test scripts.



### Step 3: Frontend Integration with Beargrease

Inside */frontend*, your tests might look like this (*e.g*., *tests/courseFlow.spec.ts*):

```typescript
import { Connection, Keypair, PublicKey } from "@solana/web3.js";
import { readFileSync } from "fs";
import { expect } from "chai";

describe("frontend program interaction", () => {
  const connection = new Connection(
    process.env.ANCHOR_PROVIDER_URL!,
    "confirmed"
  );

  const user = Keypair.fromSecretKey(
    Uint8Array.from(
      JSON.parse(
        readFileSync("../smart-contracts/.ledger/wallets/test-user.json", "utf8")
      )
    )
  );

  const programId = new PublicKey(process.env.PROGRAM_ID!);

  it("should fetch user data", async () => {
    // Build an instruction and send a TX...
  });
});

```



🧪 Run this as part of CI **after** Beargrease has deployed the program.



### Step 4: Backend Integration

Your backend (for example, in `backend/src/tests/integration/courseFlow.test.ts`) might import the same `programId` and `keypair`, use either `@solana/web3.js` or `@project-serum/anchor`, and call `sendAndConfirmTransaction` to verify program flows. You can use `dotenv` to load environment variables with:

```typescript
require("dotenv").config({ path: "...env.test" });
```

This gives your backend the same blockchain context that Beargrease provides.



### Step 5: Unified GitHub Actions Flow

Here's a simplified *.github/workflows/lighthouse-ci.yml*:

```
name: Lighthouse CI

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup dependencies
        run: |
          sudo apt update
          sudo apt install -y jq curl build-essential libssl-dev pkg-config
          sh -c "$(curl -sSfL https://release.anza.xyz/v1.17.21/install)"
          cargo install --git https://github.com/coral-xyz/anchor anchor-cli --locked
          yarn install --cwd frontend
          yarn install --cwd backend

      - name: Restore wallet
        run: |
          mkdir -p smart-contracts/.ledger/wallets
          echo "$TEST_USER" > smart-contracts/.ledger/wallets/test-user.json
        env:
          TEST_USER: ${{ secrets.TEST_USER }}

      - name: Run Beargrease
        run: cd smart-contracts && ./scripts/beargrease/run-tests.sh

      - name: Run Frontend Tests
        run: cd frontend && yarn test:integration

      - name: Run Backend Tests
        run: cd backend && yarn test:integration

```

📦 Optional: Pass Beargrease-created values (e.g., program ID) via files or env.



Final Notes
-----------

Beargrease is designed to be composable—not monolithic. In a real-world multi-service project, you use Beargrease to run the validator and deploy your Anchor programs, while your other services act as test clients. Tests coordinate over shared environment variables and wallets. You can even have Beargrease export a `.env.test` file for other services to consume.

### Summary

In this setup, Beargrease handles the local deployment of your smart contract to a live validator. Your frontend and backend tests then interact with that validator directly, enabling full end-to-end testing against real blockchain logic. All parts of your project operate as they would in production, allowing you to test coordinated flows—for example, a frontend triggering a backend relay to a program.

📣 If you want to extend this even further—simulate multiple frontends, use multiple Docker containers, or run tests across machines—Beargrease can serve as the **first container** in a fully orchestrated test chain.



## Part IV Summary --- Advanced Test Scenarios with Beargrease

By completing Part IV, you've unlocked the full power of Beargrease for modern Solana development. This section went beyond isolated smart contract testing and showed how Beargrease can be used in
**real-world, full-stack workflows**.

Here's what you now know how to do:

### Preload the Validator with Custom State

You can start a Beargrease test validator with a **predefined ledger**, enabling the simulation of pre-funded accounts, initialized PDAs, and program state carried over from previous test runs. This technique is essential when testing against **expected blockchain conditions** or simulating flows that depend on historical data.



### Test with SPL Tokens and Realistic Token Flows

Beargrease supports **SPL token creation and usage** during integration tests, including minting new tokens using the SPL Token CLI or from TypeScript, creating and funding token accounts, transferring tokens between simulated users, and testing token-gated Solana programs. This allows you to fully validate dApps that rely on the SPL ecosystem.



### Run Full Integration Tests Using *web3.js*

You learned how to use `@solana/web3.js` or Anchor’s TypeScript client, simulate a frontend or backend calling your program directly, and create custom transactions that invoke instructions and assert results. These tests give you confidence that your Solana program behaves correctly when accessed the way it will be in production—through clients, UIs, or relayers.



### Integrate Beargrease into Multi-Service Projects

- Beargrease is ready for **real-world architectures**—including dApps with distinct smart contracts, backend APIs, and web UIs; projects involving multiple users, wallets, or roles; and CI pipelines that need to deploy, test, and validate contract behavior across systems. By letting Beargrease serve as the test **anchor**, and passing shared validator context (such as `.env.test`, wallet files, and program IDs) to other services, you enable full-system testing.

  This approach ensures that smart contracts, frontends, and backends operate **in sync**, that wallets are properly funded and scoped, and that transactions from different components are both valid and verifiable.

### Where to Go From Here

You've now learned how to use Beargrease to run both simple and advanced tests, deploy in CI environments securely, integrate across services, and simulate complex, token-based interactions. Beargrease is not just a test script — it's a foundation for a **repeatable, inspectable, and scalable development process**.

If your project pushes beyond Beargrease's built-in capabilities, you can extend it. Many advanced teams automate testnet-to-local state replication, use snapshot testing to validate on-chain outcomes, or integrate Beargrease into Kubernetes pipelines and GitHub matrix builds.

But for most teams, Beargrease already meets 90% of what's needed to **build robust, tested, and secure Solana dApps**.



****

📬 Have a suggestion or use case?

Open an issue or share your thoughts with the maintainer (Rich) at:\**📨 cabrilloweb3\@gmail.com**



****

## Appendix B Troubleshooting Beargrease



## Appendix B.1 --- If the First Run of Beargrease Fails

This appendix helps you to troubleshoot the initial run of Beargrease using:

```bash
./scripts/beargrease/run-tests.sh
```

If Beargrease fails before it reaches the testing phase, this section will help isolate and fix the problem.



What Beargrease Is Supposed to Do
---------------------------------

A successful run of *run-tests.sh* produces output like:

```none
🌟 Starting solana-test-validator via Docker...
📅 Waiting for validator to become healthy...
📆 Funding test wallet: .ledger/wallets/test-user.json
📈 Building program via Anchor...
🔧 Deploying program to local validator...
🔄 Updating program ID in source files...
🌐 Running tests via yarn or anchor test...
📉 Shutting down validator...
🎉 Done.
```

If you see all of the above, Beargrease has completed successfully. If any step fails, proceed with diagnosis below.



❌ Failure: \"*Docker container not running*\" or \"*Cannot connect to port 8899*\"
----------------------------------------------------------------------------------

💡 This means the Solana validator was not started correctly.

##### 🔧 Run the validator manually

➤ **Run: **

```bash
./scripts/beargrease/start-validator.sh
```

Watch the output for errors.

##### 🔍 Check container status

➤ **Run:**

```bash
docker ps -a \| grep beargrease-validator
```

- 📅 **STATUS: Up** → Validator is running

  

-   ❌ **Exited** or no output → Validator failed to start



##### 🔧 Diagnose startup issues

If the validator did not start:

-   Confirm Docker is installed and running.
- Pull the image manually: 

  ```bash
  docker pull solanalabs/solana
  ```
- Check for port conflicts:

  ```
  sudo lsof -i :8899
  ```

  🧪 **See:** Appendix B.2 --- Troubleshooting Validator Startup

  

❌ Failure: \"*No wallet found*\" or keypair error
-------------------------------------------------

Beargrease will fail if the wallet file is missing or malformed.

##### 🔧 Check the wallet exists

➤ **Run:**

```bash
ls -l .ledger/wallets/test-user.json
```

✅ Should exist and be readable.

If not, regenerate:

**➤  Run:**

```bash
mkdir -p .ledger/wallets
solana-keygen new --outfile .ledger/wallets/test-user.json
```

🧪 **See:** Appendix B.3 --- Wallet Not Found or Malformed



❌ Failure: \"*anchor build*\" or \"*anchor deploy*\" fails
----------------------------------------------------------

This suggests a problem in your program code or environment.

##### 🔧 Check build output manually

➤ **Run:**

```bash
anchor build
```

Fix any syntax or dependency errors.

If build succeeds, try:

**➤ Run:**

```bash
anchor deploy
```

🧪 **See:** Appendix B.4 --- Anchor Build or Deploy Errors



❌ Failure: \"*update-program-id.sh*\" fails with *jq* errors
------------------------------------------------------------

This usually means *jq* is not installed.

##### 🔧 Check for jq

➤ **Run:**

```bash
jq \--version
```



If *jq* is missing:

- Debian/Ubuntu:

  ```bash
  sudo apt install jq
  ```
- macOS:

  ```bash
  brew install jq
  ```

  🧪 **See:** Appendix B.5 --- jq or Program ID Script Errors

  

❌ Failure: Yarn or Anchor Test Does Not Run
-------------------------------------------

This indicates a missing or broken test script.

##### 🔧 Check test runner configuration

➤ **Run**:

```
echo \$TEST\_RUNNER
```

Should be either *anchor* or *yarn*.

➤ If using *yarn*, confirm: 

```bash
yarn test
```

🧪 **See: **Appendix B.6 --- Yarn or Anchor Test Script Fails



🌟 If All Else Fails
-------------------

Go step-by-step:

1.  Run each script manually from **scripts/beargrease**.
2.  Watch the output at each step.
3.  Review logs and error messages.

If none of the above resolve your issue, continue to:

🧪 Appendix B.7 --- Full Manual Run of Beargrease Scripts



👍 Once you resolve your issue and reach the point where Beargrease
shows:

**✅ Docker container \'beargrease-validator\' is running.**

**✅ Tests completed.**

**🎉 Done.**

You may proceed with your project!



➡️ Return to: Step 6 in the Beargrease Beginner Guide.



## Appendix B.2 --- Troubleshooting Validator Startup

This appendix supports users who do not see the expected output after running:

```bash
./scripts/beargrease/run-tests.sh
```

Specifically, Beargrease should print:

```NONE
🌟 Starting solana-test-validator via Docker...

✅ Docker container 'beargrease-validator' is running.
```

If this output is missing, the Solana validator likely failed to start.



### 👀 You see:

-   **No validator output at all**
-   *run-tests.sh* exits early or silently
-   **Only partial Beargrease steps are shown**



### 🤔 Meaning:

The validator startup process failed. Beargrease could not continue because its environment is incomplete.

This usually points to one of the following:

- Docker is misconfigured or permissions are denied.

- The validator container could not be launched.

- A stale container is blocking startup.

- The Docker image is missing or was not pulled.

  

### 🔧 Fix: Follow these steps in sequence to isolate and resolve the issue.

#### 1. Check Whether the Container Was Created

➤**Run:**

```bash
docker ps -a \| grep beargrease-validator
```

-   If no output: the container never launched.
-   If the container appears but STATUS is **Exited**: it started but
    immediately failed.
-   If STATUS is **Up**: the container is running; the issue may be a
    logging or script error.

🔧If the container did not launch or exited: Proceed to **B.3 --- Run Validator Manually.**



#### 2. Check for Port Conflicts

➤**Run:**

```bash
sudo lsof -i :8899
```

If any process is using port 8899, the validator will fail to bind to it.

🔧 Proceed to **B.4 --- Port Conflict Resolution.**



#### 3. Check Docker Logs for Crashes

➤**Run:**

```bash
sudo journalctl -xe \| grep docker
```

Look for lines indicating:

- Permission denied.

- Image not found.

- Graph driver errors.

- Exited with status 1.

  

#### 4. Pull the Validator Image Manually

Beargrease may fail silently if the image was never cached and Docker Hub was unavailable.

➤**Run:**

```bash
docker pull solanalabs/solana
```

👍 If successful, try Beargrease again:

```bash
./scripts/beargrease/run-tests.sh
```

If the pull fails:

🔧 Proceed to **B.5 --- Docker Pull Failures.**



#### 5. Manual Validator Launch

If all else fails, isolate the validator startup process.

➤**Run**:

```bash
bash ./scripts/beargrease/start-validator.sh


```

Watch the output for:

-   Permission denied.
-   Image not found.
-   Daemon startup failures.

Then confirm the container state:

```bash
docker ps -a \| grep beargrease-validator
```



### 🚩 Still Not Working?

🔧 Proceed to: **Appendix B.6 --- Final Hand-Off (Validator Will Not Start)**

Beargrease cannot proceed until the validator is successfully running.



## Appendix B.3 --- Wallet Not Found or Improperly Named

If Beargrease or a test fails with an error related to a missing wallet, it\'s usually because the required test wallet was not created, was placed in the wrong directory, or was misnamed.

📁 Expected Wallet Structure
---------------------------

Beargrease expects to find one or more keypair files in:

*.ledger/wallets/*

For example: *.ledger/wallets/test-user.json*

These files must be valid Solana keypairs, usually created via *solana-keygen new*.



💡 Common Errors
---------------



❌ Case 1: Wallet file is missing
--------------------------------

👀 You see an error like:

```none
Unable to read file ".ledger/wallets/test-user.json"
```

🤔 **Meaning**: The expected wallet file does not exist or cannot be found.



### ❌ Case 2: File exists but name is incorrect

👀 You see a different filename, or a typo in directory:

*.ledger/wallet/testuser.json*

🤔 **Meaning**: Beargrease expects *.ledger/wallets/* as the directory, and filenames like** *testuser.json*. Typos will cause the script to fail.



### ❌ Case 3: File is corrupt or not a keypair

👀 You see:

```
failed to deserialize keypair file
```

🤔 **Meaning**:The file exists but is not a valid keypair (*e.g.*, a truncated file, a placeholder, or not *JSON*).



🔧 Fix
-----

To create a valid wallet for Beargrease:

➤**Run**:

```bash
mkdir -p .ledger/wallets
solana-keygen new --outfile .ledger/wallets/test-user.json
```

This ensures that the wallet is created in the correct location with a valid keypair.

🔄 If your test project uses a different expected filename, match that name exactly.

🔜 Return to the Beginner Guide step you came from and try running Beargrease again.

🔥 Still not working? Proceed to:**Appendix B.4 --- Wallet Funding Failed**.



Appendix B.4 --- Wallet Funding Failed
--------------------------------------

This appendix helps troubleshoot issues where Beargrease fails to fund the test wallet with SOL.

### 👀 You see:

```
Error: unable to confirm transaction. This can happen when the
validator is not ready or there are network problems.
```

Or:

```
Error processing request: account not found
```

Or:

```
Request failed: wallet not found
```



### 🤔 Meaning

These messages typically indicate one of the following:

- The validator is not yet fully booted or accepting RPC requests.

- The wallet file used for funding was not found or was not created properly.

- The public key of the wallet being funded does not match any active account on the validator.

  

### 🔧 Diagnostic Steps

#### Step 1: Is the validator healthy?

Before funding can succeed, the Solana validator must be running and fully initialized.

➤**Run**:

```bash
curl http://localhost:8899
```

👀 You should see:

```
{\"jsonrpc\":\"2.0\",\"error\":{\"code\":-32600,\"message\":\"Invalid request\"},\"id\":null}
```

If you get a connection error (e.g., *connection refused*), the validator may not be fully ready. Wait a few seconds and try again. You
can also run:

➤**Run**:

```bash
solana-test-validator
```

If it launches successfully outside of Beargrease, this confirms the validator can run manually. If not, see Appendix B.2.



#### Step 2: Is the wallet file present and correct?

Make sure the wallet file was created in **.ledger/wallets/** as expected.

➤**Run**:

```bash
ls -l .ledger/wallets/
```

You should see your wallet name listed (e.g. *test-user.json*).

🤔 If it\'s missing:

Create a new wallet manually:

```bash
solana-keygen new --outfile .ledger/wallets/test-user.json
```

Or re-run:

```bash
./scripts/beargrease/create-test-wallet.sh test-user
```



#### Step 3: Is the public key correct?

You can extract the wallet's public key like this:

➤**Run**:

```bash
solana address -k .ledger/wallets/test-user.json
```

Make sure this matches the key being funded in the Beargrease logs. If there is a mismatch or the public key is invalid, the airdrop will fail.

### 🤝 Final Fixes

If all else fails, try regenerating the wallet:

**➤  Run**:

```bash
rm .ledger/wallets/test-user.json

solana-keygen new --outfile .ledger/wallets/test-user.json
```

Then  re-run:

```b
./scripts/beargrease/run-tests.sh
```



### Still Not Working?

If the wallet is present, the validator is running, and you\'re still getting errors, you may:

- Check for typos in wallet names or paths.

- Open the script *fund-wallets.sh* and ensure it\'s referencing the correct directory and wallet files.

- Add debug output to the script (e.g., *set -x* at the top) and re-run to see detailed steps.

  

🌟 Once the wallet is funded successfully, Beargrease will continue to build and deploy your program.

🚀 Return to the Beginner Guide to continue setup.



### Appendix B.5 --- Anchor Build Fails

Anchor builds may fail if the Rust environment isn\'t fully configured, if system dependencies are missing, or if the program code itself has errors.

Case 1: Missing Rust Toolchain
------------------------------

👀 You see:

```bash
error: no override and no default toolchain set*
```



🤔  **Meaning**: The required Rust *toolchain* isn\'t installed or wasn\'t properly initialized.

🔧 **Fix**:

**➤  Run**:

```bash
rustup install stable
rustup default stable
```

🔄 Then retry:

```bash
anchor build
```





Case 2: Missing Dependencies (e.g. *pkg-config*, *libssl-dev*)
--------------------------------------------------------------

👀 You see errors referencing *openssl*, *pkg-config*, or *libssl*

Example:

```bash
failed to run custom build command for `openssl-sys`
Could not find directory of OpenSSL installation
```



🤔 **Meaning**: Anchor uses Rust crates that depend on system libraries (especially for networking and cryptography).

🔧 **Fix** (Debian/Ubuntu): 

```bash
sudo apt update
sudo apt install pkg-config libssl-dev build-essential
```



🔧 Fix (macOS):

```bash
brew install openssl pkg-config
```



Case 3: Code-Level Errors
-------------------------

👀 You see standard Rust compiler errors, such as:

```none
error\[E0432\]: unresolved import \`crate::state::MissingModule\`
error\[E0308\]: mismatched types
```

🤔 **Meaning**: Your program has a genuine code error.

🔧 **Fix**:

- Read the error message carefully.

- Anchor/Rust errors typically include a file name and line number. Open the file and inspect the issue.

- If the problem isn\'t obvious, try running: 

  ```bash
  cargo check
  ```

This gives a faster readout of compiler problems without doing a full build.



🚀 Success Case
--------------

🧸 You run: 

```bash
anchor build
```

👀 You see: 

```none
Building [programs/your_project_name]...
Program ID: <YourPublicKeyHere>
```

**To deploy this program:** 

```bash
anchor deploy
```

👍 **Success:** Your Anchor program compiled successfully.

🔄 Return to: The Beginner Guide step you came from (Step 6 or Appendix B.2).



Appendix B.6 --- Anchor Deploy
------------------------------

If your tests fail due to issues during the *anchor deploy* phase, this appendix will help you understand and resolve the problem.

### 👀 You see:

```
Deploying program...
Error: Deploy failed: ...
```

or:

```
Error processing Instruction 0: failed to send transaction: Transaction
simulation failed: Error processing Instruction 0: ...
```

or:

```
Error: Unable to deploy program: account not found / invalid signer /
programtoo large
```



### 🤔 Meaning:

The deploy phase is attempting to upload your Anchor program to the validator and assign ita program ID. If this step fails, it usually indicates one of the following:

- The validator is not running.

- Your wallet lacks funds.

- The program is too large.

- A *.so* file is missing or corrupted.

- The *programId* file path is incorrect.

  

### 🔧 Troubleshooting Checklist

#### 1. Confirm validator is running

👀 Appendix B.2 --- Confirm Validator Running

Ensure the validator container is running. If it is not, deploys will always fail.

#### 2. Check for build artifacts

🔍 Check:

```bash
ls target/deploy/
```

You should see:

-   *your\_program.so*
-   *your\_program-keypair.json*
-   *your\_program.json*

If *.so* is missing: Go back to 🔎 Appendix B.5 --- Anchor Build



#### 3. Confirm programId in Anchor.toml

Open your *Anchor.toml* and make sure it includes:

```
[programs.localnet]
your_program = "<your_program_id>"
```

If this path is invalid, *anchor deploy* will fail.

Also check:

```bash
cat target/idl/your_program.json | grep "metadata"
```

Make sure the program ID matches.



#### 4. Check for missing funds

If your deploy fails with **insufficient funds**, your wallet may not have *SOL*.

**➤  Run**:

```bash
solana balance
```

If the balance is low:

➤  **Run:**

```bash
solana airdrop 5
```

Or rerun Beargrease to fund wallets:

```bash
./scripts/beargrease/fund-wallets.sh
```



#### 5. Program too large

Some errors mean your program exceeds Solana's size limit (1.4MB for deployable binary).

To fix:

-   Refactor your program into smaller modules.
-   Use fewer dependencies.

See: https://book.anchor-lang.com/chapter\_5/size.html



### Summary

If **anchor deploy** fails:

1. Make sure the validator is running (B.2).

2. Confirm *.so* file exists (B.5).

3. Confirm *Anchor.toml* contains the right *programId*.

4. Make sure your wallet has *SOL.*

5. If needed, rebuild or refactor to reduce program size.

   

🔄 Then:

Return to your test run or rerun:

```bash
./scripts/beargrease/run-tests.sh
```

or

```bash
anchor deploy
```

Once deploy succeeds, continue testing.



## Appendix B.7 --- Examining Beargrease Test Logs

Beargrease runs your test suite (TypeScript or Anchor) after launching the validator and deploying your program. If a test fails, it is important to examine the log output carefully to determine the cause.



Step 1: Run Beargrease
----------------------

If you haven\'t already, from the root of your project:

```bash
./scripts/beargrease/run-tests.sh
```

This will:

- Start the validator.

- Build and deploy your program.

- Run the test suite.

  

Step 2: Scroll to the Test Output Section
-----------------------------------------

Look for output similar to:

```none
Running test suite with yarn\...
> placebo\@1.0.0 test
> ts-mocha -p ./tsconfig.json -t 1000000 'tests/**/*.ts'
✔ initialize_course.ts (2000ms)
✔ Initializes a new course
✔ register\_student.ts (1300ms)
✔ Registers a student to the course
1 failing
1) register\_student.ts
✖ should not register if course is full:
Error: expected success but got anchor error: ConstraintSeeds
...
```

This is your primary debugging information. Identify:

-   Which file is failing.
-   Which specific test case is failing.
-   The nature of the failure (e.g., Anchor error, assertion failure, thrown exception)
-   

Step 3: Understand Common Errors
--------------------------------

Beargrease test failures often originate from one of these sources:



##### ⚠️ Constraint Errors

**Error:** 

```
expected success but got anchor error: ConstraintSeeds
```

🤔 **Meaning: **The test failed due to account constraint violations in your program.

🔧 **Fix:** Inspect the PDA derivation or the associated seeds in your program/test.



##### ❌ Assertion Failures

**Error:** 

```
expected 1 to equal 0
```

🤔 **Meaning:**  The test logic expected something different from what was returned. 

🔧 **Fix:** Review the logic of your test case, and check if your program behaved as expected.



### 🚫 Account Not Found / Program Not Initialized

**Error:** 

```
Account does not exist
```

🤔 **Meaning:**  Your program tried to access a Solana account that wasn't created or funded.

🔧 **Fix:** Ensure the test sets up the accounts correctly, or check if the validator started cleanly.



Step 4: Explore Full Logs
-------------------------

Beargrease logs are written to the console. To see the complete validator logs:

```bash
docker logs beargrease-validator
```

This can show:

- Errors during program deployment.

- Runtime panics.

- Log messages emitted by your program (via *msg!()* macro).

  

Step 5: Debug, Edit, and Retry
------------------------------

Once you\'ve found the likely cause:

-   Update your test case or Solana program as needed.
-   Run Beargrease again:

```bash
./scripts/beargrease/run-tests.sh
```

If you want to run only one test file while debugging:

```bash
TEST\_RUNNER=yarn ./scripts/beargrease/run-tests.sh
```

And edit your *package.json* test script to:

```bash
"test": "ts-mocha tests/only_this_test.ts"
```

💡 **Tips**

- Use *console.log()* in your tests to verify values.

- Use *msg!()* in your Solana program to emit on-chain debug info.

- Rebuild everything cleanly with *anchor build*.

  

Once your test passes, your local program deployment and test logic are confirmed working.

✉ Still having trouble? Open an issue in the Beargrease repo or contact the maintainer (Rich) at cabrilloweb3\@gmail.com.



## Appendix B.8 --- Manual Script Execution Flow

Beargrease is not a black box. Every part of its process is implemented in simple Bash scripts that can be read, modified, and run
independently. This appendix describes how to manually walk through the Beargrease process, one script at a time.



🧪 Why Would You Do This?
------------------------

Manual script execution is useful when you want to debug a specific step—such as the validator failing to start—, run tests without performing a full redeploy, customize the process to fit your own project, or simply learn exactly what Beargrease is doing under the hood.

Beargrease Scripts Overview
---------------------------

All scripts live in:

*./scripts/beargrease/*

**Beargrease\'s Key Scripts**

| Script Name           | Description                                |
| --------------------- | ------------------------------------------ |
| start-validator.sh    | Starts the Solana validator in Docker      |
| wiat-for-validator.sh | Waits until the validator RPC is healty    |
| airdrop.sh            | Airdrops SOL into the test wallet(s)       |
| fund-wallets.sh       | Iterates over wallets and calls airdrop.sh |
| update-program-id.sh  | Rewrites programId in source files via jq  |
| run-tests.sh          | Orchestrates the full process              |



Recommended Manual Order
------------------------

From the root of your project:

1.  `./scripts/beargrease/start-validator.sh`

2.  `./scripts/beargrease/wait-for-validator.sh`

3.  `./scripts/beargrease/fund-wallets.sh`

4.  `anchor build`

5.  `anchor deploy`

6.  `./scripts/beargrease/update-program-id.sh`

7.  `anchor test \# or yarn test`

8.  `./scripts/beargrease/shutdown-validator.sh`

   

   Notes and Gotchas
   -----------------


-   **`start-validator.sh`**: Will fail silently if Docker image isn\'t pulled. Manually run *`docker pull solanalabs/solana`* first if
    unsure.
    
- **`wait-for-validator.sh`**: Uses *curl* to check *localhost:8899*. Make sure nothing else is blocking that port.

- **`fund-wallets.sh`**: Iterates over all *\*.json* files in *.ledger/wallets/* and airdrops 2 SOL to each.

- **`update-program-id.sh`**: Relies on *jq*. Make sure jq is installed.

  

Customization Tips
------------------

- You can change how much SOL is airdropped by editing *airdrop.sh*.

- You can test with different wallets by adding new ones to *.ledger/wallets/*.

- You can add logging or export environment variables to control script behavior.

  

Success
-------

If you follow the full sequence manually and your tests pass, you've just reproduced Beargrease's entire test cycle transparently.

This is the best way to gain confidence in your tooling and customize it for future projects.

🔄 Return to: Beargrease Beginner Guide Part II



## Appendix B.9 --- GitHub Actions and Secure Continuous Integration with Beargrease

This appendix provides a comprehensive guide to running Beargrease in GitHub Actions for automated testing --- while keeping your keys secure and your environment consistent.



Why CI Matters
--------------

Automated testing with GitHub Actions allows you to verify that your program builds and passes its tests every time you push new code. Beargrease integrates cleanly with GitHub workflows and is particularly suited to continuous integration (CI) because it operates entirely through explicit scripts.

A few essential tasks must be handled carefully:

- Wallets must be securely available to sign transactions.

- Docker must be running.

- Solana and Anchor CLI tools must be installed.

- Test output must be visible for debugging.

  

This guide walks you through a clean, professional setup.



Step 1: Create a Workflow File
------------------------------

Inside your project, create the following file:

`.github/workflows/beargrease.yml`

Use the following as your complete workflow example:

```
name: Beargrease Tests

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    timeout-minutes: 20

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Cache Node.js modules
        uses: actions/cache@v3
        with:
          path: node_modules
          key: ${{ runner.os }}-yarn-${{ hashFiles('**/yarn.lock') }}
          restore-keys: |
            ${{ runner.os }}-yarn-

      - name: Cache Cargo build artifacts
        uses: actions/cache@v3
        with:
          path: |
            ~/.cargo/registry
            ~/.cargo/git
            target
          key: ${{ runner.os }}-cargo-${{ hashFiles('**/Cargo.lock') }}
          restore-keys: |
            ${{ runner.os }}-cargo-

      - name: Install system dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y curl jq pkg-config libssl-dev build-essential

      - name: Install Solana CLI (stable)
        run: |
          sh -c "$(curl -sSfL https://release.anza.xyz/v1.17.21/install)"
          echo "export PATH=\"\$HOME/.local/share/solana/install/active_release/bin:\$PATH\"" >> $GITHUB_ENV

      - name: Install Anchor CLI
        run: |
          rustup default stable
          cargo install --git https://github.com/coral-xyz/anchor anchor-cli --tag v0.29.0 --locked

      - name: Set up Node and Yarn
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'yarn'

      - name: Install JavaScript dependencies
        run: yarn install

      - name: Restore test wallet from secret
        run: |
          mkdir -p .ledger/wallets
          echo "$TEST_USER_KEYPAIR" > .ledger/wallets/test-user.json
        env:
          TEST_USER_KEYPAIR: ${{ secrets.TEST_USER_KEYPAIR }}

      - name: Run Beargrease
        run: ./scripts/beargrease/run-tests.sh

```



Step 2: Add Wallet to GitHub Secrets
------------------------------------

Never commit private keys to version control. Instead, store them asGitHub Secrets.

### Instructions:

1.  Generate a test wallet locally:

```
solana-keygen new \--outfile .ledger/wallets/test-user.json
```

2.  Open the file and copy its full contents.

3.  In your GitHub repo:

    -   Go to **Settings → Secrets and variables → Actions → New repository secret**
    -   Name the secret: *TEST\_USER\_KEYPAIR*
    -   Paste the contents of **test-user.json** as the value

This secret will be injected into your workflow during CI runs.



Step 3: Understand the CI Environment
-------------------------------------

The GitHub Actions runner must have all dependencies explicitly
installed:

-   **Docker** (pre-installed on *ubuntu-latest* runners)
-   **Solana CLI** (installed via Anza install script)
-   **Anchor CLI** (installed via Cargo)
-   **Rust** toolchain (**rustup default stable**)
-   **jq** via **apt**
-   **Node.js** and **Yarn** via *setup-node*

These match the local environment expected by Beargrease.



Step 4: Add Caching (Optional but Recommended)
----------------------------------------------

Beargrease doesn't require caching, but CI runtimes can be improved with it.



### Cache Yarn Dependencies

```yaml
- name: Cache Node.js modules
  uses: actions/cache@v3
  with:
    path: node_modules
    key: ${{ runner.os }}-yarn-${{ hashFiles('**/yarn.lock') }}
    restore-keys: |
      ${{ runner.os }}-yarn-

```



### Cache Rust Crate Builds

```yaml
- name: Cache Cargo build artifacts
  uses: actions/cache@v3
  with:
    path: |
      ~/.cargo/registry
      ~/.cargo/git
      target
    key: ${{ runner.os }}-cargo-${{ hashFiles('**/Cargo.lock') }}
    restore-keys: |
      ${{ runner.os }}-cargo-

```



Caches should appear before your **yarn install** or **cargo install** steps.



Final Notes
-----------

-   You may want to pin to exact versions of Solana, Anchor, or Node.js to avoid unexpected breakage.
    
-   Add more secrets for additional wallets (e.g., *ALICE\_KEYPAIR*, *BOB\_KEYPAIR*) as needed.
    
-   Logs are available per step in the GitHub Actions UI. Use *set -x* in scripts for full trace output.
    
-   To troubleshoot issues, refer to:

    - B.2 --- Troubleshooting Validator Startup
    
    - B.3 --- Wallet Not Found
    
    - B.5 --- *jq* or Program ID Errors
    
      

Summary
-------

With this CI setup:

-   Wallets are securely managed.
-   Dependencies are cached.
-   Tests are run automatically on every push.
-   Failures are visible in logs.

You've brought full CI to your Beargrease-based Solana project.

Questions or feedback? Reach out to the maintainer (Rich):
[**cabrilloweb3\@gmail.com**](mailto:cabrilloweb3@gmail.com)



## Appendix B.10 --- Comparing Beargrease to Other Solana Testing Tools

As you explore Beargrease, you may wonder how it compares to other common testing tools and approaches within the Solana ecosystem. This appendix presents a concise comparison so that you can make informed decisions about which tool to use --- or better yet, how Beargrease complements them.

#### Tool Comparison Overview: Table 1.

Table 1: Summary of the capabilities, limitations, and audience fit for Beargrease and its primary alternatives.

| Feature                          | Beargrease                    | Anchor test            | Custom Scripts    | Solana Playground  | Internal Toolkits |
| -------------------------------- | ----------------------------- | ---------------------- | ----------------- | ------------------ | ----------------- |
| Fully transparent & script based | ✅                             | ❌                      | ⚠️ Partially       | ❌                  | ❌                 |
| Beginner-friendly                | ✅                             | ⚠️ Limited docs         | ❌                 | ✅                  | ❌                 |
| GitHub Actions ready             | ✅                             | ⚠️ Needs setup          | ⚠️ Needs scripting | ❌                  | ✅                 |
| Validator control (Docker)       | ✅                             | ❌                      | ✅                 | ❌                  | ✅                 |
| Reusable across projects         | ✅                             | ⚠️ With constraints     | ❌ Case-by-case    | ❌                  | ⚠️ Internal only   |
| Pre-deployment support           | ✅                             | ⚠️ Limited              | ⚠️ Depends         | ❌                  | ✅                 |
| Multi-wallet, SPL token tests    | ✅ Built in                    | ⚠️ Possible with effort | ⚠️ Manual setup    | ❌                  | ✅                 |
| Frontend/backend integration     | ✅ Designed for it             | ❌                      | ⚠️ Custom required | ❌                  | ✅                 |
| CI pipeline inclusion            | ✅ One-line integration        | ⚠️ Possible             | ⚠️ Custom YAML     | ❌                  | ✅                 |
| Actively documented              | ✅ Beginner Guide + Appendices | ⚠️ Book only            | ❌ Varies          | ✅ Yes (intro only) | ❌ Internal only   |



### Key Differences Explained

#### 1. **Beargrease vs. anchor test**

Anchor's built-in test runner is useful for simple program tests but lacks validator transparency, multi-wallet support, and extensibility. 

Beargrease complements anchor test by offering full control and easy CI deployment.

#### 2. **Beargrease vs. ad hoc custom scripts**

Many teams end up writing their own validator/test harnesses. 

Beargrease gives you a structured, debug-friendly, shareable alternative without sacrificing transparency.

#### 3. **Beargrease vs. Solana Playground**

Playground is great for experimentation but not for full dApp development.

Beargrease bridges the gap from toy projects to full-stack real-world applications.

#### 4. **Beargrease vs. internal tools**

Larger teams often build their own CI/test infrastructure. These tend to be opaque, undocumented, and team-specific. 

Beargrease offers 90% of the power with none of the overhead --- and it's open source.



### Summary

Beargrease is not trying to replace every tool in the Solana ecosystem.

Instead, it focuses on being:

-   **Understandable** --- transparent Bash scripts
-   **Reproducible** --- consistent local + CI behavior
-   **Composable** --- integrates with your existing frontend/backend/test stack

If your project grows beyond the built-in features of Beargrease, you can extend it without fighting an abstraction layer.

📌 **See also:**

-   Appendix B.9 --- How to run Beargrease in CI
-   Part IV --- Advanced test scenarios and multi-service integration
-   README.md --- Landing page and setup instructions





---

## 🛣️ Migration Guide: From Beargrease to Amman

Beargrease is built for clarity, control, and composability. In many projects, it's all you'll need — a clean foundation that supports full-stack integration tests, wallet orchestration, and real validator logic.

But if your project eventually grows to require persistent snapshots, deeply cached state, or custom validator control inside Mocha, there are tools — like **Amman** — that can help.

This guide isn’t about outgrowing Beargrease. It’s about building so well that you're ready for new challenges. If you ever need to go there, we’ve got you covered.

---

### 🔄 When Might You Transition?

You might consider moving to Amman if:

- You need **persistent validator state** across multiple test phases
- You're testing complex **PDA graphs** or stateful chains of transactions
- You want to use **Amman's validator hooks** inside a TypeScript test runner
- You prefer TypeScript configuration over shell scripting

---

### 🔧 What Carries Over Cleanly

Beargrease encourages good structure that maps directly to Amman's expectations:

- Your **Anchor workspace**, `.idl` files, and `Anchor.toml`
- Your **wallets** in `.ledger/wallets/`
- Your **Mocha and TypeScript test files**
- Your **CI setup**, especially if you're already using GitHub Actions
- Your shared **program ID export via `.env.test`**

---

### 🧭 Basic Transition Steps

1. **Install Amman**

   ```bash
   yarn add --dev @metaplex-foundation/amman
   ```

2. **Create `amman.config.js`** to define programs, keypairs, and initial account state.

3. **Switch from Docker-based validator to Amman’s programmatic start**:

   ```ts
   import { Amman } from '@metaplex-foundation/amman';
   const amman = Amman.instance();
   before(async () => {
     await amman.startValidator();
   });
   ```

4. **Load `.env.test`** as needed using `dotenv` or move its values into your Amman config.

5. **Replace Beargrease scripts (`run-tests.sh`)** with Amman's snapshot and test runner integrations.

---

### ⚖️ Comparison Snapshot

| Feature           | Beargrease                | Amman                                 |
| ----------------- | ------------------------- | ------------------------------------- |
| Validator Style   | Stateless Docker per test | Persistent in-process local validator |
| State Reuse       | Fresh each run            | Optional snapshot-based reuse         |
| CLI / Test Runner | Shell + Mocha             | TypeScript + Mocha                    |
| Debugging         | Transparent shell + logs  | Human-readable viewer (optional)      |
| Isolation         | Containerized             | Local environment                     |

---

### ✅ Final Thought

Beargrease gives you real-world control without hidden layers. Amman adds optional complexity when you need deeper introspection or long-lived test state. 

Use what matches your current phase — and if you ever reach for more, know that Beargrease has already prepared you to take that next step with confidence.



---

## 🛣️ Migration Guide: From Amman to Beargrease

Not every project needs a persistent test validator, snapshot tooling, or lifecycle hooks. If you're looking to simplify your testing infrastructure, reduce dependencies, or improve CI portability, Beargrease offers a clean and controlled alternative to Amman.

This guide shows how to move from an Amman-based test setup to the transparent, script-driven environment Beargrease provides.

---

### 🔄 When Might You Transition?

You might consider moving to Beargrease if:

- You're experiencing friction maintaining **snapshots or fixtures**
- You want **clean state per test run** with no persistence
- You need **lightweight CI workflows** with minimal setup
- Your tests need to run in **isolated or containerized environments**
- You're teaching or onboarding contributors unfamiliar with Amman

---

### 🔧 What Carries Over Easily

Most Amman-based test setups can be adapted with little friction:

- Your **Anchor workspace**, `Anchor.toml`, and `.idl` files
- Your **test wallets**, already stored as `.json` files
- Your **Mocha and TypeScript tests**, which can run unchanged
- Any shared environment values like **program IDs or RPC URLs**

---

### 🧭 Basic Transition Steps

1. **Replace Amman’s validator hooks** with Beargrease's Docker orchestrated validator:

   ```bash
   ./scripts/beargrease/run-tests.sh
   ```

2. **Move any snapshot data** into fresh test wallet + program ID scripts.

3. **Create or migrate wallets** to `.ledger/wallets/` using:

   ```bash
   ./scripts/beargrease/create-test-wallet.sh
   ```

4. **Fund wallets** with:

   ```bash
   ./scripts/beargrease/fund-wallets.sh
   ```

5. **Expose your program ID** by updating it via:

   ```bash
   ./scripts/beargrease/update-program-id.sh
   ```

6. **Delete snapshot logic** and rely on the clean-state validator that Beargrease launches per run.

---

### ⚖️ Comparison Snapshot

| Feature           | Amman                             | Beargrease                         |
| ----------------- | --------------------------------- | ---------------------------------- |
| Validator Style   | In-process with lifecycle control | Stateless Docker container         |
| Snapshot Support  | Built-in                          | None (clean validator per run)     |
| Account Fixtures  | Snapshot-loaded                   | Script-created                     |
| Wallet Management | Config + helper scripts           | `.ledger/wallets/` + airdrop tools |
| CI Integration    | Requires environment setup        | One script: `run-tests.sh`         |
| Debugging         | Human-readable viewer (optional)  | Log-based, transparent             |
| State Clarity     | Can become implicit               | Always explicit and fresh          |

---

### ✅ Final Thought

This is not a downgrade — it's a recalibration. Amman is powerful for long-lived or snapshot-driven test environments. But Beargrease offers simplicity, isolation, and clarity — especially when you're testing real-world flows, working in CI, or preparing code for others to understand and build on.

If your testing needs shift, Beargrease is ready. One script. One container. Real state. Every time.
