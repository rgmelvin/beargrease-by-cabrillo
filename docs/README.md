# Beargrease

A transparent, script-driven Solana Anchor test harness using Docker.

**Beargrease** makes it simple to spin up a local Solana validator, fund isolated test wallets, deploy Anchor programs, and run tests — all in a clean, reproducible Docker container.

---

## 🧭 Overview

Beargrease is designed for developers who want a clean, zero-conflict environment for testing Solana smart contracts. By wrapping `solana-test-validator` in a Docker container with carefully sequenced scripts, Beargrease:

- Avoids conflicts with local Solana CLI or wallet config
- Funds dedicated test wallets with localnet SOL
- Automatically builds and deploys your Anchor programs
- Runs your test suite using a standard `mocha` runner
- Provides readable logs and clear errors for debugging

---

## 📁 Directory Structure

```
beargrease/
├── Dockerfile
├── docker-compose.yml
├── scripts/
│   ├── airdrop.sh
│   ├── create-test-wallet.sh
│   ├── fund-wallets.sh
│   ├── run-tests.sh
│   ├── update-program-id.sh
│   ├── version.sh
│   └── wait-for-validator.sh
├── .gitignore
├── .dockerignore
├── README.md
└── docs/
    ├── BeginnerGuide.md
    └── DockerInstall.md
```

---

## 🚀 Quick Start

Run this from your Anchor project folder:

```bash
../beargrease/scripts/run-tests.sh
```

This automatically:
- Builds and launches the Docker validator
- Waits until the RPC is healthy
- Builds and deploys your Anchor program
- Airdrops SOL to your test wallet(s)
- Runs your Mocha tests

---

## 🛠️ Scripts

| Script                  | Description |
|------------------------|-------------|
| `create-test-wallet.sh`| Generates and saves new local test wallets in `.ledger/wallets/` |
| `airdrop.sh`           | Airdrops localnet SOL to a test wallet |
| `fund-wallets.sh`      | Funds multiple test wallets with localnet SOL |
| `wait-for-validator.sh`| Blocks until the validator’s RPC endpoint is healthy |
| `update-program-id.sh` | Replaces `lib.rs` and `Anchor.toml` program ID after deployment |
| `run-tests.sh`         | Orchestrates full test flow from Docker boot to test execution |
| `version.sh`           | Prints the Solana version used inside the container |

---

## 🐳 Docker Details

Beargrease wraps the Solana test validator in a lightweight container using this base image:

```dockerfile
solanalabs/solana:latest
```

**Ports exposed:**
- `8899` – RPC (used by Anchor)
- `8900` – Gossip
- `8001` – Faucet

No Solana CLI or Anchor CLI installation is required on the host — everything runs inside Docker.

---

## 📚 Documentation

- 📘 [Beginner Guide](./docs/BeginnerGuide.md) – Full walk-through of setup and usage
- 🔧 [Docker Install Guide](./docs/DockerInstall.md) – For Linux, macOS, WSL

---

## 📜 License

MIT © Cabrillo Labs, Ltd.  
Contact: cabrilloweb3@gmail.com

---

## 🐻 Why “Beargrease”?

Named after the legendary John Beargrease, the North Shore mail carrier who braved the harshest winters to deliver with reliability. This tool does the same for your Solana test pipeline.
