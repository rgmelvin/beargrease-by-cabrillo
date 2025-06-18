# 🐻  Beargrease

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![CI Ready](https://img.shields.io/badge/CI-Ready-brightgreen.svg)](#github-ci-mode)
[![Shell Scripts](https://img.shields.io/badge/scripts-shell-89e051.svg)](#%EF%B8%8F-how-it-works)
[![Docker Validator](https://img.shields.io/badge/solana-test--validator-blue.svg)](https://docs.solana.com/developing/test-validator/using-test-validator)
[![TypeScript ESM](https://img.shields.io/badge/typescript-ESM%20Mocha-blueviolet)](#script-execution-order)

*Solana Anchor testing that just works*

**Reliable Solana test automation, without the guesswork.**
Beargrease is a fast, transparent, environment-aware, script-driven test harness for Solana Anchor programs. It automates validator startup, wallet setup, program deployment, and test execution for both local development and GitHub Actions Continuous Integration (CI).

---

## Table of Contents

- [Version & Maintainer](#version--maintainer)
- [What is Beargrease?](#what-is-beargrease)
- [What Beargrease Does](#what-beargrease-does)
- [✨ Features](#-features)
- [🧠 Smart by Design](#-smart-by-design)
- [📊 Comparing Beargrease to Other Solana Testing Tools](#-comparing-beargrease-to-other-solana-testing-tools)
- [⚠️ Two Modes of Use](#️-two-modes-of-use)
- [Quick Start - Local & CI](#quick-start---local--ci)
- [📚 Beginner Guides](#-beginner-guides)
- [Example: Placebo Test Project](#example-placebo-test-project)
- [Architecture & Flow](#architecture--flow)
- [Script Execution Order](#script-execution-order)
- [🧰 Script Reference](#-script-reference)
- [🐞 Troubleshooting & Support](#-troubleshooting--support)
- [🔐 Security Notice](#-security-notice)
- [👩‍🔬 For Developers](#-for-developers)
- [Preview of `bg-testkit/` Purpose and Vision](#preview-of-bg-testkit-purpose-and-vision)
- [🛡️ Attribution](#️-attribution)
- [🐻 Why “Beargrease”?](#-why-beargrease)
- [About the Author](#about-the-author)
- [License](#license)

---

## Version & Maintainer

- **Version:** v1.1.0
- **Maintained by:** Cabrillo! Labs
- **Contact:** cabrilloweb3@gmail.com
- **License:** MIT
- **GitHub:** [github.com/rgmelvin/beargrease-by-cabrillo](https://github.com/rgmelvin/beargrease-by-cabrillo)

---

## What is Beargrease?

Beargrease is a test harness designed for developers that brings **clarity and reliability** to Solana Anchor testing. It detects whether you are running in a local or CI environment and adapts automatically—so you do not need to configure mode switches or rewrite test logic. It also detects your test language: if you supply Mocha tests (`.mts`, `.ts`, or `.js`), Beargrease runs them using Mocha; if you provide Rust-based Anchor tests (`.rs`), it executes them via `anchor test`.

Beargrease was built to eliminate fragile validator setups and to give developers tools they can trust. It provides:

- Environment detection: local vs. CI
- Docker-based `solana-test-validator` for isolated test runs
- Program deployment and automatic ID injection
- Wallet creation and funding (for local and CI modes)
- Test execution via Mocha or `anchor test`, based on your project
- Clean teardown after each run

Beargrease is a **test harness**, not a test-writing tool. It does not scaffold test files, generate stubs, or guide you through Solana’s program interaction model. It assumes that your tests are already written using standard Rust or TypeScript practices.

You bring the test logic. Beargrease runs it—cleanly, visibly, and consistently across both local and GitHub CI environments.

If you are new to writing tests for Solana Anchor programs, we recommend:

- [Anchor Testing Documentation](https://www.anchor-lang.com/docs/testing)
- [Coral Anchor Examples](https://github.com/coral-xyz/anchor/tree/master/examples)
- [Placebo](https://github.com/rgmelvin/placebo) — A minimal testable Anchor program using Beargrease

---

### How It Works – At a Glance

After installing Beargrease and preparing your testable Anchor project:

```bash
$ ./scripts/run-tests.sh
```

Beargrease will:

- Launch a Docker-based Solana test validator
- Deploy your program and inject its ID
- Create or decode a wallet
- Run your `.mts` (TypeScript) or `.rs` (Rust) tests
- Shut everything down cleanly

All from a single command. No guesswork. No lingering containers.

📘 **Need help getting started?**
 See the [Beargrease Beginner Guide](https://github.com/rgmelvin/beargrease-by-cabrillo/blob/main/docs/BeginnerGuide.md) for step-by-step walkthroughs in both local and GitHub CI environments.

---

## Key Features

### Environment Awareness
Beargrease automatically detects whether it is running locally or in GitHub CI. It adapts wallet handling, validator timing, file paths, and execution mode accordingly—without requiring mode flags or reconfiguration.

### Validator Lifecycle via Docker
Spins up a fresh `solana-test-validator` container for every run, ensuring full isolation, reproducibility, and zero port or ledger conflicts. Cleans up automatically after test completion.

### Wallet Management
- **Local Mode**: Generates keypairs under `.ledger/wallets/`
- **CI Mode**: Accepts a `BEARGREASE_WALLET_SECRET`, which is securely decoded inside the container and used at runtime.

### Program ID Injection
Automatically patches both `Anchor.toml` and `lib.rs` with the deployed program ID—preventing `DeclaredProgramIdMismatch` errors and ensuring that your test program runs with the correct address every time.

### Mocha or Anchor Test Detection
Executes tests using Mocha (for `.mts`, `.ts`, or `.js` files) or `anchor test` (for Rust files), based on what it finds in the test directory. No manual switching required.

---

### Beginner-Friendly Documentation

Beargrease is not just a tool—it is a teaching platform.

It includes:

- A full [Beginner Guide](https://github.com/rgmelvin/beargrease-by-cabrillo/blob/main/docs/BeginnerGuide.md) that walks you through setup, execution, troubleshooting, and customization.
- A visual test architecture diagram that demystifies how the harness operates.
- Fully transparent Bash and TypeScript scripts—no opaque wrappers, no black-box magic.

Whether you are debugging your first Solana test or building a production CI pipeline, the documentation shows you exactly what Beargrease is doing and how to adapt it.

---

## Who Should Use Beargrease?

Beargrease is designed for developers who need **clean, reproducible, and transparent test execution** for Solana programs using the Anchor framework. It is ideal for:

- **Teams building CI/CD pipelines**
   Runs cleanly inside GitHub Actions and other CI systems with full validator lifecycle control and no fragile local setup.
- **Developers working in both Rust and TypeScript**
   Automatically detects and runs either Mocha-based TypeScript tests or `anchor test` suites with no manual switches or config changes.
- **Builders who care about visibility and reproducibility**
   Every step is scriptable, observable, and overrideable. You are never left guessing what ran, what failed, or why.
- **Projects that use Docker-based validators**
   Beargrease launches a fresh `solana-test-validator` inside Docker for every run—isolated, ephemeral, and teardown-safe.
- **Those new to Solana test harnesses**
   With full beginner documentation, architecture diagrams, and annotated scripts, Beargrease is a welcoming entry point for serious testing.

Beargrease is **not** a test-writing tool. It does not scaffold or generate your `.ts` or `.rs` test files.
 It assumes you already know what to test—**and makes sure your tests run cleanly, every time.**

📘 For writing tests, see the official [Anchor testing documentation](https://www.anchor-lang.com/docs/testing) or explore [Placebo](https://github.com/rgmelvin/placebo) for a minimal working example.

---

## What Beargrease Does

Beargrease coordinates your entire test lifecycle using portable shell scripts:

- 🐳 Starts a local `solana-test-validator` in Docker
- 🔐 Handles wallet creation or decoding (local or CI)
- 📂 Detects environment and test framework
- 📌 Injects deployed program ID into `Anchor.toml` and `lib.rs`
- 🧪 Runs either `mocha` (TypeScript) or `anchor test` (Rust), based on files present
- 🧹 Cleans up wallet and validator state appropriately

Whether in GitHub CI or on your machine, Beargrease adapts automatically.

---

### 🧠 Smart by Design

Beargrease uses environment detection internally to choose the correct paths:

- `.ledger/wallets/...` for local use
- `/wallet/id.json` via `init-wallet.sh` in CI
- Automatically selects wait times, injects program ID, and chooses `anchor test` or `mocha` as needed

You do not have to configure anything else. Just run `run-tests.sh`.

---

### 📊 Comparing Beargrease to Other Solana Testing Tools

In the evolving Solana development ecosystem, several test frameworks and runtime options now exist. Beargrease remains uniquely focused on **full validator-based test orchestration**, designed for clarity, reliability, and total transparency across both local and CI environments. Other solutions may prioritize speed, virtualization, or minimal setup.

Here’s a comparison of current options:

| Feature / Tool                | **Beargrease**                                           | [**LiteSVM**](https://www.anchor-lang.com/docs/testing/litesvm) | [**Mollusk**](https://www.anchor-lang.com/docs/testing/mollusk) | [**Bankrun**](https://github.com/ar-nelson/bankrun) | **Jest + @solana/web3.js** |
| ----------------------------- | -------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | --------------------------------------------------- | -------------------------- |
| **Test Runtime**              | Full `solana-test-validator` in Docker                   | Virtualized Solana SVM runtime (no validator)                | Virtualized transaction emulator                             | Rust-based emulator                                 | JavaScript test runtime    |
| **CI Compatible**             | ✅ Native GitHub Actions support with secrets             | ✅ Works in CI (requires Node.js)                             | ✅ Lightweight & fast                                         | ⚠️ Not CI-native (manual)                            | ✅ With Node.js setup       |
| **Language Support**          | TypeScript (Mocha), Rust (`anchor test`)                 | TypeScript + Anchor macros                                   | TypeScript + Anchor macros                                   | Rust only                                           | TypeScript only            |
| **Test Lifecycle Automation** | ✅ Full lifecycle: validator, wallet, program ID, cleanup | ❌ Manual runtime setup                                       | ❌ Manual runtime setup                                       | ❌ Manual                                            | ❌ No built-in setup        |
| **Program ID Injection**      | ✅ Auto-injected into `Anchor.toml`, `lib.rs`             | ❌ Manual                                                     | ❌ Manual                                                     | ❌ Manual                                            | ❌ Manual                   |
| **Validator Needed**          | ✅ Yes (isolated Docker container)                        | ❌ No validator needed                                        | ❌ No validator needed                                        | ❌ No validator needed                               | ❌ No validator needed      |
| **Parallel Execution**        | ✅ CI parallelism possible with manual setup              | ✅ Fast by default                                            | ✅ Fast by default                                            | ⚠️ Possible but undocumented                         | ✅ If designed manually     |
| **Environment Awareness**     | ✅ Fully automated mode detection (CI vs local)           | ❌ Manual config                                              | ❌ Manual config                                              | ❌ Manual                                            | ❌ Manual CI setup          |
| **Beginner-Friendly Guides**  | ✅ Rich prose guides, diagrams, and appendices            | ❌ Sparse docs                                                | ❌ Sparse docs                                                | ❌ Sparse or experimental                            | ❌ Community dependent      |
| **Best Use Case**             | Full validator testing in CI + Web3 + SPL                | Lightning-fast local test loops                              | Runtime-agnostic Anchor test switcher                        | Emulator-style logic testing                        | Lightweight JS unit tests  |

Beargrease’s goal is not to replace these tools but to **complement** them — by ensuring you always have a stable, validator-faithful test harness for workflows that demand full Solana behavior and external interactions.

---

## ⚠️ Two Modes of Use

Beargrease supports two primary modes of operation:

🖥️ Local Mode (runs test on your machine) and ☁️ CI Mode (runs tests in GitHub Actions). But you rarely need to decide anything - Beargrease senses the environment, selects the correct wallet strategy, and proceeds transparently.

| Mode         | Description                                         | Use When...                           |
| ------------ | --------------------------------------------------- | ------------------------------------- |
| 🖥️ Local Mode | Run tests manually using Docker on your dev machine | You're actively building or debugging |
| ☁️ CI Mode    | Runs in GitHub Actions using dynamic repo checkout  | You want automated tests on push/PR   |

### 📘 Choose the right guide:

- 👉 [Beginner Guide – Local Mode (v1.0.x)](docs/BeginnerGuide.md)
- 👉 [Beginner Guide – CI Mode (v1.1.0+)](docs/BeginnerGuide-CI.md)

---



## Quick Start - Local & CI

### Usage Modes

Beargrease supports both **Local Mode** and **GitHub CI Mode**, using the *same scripts*. It detects the environment automatically and adapts validator startup, wallet management, and wait timing without requiring user intervention.

#### 🖥️ Local Mode (Developer Machine). (manual)

```
bashCopyEdit# From your Anchor project root
mkdir -p scripts
cp -r ../beargrease/scripts ./scripts/beargrease
chmod +x ./scripts/beargrease/*.sh

# Run full test suite
./scripts/beargrease/run-tests.sh
```

- 🐳 Spins up a Docker-based `solana-test-validator`
- 🔐 Loads or generates a wallet in `.ledger/wallets/`
- 🧪 Runs your Anchor tests after auto-patching the program ID

#### ☁️ GitHub CI Mode (Automated Testing)

```
yamlCopyEditjobs:
  test:
    steps:
      - name: 📥 Checkout project
        uses: actions/checkout@v4

      - name: 🐻 Checkout Beargrease
        uses: actions/checkout@v4
        with:
          repository: rgmelvin/beargrease-by-cabrillo
          path: beargrease

      - name: 🚀 Run Beargrease Test Harness
        run: ./beargrease/scripts/run-tests.sh
        env:
          BEARGREASE_WALLET_SECRET: ${{ secrets.WALLET_SECRET }}
```

- 🔐 Provide a GitHub Actions secret `WALLET_SECRET` (base64-encoded keypair)
  - Navigate to **GitHub → Settings → Secrets → Actions → New repository secret**
- Wallet is decoded inside the container; no local files are needed

------



## Example: Placebo Test Project

Want to see it in action? Visit the official demo repo:
👉 https://github.com/rgmelvin/placebo

Placebo is a minimal Anchor project fully integrated with Beargrease.

---



## 📚 Beginner Guides

- 🖥️ [Local Mode Guide (v1.0.x)](docs/BeginnerGuide.md)
- ☁️ [CI Mode Guide (v1.1.0+)](docs/BeginnerGuide-CI.md)

---



## Architecture & Flow

Beargrease works by orchestrating:

- 🐳 A Docker-based local Solana validator
- 🔐 Test wallet creation and airdrop
- 📌 Program deployment and ID patching
- 🧪 Mocha/ESM-compatible TypeScript test execution

---

### **Figure: Full Environment-Aware Execution Flow of Beargrease (v1.1.0+)**

The diagram below shows the complete Beargrease test harness flow as implemented in version 1.1.0+. A single entrypoint (`run-tests.sh`) is used in both **Local** and **CI** environments. The script **automatically detects** its execution context and invokes the appropriate wallet setup, validator timing, and cleanup procedures based on environment.

- **Local Mode**: The user manually copies Beargrease scripts into their project. Wallets are created using `create-test-wallet.sh` and persisted under `.ledger/wallets/`. Wait durations for validator and program indexing are kept short to optimize the developer feedback loop.
- **CI Mode**: A GitHub Actions workflow checks out the user's project and the Beargrease repo as a subdirectory. Wallets are securely decoded from `BEARGREASE_WALLET_SECRET` via `init-wallet.sh`. The system adapts wait durations to account for containerized validator startup times and indexing delays. Wallets are ephemeral and cleared upon container shutdown.

Throughout both flows, the same core scripts are used — but they alter behavior internally based on environment. This ensures users do **not** need to manually configure test harness differences between local development and CI pipelines. Even test runner selection (Mocha vs. Anchor) is determined dynamically.

The diagram also highlights script chaining behavior: for example, `run-tests.sh` calls `wait-for-validator.sh`, `update-program-id.sh`, and ultimately runs tests. Control flow and environment sensing are explicitly shown before every major step to reinforce Beargrease’s **transparent, adaptive architecture**.

```mermaid
flowchart TD
    %% Setup Phase
    A1[🖥️ Local: Copy Beargrease scripts into your project]
    A2[☁️ CI: Checkout your project repo and checkout Beargrease as subdirectory]
    A1 --> B[▶️ run-tests.sh]
    A2 --> B[▶️ run-tests.sh]

    %% Shared detection
    B --> DETECT[🧠 Detect Environment]
    DETECT --> Local_Entry_Point
    DETECT --> CI_Entry_Point

    %% Local Flow
    subgraph LOCAL [🖥️ Local Execution Path]
        direction TB
        Local_Entry_Point --> V1[▶️ start-validator.sh] --> V2[🐳 Start solana-test-validator via Docker]
        V2 --> W1[▶️ wait-for-validator.sh] --> W2[🧠 Detect Environment] --> W3[⏳ Short wait for validator healthcheck]
        W3 --> L1[🧠 Detect Environment] --> L2[▶️ create-test-wallet.sh] --> L3[🔐 Load wallet from .ledger/wallets/...]
        L3 --> U1[▶️ update-program-id.sh] --> U2[📌 Inject Program ID: Anchor.toml, lib.rs]
        U2 --> WP1[▶️ wait-for-program.ts] --> WP2[🧠 Detect Environment] --> WP3[🔍 Confirm program ID indexed -short wait]
        WP3 --> T1[▶️ run-tests.sh] --> T2[🧠 Detect Environment] --> T3[🧪 Run Mocha or Anchor tests]
        T3 --> CLEAN_LOCAL[🧹 Wallet persists in .ledger/wallets/]
    end

    %% CI Flow
    subgraph CI [☁️ GitHub CI Execution Path]
        direction TB
        CI_Entry_Point --> V3[▶️ start-validator.sh] --> V4[🐳 Start solana-test-validator via Docker]
        V4 --> W4[▶️ wait-for-validator.sh] --> W5[🧠 Detect Environment] --> W6[⏳ Long wait for validator healthcheck]
        W6 --> L4[🧠 Detect Environment] --> L5[▶️ init-wallet.sh] --> L6[🔐 Decode BEARGREASE_WALLET_SECRET]
        L6 --> U3[▶️ update-program-id.sh] --> U4[📌 Inject Program ID: Anchor.toml, lib.rs]
        U4 --> WP4[▶️ wait-for-program.ts] --> WP5[🧠 Detect Environment] --> WP6[🔍 Confirm program ID indexed -long wait]
        WP6 --> T4[▶️ run-tests.sh] --> T5[🧠 Detect Environment] --> T6[🧪 Run Mocha or Anchor tests]
        T6 --> CLEAN_CI[♻️ Wallet cleared when container exits]
    end

    %% Converged Exit
    CLEAN_LOCAL --> SHUTDOWN[🛑 Shut down validator]
    CLEAN_CI --> SHUTDOWN

```

---

## Script Execution Order

Beargrease coordinates a series of environment-aware scripts that prepare the Solana test validator, manage wallet access, inject the program ID, and run the correct test suite. The execution flow is **identical in both local and CI contexts**, but key scripts adapt their behavior based on the detected environment.

Below is a summary of script execution order and purpose, matched to the [Architecture & Flow Diagram](#architecture--flow).

### 🟢 Master Entry Point

| Script         | Purpose                                                      |
| -------------- | ------------------------------------------------------------ |
| `run-tests.sh` | The top-level orchestrator. Detects environment, launches validator, injects program ID, waits for indexing, and finally runs tests. This script calls nearly all others. |



------

### 🐳 Validator Launch Phase

| Script                  | Called By                                   | Purpose                                                      |
| ----------------------- | ------------------------------------------- | ------------------------------------------------------------ |
| `start-validator.sh`    | `run-tests.sh`                              | Shuts down any running validator, then starts a fresh Solana validator via Docker. |
| `wait-for-validator.sh` | `run-tests.sh` → after `start-validator.sh` | Waits until the validator passes a health check. Will be updated to wait longer in CI than local. (Environment-aware) |



------

### 🔐 Wallet Setup Phase

| Script                  | Called By                   | Purpose                                                      |
| ----------------------- | --------------------------- | ------------------------------------------------------------ |
| `create-test-wallet.sh` | `run-tests.sh` (local only) | Creates and stores a test wallet under `.ledger/wallets/`. Used only in local mode. |
| `init-wallet.sh`        | `run-tests.sh` (CI only)    | Decodes the `BEARGREASE_WALLET_SECRET` into `/wallet/id.json` inside the container. Used only in CI. |



------

### 📌 Program ID Injection Phase

| Script                 | Called By      | Purpose                                                      |
| ---------------------- | -------------- | ------------------------------------------------------------ |
| `update-program-id.sh` | `run-tests.sh` | Replaces the program ID in both `Anchor.toml` and `lib.rs` using the deployed address. Shared by both environments. |



------

### ⏳ Index Wait Phase

| Script                | Called By      | Purpose                                                      |
| --------------------- | -------------- | ------------------------------------------------------------ |
| `wait-for-program.ts` | `run-tests.sh` | Waits until the deployed program ID appears in the validator index. Wait time will be tuned by environment. (Environment-aware) |



------

### 🧪 Test Execution Phase

| Script         | Called By      | Purpose                                                      |
| -------------- | -------------- | ------------------------------------------------------------ |
| `run-tests.sh` | Self-contained | Automatically chooses between `anchor test` and Mocha (`*.test.mts`) based on presence of test files. This is environment-independent logic. |



------

### 🧹 Cleanup Phase

| Method                | Context | Behavior                                                     |
| --------------------- | ------- | ------------------------------------------------------------ |
| Wallet persists       | Local   | `.ledger/wallets/...` is retained unless manually deleted.   |
| Wallet cleared        | CI      | Secret wallet is mounted into container and discarded when the container exits. |
| `docker compose down` | Both    | Handled by `run-tests.sh` automatically, shutting down the validator at the end of the run. |

---



## 🧰 Script Reference

| Script                  | Purpose                      |
| ----------------------- | ---------------------------- |
| `start-validator.sh`    | Launch Docker validator      |
| `wait-for-validator.sh` | Await healthcheck success    |
| `create-test-wallet.sh` | Generate local wallet        |
| `airdrop.sh`            | Airdrop to a wallet          |
| `fund-wallets.sh`       | Batch fund wallets           |
| `update-program-id.sh`  | Patch program ID into config |
| `run-tests.sh`          | Run all steps and test suite |
| `version.sh`            | Echo Beargrease version      |

---

## 🐞 Troubleshooting & Support

If you run into issues:

- See the [Appendix B](docs/BeginnerGuide.md#appendix-b--troubleshooting-and-technical-reference) in the Beginner CI Guide
- Or email: **cabrilloweb3@gmail.com**

---

## 🔐 Security Notice

Beargrease generates and handles plaintext wallets. Never use real wallets or mainnet deployments.

- In local mode: keys live in `.ledger/wallets/`
- In CI: use ephemeral base64 secrets only
- Do not commit wallet files

If you suspect a security issue, email **cabrilloweb3@gmail.com**

---

## 👩‍🔬 For Developers

Beargrease is modular and extensible:

- ✅ [Mocha + ESM](https://github.com/rgmelvin/beargrease-by-cabrillo/blob/main/tests/placebo.test.mts) support built-in
- 🧪 [`bg-testkit/`](https://github.com/rgmelvin/beargrease-by-cabrillo/tree/main/bg-testkit) stub for future logging, snapshotting, and observability
- 🔧 Transparent shell-based control over lifecycle and test flow via [`scripts/`](https://github.com/rgmelvin/beargrease-by-cabrillo/tree/main/scripts)
- 📁 Scripts are portable, readable, and easy to adapt — especially [`run-tests.sh`](https://github.com/rgmelvin/beargrease-by-cabrillo/blob/main/scripts/run-tests.sh)

**Want to use a different test runner?**

Beargrease currently supports Mocha and Anchor (`anchor test`), but `run-tests.sh` could be adapted for additional runners (*e.g.*, Vitest, Jest, Ava).

Consider adding a `--runner` flag or customizing detection logic if your project uses a different testing framework.

Want to contribute? Fork it, tweak it, break it, fix it, go w — and send a PR 🛠️

---



### **Preview of `bg-testkit/` Purpose and Vision**

| Feature                      | Description                                                  |
| ---------------------------- | ------------------------------------------------------------ |
| 📊 **Observability Tools**    | Capture logs, transaction details, and execution traces during tests. |
| 🧪 **Snapshot Support**       | Allow saving and comparing validator state snapshots across runs. |
| 📈 **Test Metrics**           | Emit timing and success/failure stats for test phases (e.g., validator boot, wallet injection, program indexing). |
| 🔁 **Replay/Test Harnessing** | Simulate test scenarios offline using cached state and deterministic input replay. |
| 🛠️ **Advanced Debugging**     | Include hooks or wrappers to diagnose CI-only failures, stuck state, or flaky setup timing issues. |

---



## 🛡️ Attribution

Created and maintained by **Richard G. Melvin**, founder of **Cabrillo! Labs**.
If you use Beargrease, please credit the project and link back to this repo.

---



## 🐻 Why “Beargrease”?

Named respectfully for **John Beargrease**, the Ojibwe, First American mail carrier who delivered the post by dog sled through blizzards and over frozen lakes along Minnesota’s North Shore in the 1800s.
Beargrease is built to deliver your tests with the same kind of reliability.

---



## About the Author

I’m **Richard (Rich) G. Melvin**, founder of Cabrillo! Labs. I hold a Ph.D. in Biochemistry and Molecular Genetics from the University of New South Wales, and I’m self-taught in systems programming, smart contracts, and decentralized infrastructure. Beargrease reflects my goal of building serious, approachable tools that help researchers and developers own their work in Web3.

---



## License

[MIT License](https://openshource.org/licenses/MIT)
© 2025 Cabrillo! Labs