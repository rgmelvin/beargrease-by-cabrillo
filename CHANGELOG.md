# 📜 Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

- Prepare `bg-testkit` modules for snapshotting, replay, and hooks.
- Plan `placebo-pro` enhanced scenario testing.
- Refactor all Beargrease scripts to conform with finalized Protocol and Style Guide.

## [Linter v0.1.0]-2025-07-14

### Added

- **Beargrease Shell Script Linter MVP**
  - `linter.sh` orchestrator
  - `linter-env.sh` shared environment loader
  - Complete suite of `.rules` scripts enforcing Cabrillo Labs standards.
- **Checks Implemented**
  - Shebang and strict mode
  - Structured header block
  - Shared module sourcing
  - CI guard or CI-safe declaration
  - Dependency check or explicit no-deps declaration
  - Exit code documentation
  - Final completion log
- **Placeholders Added** (for future work):
  - CLI parsing enforcement
  - Constants declaration pattern
  - Initialization sequence checks
  - Procedural steps enforcement
- **Documentation**
  - `linter/README.md`
  - Embedded NEXT STEPS guidance for each rule failure

### Status

- **Linter Version:** `v0.1.0`
- **Scope:** Linter only.
- **Ready to park pending full Beargrease script finalization.**
- 

## [Beargrease v1.1.0] - 2025-07-02

### Added
- run-tests.sh emergency shutdown trap
- Professional header comments with Maintainer, License, Source

### Changed
- Improved validator health check immediate failure handling
- Reorganized script step numbering for clarity

### Removed
- Former Step 5 duplicate validator health check (now integrated in Step 3)

---

### [Beargrease v1.0.0] - 2025-06-15

- Initial release of Beargrease with core validator lifecycle and test harness scripts.
