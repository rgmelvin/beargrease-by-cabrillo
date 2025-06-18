# 🐻🧪 Beargrease TestKit (Preview)

Beargrease TestKit is a forward-looking extension of  Beargrease, designed to evolve into a full test intelligence and instrumentation system. While currently inactive, this directory will house modular tools that provide advanced test instrumentation, snapshotting, and replay capabilities for Solana development.

## 📐 Planned Features

- **Observability**
  - Emit structured logs and timing metrics
  - Visualize test pipeline bottlenecks
  - Distinguish local vs CI behavior automatically

- **Snapshotting**
  - Capture validator state at key lifecycle points
  - Compare ledger state across runs to detect drift
  - Store and diff test output artifacts

- **Replay Harness**
  - Recreate flaky test conditions
  - Reinject saved ledger and wallet state
  - Controlled environmental fuzzing

- **Debugging Hooks**
  - Add one-line shell breakpoints or assertions
  - Expose CI-only failures for local inspection
  - Custom step-by-step run modes

## 📁 Directory Structure (planned)

```plaintext
bg-testkit/
├── README.md
├── log/
│   └── bg-logger.sh         # Placeholder for structured logging
├── snapshot/
│   └── gb-snapshot.sh       # Snapshot and restore utilities
├── replay/
│   └── bg-replay.sh         # CLI-driven replay harness
└── hooks/
    └── bg-debug-hooks.sh    # Developer-defined hook points
```

*Note: .gitkeep placeholders are used to preserve empty directories for future scripts.*