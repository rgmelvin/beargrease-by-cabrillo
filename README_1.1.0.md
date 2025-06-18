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

## Version & Maintainer

- **Version:** v1.1.0
- **Maintained by:** Cabrillo! Labs
- **Contact:** cabrilloweb3@gmail.com
- **License:** MIT
- **GitHub:** [github.com/rgmelvin/beargrease-by-cabrillo](https://github.com/rgmelvin/beargrease-by-cabrillo)

---

## 📚 Getting Started

The Beargrease Beginner’s Guide walks you through setup, usage, architecture, and troubleshooting in both Local and GitHub CI environments. It is the recommended first step for all users.

- 📘 [Beargrease Beginner’s Guide (v1.1.0)](docs/BeginnerGuide.md)

The [Architecture Diagram](#architecture--flow) later in this README provides a visual overview of how Beargrease adapts to its environment.

---

## 🚀 What is Beargrease?

Beargrease is a test harness designed for developers that brings **clarity and reliability** to Solana Anchor testing. It detects whether you are running in a local or CI environment and adapts automatically—so you do not need to configure mode switches or rewrite test logic. It also detects your test language: if you supply Mocha tests (`.mts`, `.ts`, or `.js`), Beargrease runs them using Mocha; if you provide Rust-based Anchor tests (`.rs`), it executes them via `anchor test`.

Beargrease is a **test harness**, not a test-writing tool. It does not scaffold test files, generate stubs, or guide you through Solana’s program interaction model. It assumes that your tests are already written using standard Rust or TypeScript practices.

If you are new to writing tests for Solana Anchor programs, we recommend:

- [Anchor Testing Documentation](https://www.anchor-lang.com/docs/testing)
- [Coral Anchor Examples](https://github.com/coral-xyz/anchor/tree/master/examples)
- [Placebo](https://github.com/rgmelvin/placebo) — A minimal testable Anchor program using Beargrease

---

## ⚙️ What Beargrease Does

Beargrease coordinates your test lifecycle using portable shell scripts:

- 🐳 Starts a local `solana-test-validator` in Docker
- 🔐 Handles wallet creation or decoding (local or CI)
- 📂 Detects environment and test framework
- 📌 Injects deployed program ID into `Anchor.toml` and `lib.rs`
- 🧪 Runs either `mocha` (TypeScript) or `anchor test` (Rust), based on files present
- 🧹 Cleans up wallet and validator state appropriately

You do not need to configure flags, override behavior, or toggle between modes. Beargrease adapts transparently.

---

## ✨ Key Features

### Environment Awareness  
- Automatically detects CI vs local context  
- Chooses wallet location and wait timings accordingly  

### Validator Lifecycle via Docker  
- Runs validator in a clean container  
- Avoids port conflicts and residual ledger state  

### Wallet Management  
- **Local Mode**: Generates and stores keypairs in `.ledger/wallets/`  
- **CI Mode**: Accepts `BEARGREASE_WALLET_SECRET` and decodes it inside the container  

### Program ID Injection  
- Patches `Anchor.toml` and `lib.rs` with the correct deployed address  
- Prevents `DeclaredProgramIdMismatch` errors  

### Test Language Detection  
- Runs Mocha for `.mts`, `.ts`, `.js`  
- Runs `anchor test` for `.rs`  
- Chooses based on project contents automatically  

### Transparent Script Control  
- All behavior exposed via simple Bash/TS scripts  
- Easy to adapt, extend, or debug  

---

## 🧪 Who Should Use Beargrease?

Beargrease is ideal for:

- **CI/CD Pipelines**
- **Projects mixing Rust and TypeScript**
- **Developers needing observable test automation**
- **Teams using Docker-based validators**
- **Beginner or intermediate Solana developers who want reproducibility**

It is **not** a test generator or template tool. You bring the logic, Beargrease runs it—consistently.

---

## 📊 Beargrease vs Other Solana Test Runtimes

Beargrease is not the only Solana test harness—but it occupies a unique niche. Here is how it compares to other test runtimes:

| Tool              | Mode       | Language  | Runtime    | Strengths                                |
| ----------------- | ---------- | --------- | ---------- | ---------------------------------------- |
| **Beargrease**    | Local + CI | Rust + TS | Validator  | Realism, reproducibility, CI integration |
| **Bankrun**       | Local only | TS only   | Simulation | Speed, mocking                           |
| **Jest**          | Local only | TS only   | Simulation | Familiarity                              |
| **Anchor (Rust)** | Local + CI | Rust only | Validator  | Official, flexible                       |
| **LiteSVM**       | Local only | TS only   | Simulation | Lightweight, Solana Foundation-backed    |
| **Mollusk**       | CI only    | Rust only | Validator  | Snapshot, high-throughput CI             |

Beargrease is one of the few tools that supports both Rust and TypeScript in both local and CI environments, using a real Solana validator. Most alternatives are optimized for simulation or a single language.

---

## 🧠 How Beargrease Works (at a glance)

A Beargrease test run consists of 10 internal steps:

1. Start the validator container  
2. Check validator health  
3. Create or decode wallet  
4. Fund wallet if needed  
5. Build the Anchor program  
6. Deploy to local validator  
7. Inject program ID into source files  
8. Wait for indexer to see the program  
9. Run tests (Mocha or Anchor)  
10. Shut down container and clean up  

Each step is observable, modifiable, and fully automated. You can inspect or override any part of the flow.

---

## 🛠️ Developer Customization and Control

Beargrease is not a black box.

- Every step in the lifecycle is implemented as a real file.
- No flags or wrappers obscure behavior.
- You can inspect, override, or replace any step with your own logic.
- CI behavior is not hardcoded—just inferred from context.

Scripts are written in Bash or TypeScript, and designed to be readable and portable.

---

## 📚 Documentation and Learning Path

Beargrease comes with extensive, professional-grade documentation.

- **Start here**  
  → [Beargrease Beginner’s Guide (v1.1.0)](https://github.com/rgmelvin/beargrease-by-cabrillo/blob/main/docs/BeginnerGuide.md)  
  A complete walkthrough for running tests in Local Mode and CI Mode.

- **Understand how it works**  
  → [Visual Architecture Diagram](https://github.com/rgmelvin/beargrease-by-cabrillo/blob/main/docs/assets/beargrease-architecture.svg)  
  See exactly what scripts run, in what order, and where they can fail.

- **Try it in a real project**  
  → [Placebo Example Repository](https://github.com/rgmelvin/placebo)  
  A working Anchor program using Beargrease with Mocha and TypeScript tests.

- **Build your own test harness**  
  Beargrease is designed to be readable and modular. Copy, customize, and evolve it as needed.