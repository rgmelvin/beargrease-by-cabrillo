#  <img src="Images/CabrilloIcon.png" alt="CabrilloIcon" width="75" />Cabrillo Labs 

# <img src="Images/BeargreaseIcon.png" alt="BeargreaseIcon" width="75" />Beargrease Shell Script Protocol and Style Guide

**Version:** 1.0
 **Maintainer:** Cabrillo Labs, Ltd.
 **Applies to:** All `.sh` scripts in the Beargrease project
 **Status:** Authoritative directive — compliance is required
 **Last Updated:** July 2025

------

1. # **Table of Contents**

   1. [Purpose and Scope](#purpose-and-scope)
   2. [Beargrease Philosophy: Rigor as a Precondition for Evolution](#beargrease-philosophy-rigor-as-a-precondition-for-evolution)
   3. [Guiding Principles](#guiding-principles)
   4. [Beargrease as a Home for Users](#beargrease-as-a-home-for-users)
   5. [Required Behaviors](#required-behaviors)
   6. [Evolution and Enforcement](#evolution-and-enforcement)

   ------

   ## **Non-Negotiable Requirements**

   1. [Logging](#logging)
   2. [Failure Handling](#failure-handling)
   3. [Exit Codes](#exit-codes)
   4. [Environment Awareness](#environment-awareness)
   5. [Shared Modules](#shared-modules)
   6. [Script Structure](#script-structure)

   ------

   ## **The 10 Required Structural Sections**

   1. [1. Shebang and Safety Settings](#1-shebang-and-safety-settings)
   2. [2. Script Header Block](#2-script-header-block)
   3. [3. Beargrease Shared Module Sourcing](#3-beargrease-shared-module-sourcing)
   4. [4. CLI Flags Parsing](#4-cli-flags-parsing)
   5. [5. CI Guard (if applicable)](#5-ci-guard-if-applicable)
   6. [6. Initialization](#6-initialization)
   7. [7. Constants and Path Setup](#7-constants-and-path-setup)
   8. [8. Dependency Check](#8-dependency-check)
   9. [9. Script Procedure Steps](#9-script-procedure-steps)
   10. [10. Completion](#10-completion)

   ------

   ## **Additional Standards**

   1. [Shared Module Libraries](#shared-module-libraries)
   2. [Logging System Requirements](#logging-system-requirements)
   3. [Failure Handling](#failure-handleing)
   4. [CLI Flag Parsing via parse_cli.sh](#cli-flag-parsing-via-parse_clish)
   5. [Exit Codes (Expanded)](#exit-codes-expanded)
   6. [Script Submission Requirements](#script-submission-requirements)
   7. [Summary](#summary)

   ------

   ## **Appendices**

   1. [Appendix A: Logging Function Reference](#appendix-a-logging-function-reference)
   2. [Appendix B: Canonical Exit Code Registry](#appendix-b-canonical-exit-code-registry)
   3. [Appendix C: CI Guard Examples and Behavior Matrix](#appendix-c-ci-guard-examples-and-behavior-matrix)
   4. [Appendix D: Structural Template (Full Script Skeleton)](#appendix-d-structural-template-full-script-skeleton)
   5. [Appendix E: Troubleshooting Submission Rejection Scenarios](#appendix-e-troubleshooting-submission-rejection-scenarios)
   6. [Appendix F: Beargrease Submission Checklist (Author Use)](#appendix-f-beargrease-submission-checklist-author-use)
   7. [Quick Reference Sheet](#quick-reference-sheet)



## Purpose and Scope

This document defines the **official style and procedural standard for all Beargrease shell scripts**. It provides specific requirements for structure, behavior, and output, ensuring that each script operates safely, produces transparent and traceable logs, and contributes to the long-term integrity of the test harness. As a **style guide**, the document assists collaborators in writing Beargrease scripts that support the continuous evolution of the system. As a **binding directive**, it enforces shared standards that guarantee Beargrease remains clear, extensible, and dependable as the ecosystem grows.

We begin by outlining the **development philosophy that underpins these requirements**, explaining why rigor and clarity are not optional but essential. We then detail the **non-negotiable structural, behavioral, and diagnostic components** required of every Beargrease script, from logging conventions to exit code semantics. By reading on, contributors will learn not just how to comply with the standard, but **why each element exists and how it enables confident, collaborative development in Beargrease**.



[🔝 Back to Table of Contents](#table-of-contents)

---



## The Beargrease Philosophy: Rigor as a Precondition for Evolution

Beargrease shell scripts are not casual utilities. They are **instrumented diagnostic tools**, carefully constructed to **automate the running of tests in a transparent, reproducible, and inspectable manner**. Each component—whether a log line, an exit code, or a conditional check—should contribute to a clear understanding of system state and process outcome. Every action must be **intentional**, **auditable**, and **justified**.

At Cabrillo Labs, we recognize that the purpose of scripting is to automate processes. However, we maintain that scripts must also **produce clarity, both locally and across the complex automation ecosystems they participate in**. A Beargrease script is expected to execute its task, but also to **explain itself**. It should leave behind a traceable record of what was attempted, what succeeded, what failed, and—if failure occurs—what to do next.

Logs are not an afterthought. They are **evidence of system state and transition**. Failures are not exceptions or anomalies. They are **informational events in the system lifecycle**, and they must be documented clearly and accompanied by actionable recovery steps. By recognizing both success and failure as information, we **harness them as guides for evolution**, improving both the system and our understanding of it over time.

This is not style; it is **protocol**. Beargrease scripts must avoid hidden behavior, untraceable side effects, or unclear logic flows. Each script is designed to **reveal something about system behavior and support the continuous improvement of Beargrease itself**.



[🔝 Back to Table of Contents](#table-of-contents)

---



## Guiding Principles

- **Scripts are diagnostic tools, not convenience wrappers**
   They help establish what is known, how it is known, and what to do when knowledge is incomplete.
- **Automation is not the sole goal**
   The objective is to produce automated workflows that are **clear, reproducible, and maintainable**.
- **Structure matters**
   Format, logging, exit codes, and procedural steps must be predictable and easy to read.
- **Logs are part of the protocol**
   They are not optional notes—they are part of the formal output surface.
- **Failures must teach**
   When a script fails, it must explain the cause, document the consequences, and guide the user toward resolution.
- **Ambiguity is a system defect**
   If a script leaves room for misinterpretation, it is incomplete.



[🔝 Back to Table of Contents](#table-of-contents)

---



## Beargrease as a Home for Users

By enforcing this structure, Beargrease provides users with more than just scripts, it provides a **system they can trust and stay within**. Users do not need to look elsewhere for ad hoc fixes or unsanctioned workarounds. The system is designed to be **self-explanatory, recoverable, and extensible without drift**.

When Beargrease encounters a limitation, it reveals and admits to that limitation honestly. By doing so, it often **solves problems rather than merely reporting failures**, because it forces awareness of where and how failure modes arise. This transparency is part of the harness’s reliability. It builds user confidence not just in successful runs, but in the system’s ability to anticipate and handle the unexpected with integrity.



[🔝 Back to Table of Contents](#table-of-contents)

---



## Required Behaviors

Every Beargrease script **must**:

- Begin with a clear declaration of context, purpose, and constraints
- Detect and document preconditions and dependencies
- Use structured logging to provide evidence of actions and outcomes
- Surface errors with unambiguous codes and recovery instructions
- Terminate visibly, with an explicit statement of result



[🔝 Back to Table of Contents](#table-of-contents)

---



## Evolution and Enforcement

This document is the **definitive directive** for all `.sh` scripts in Beargrease.
 **No script may be merged, executed, or distributed unless it complies fully with this standard, or has received written exemption from the project maintainer.**

Beargrease is designed to support **experimentation and evolution**, but experimentation must begin from clarity. Foundational scripts set the baseline. They establish the protocols that make creative extensions possible—not by limiting creativity, but by providing a structure that creative work can rely upon.

In this system, **rigor is not the end of exploration—it is where meaningful exploration begins**.



[🔝 Back to Table of Contents](#table-of-contents)

---



# Non-Negotiable Requirements

The following expectations are not guidelines. They are mandatory requirements for all scripts in the Beargrease project.

## Logging

Beargrease scripts must treat all output as part of a formal diagnostic protocol. Logging is not incidental commentary—it is evidentiary. All log lines must be deliberate, timestamped, and structured to support traceability and postmortem analysis.

To that end, **direct output commands such as `echo`, `printf`, or `read -p` are strictly forbidden in main execution paths**. These primitives lack the contextual discipline required for reproducible system introspection. All output must instead route through the shared logging interface provided by `logging.sh`.

Approved logging functions include:

- `log_ts`: for visible, timestamped status messages
- `log_verbose`: for conditional detail gated by verbosity flags
- `log_block`: for multi-line instructional or evidentiary blocks
- `log_block_verbose`: for verbosity-gated blocks with internal indentation

All messages must be:

- **Timestamped**, so output can be traced to system events in time
- **Greppable**, enabling efficient failure and state triage
- **Non-ambiguous**, avoiding generic strings like “done” or “error” without context

Logs must reflect both the action taken and its significance within the diagnostic narrative. Where applicable, they must point to follow-up actions, file paths, or container references.

------

**Example: Valid Logging Patterns**

```
log_ts "🔍 Checking validator container status"

if [[ "$RUNNING" == false ]]; then
    log_ts "❌ Validator container not found"
    log_block <<EOF
💡 NEXT STEPS:
  1. Confirm that the container was started successfully:
     docker ps -a | grep solana-test-validator
  2. Retry startup script:
     scripts/start-validator.sh
EOF
    exit 42
fi

log_verbose "Validator container is present. ID: $CONTAINER_ID"
```



[🔝 Back to Table of Contents](#table-of-contents)

---



## Failure Handling

Failure is not an aberration; it is a valid and expected part of any test orchestration lifecycle. Therefore, it must be handled with clarity and precision.

Beargrease scripts must never fail silently. Any nonzero exit must be preceded by an explanatory log statement that describes what failed, why it matters, and what to do next.

Each such failure must include a clearly delimited `NEXT STEPS` block that lists actionable recovery instructions. This is a core tenet of Beargrease script design: **failures must teach**.

**Incorrect:**

```
exit 1
```

**Correct:**

```
if [[ $WAIT_EXIT -ne 0 ]]; then
  log_ts "❌ Health check failed with exit code: $WAIT_EXIT"
  log_block <<EOF
💡 NEXT STEPS:
  1. Examine validator logs for error details:
       docker logs solana-test-validator
  2. Retry after confirming the container is running and healthy.
EOF
  exit 54
fi
```

All nonzero exits must correspond to an enumerated and documented exit code reference block.

Each failure must be regarded as a communicable state. The user must never be left in a position of guessing what failed or how to proceed. All `exit` calls must have accompanying rationale and structured guidance.



[🔝 Back to Table of Contents](#table-of-contents)

---



## Exit Codes

Every nonzero exit must be traceable—not only to a cause, but to a **declared, documented meaning**.

It is unacceptable to:

- Use `exit 1` without explanation
- Reuse codes inconsistently across scripts
- Omit an `Exit Code Reference` section in top-level comments

Every exit must be:

- Declared in a top-level comment block
- Emitted intentionally with appropriate logging and `NEXT STEPS`

**Exit Code Reference:**

```
# Exit Code Reference:
#  42 - Missing or unreadable configuration file
#  54 - Validator health check failure
```

**Usage in script:**

```
if [[ ! -f "$CONFIG_FILE" ]]; then
    log_ts "❌ Missing configuration file: $CONFIG_FILE"
    log_block <<EOF
💡 NEXT STEPS:
  1. Confirm that the path is correct.
  2. Ensure the file exists and has proper permissions.
EOF
    exit 42
fi
```



[🔝 Back to Table of Contents](#table-of-contents)

---



## **Environment Awareness**

Scripts must detect their execution environment—CI or local—and log it clearly at runtime. No script may assume its context; it must verify and disclose it explicitly.

Scripts that alter environment state (e.g., removing containers, deleting volumes) must:

- **Detect CI context and apply guardrails**
   Destructive actions **must be gated** in CI unless explicitly allowed and documented.
- **Emit diagnostic evidence before and after**
   This includes `docker ps`, `docker volume ls`, or file listings to show the visible effect of the operation.
- **Log refusal explicitly when blocked in CI**
   If an action is blocked in CI, the script must state why and exit with a documented code.

------

**Example: Volume Cleanup Guard with Evidence**

```
if [[ "$CI" == true ]]; then
    log_ts "⛔ Refusing to remove local validator volumes in CI environment"
    log_block <<EOF
💡 NEXT STEPS:
  1. Run this script locally to perform full volume cleanup.
  2. If volume cleanup is needed in CI, seek explicit approval and document it.
EOF
    exit 91
fi

log_ts "🧹 Cleaning up stale validator volumes (local mode)"
log_block <<EOF
🧾 Before:
$(docker volume ls | grep solana-test-validator || echo "(no volumes found)")
EOF

docker volume rm placebo_solana-test-validator-data 2>/dev/null || true

log_block <<EOF
🧾 After:
$(docker volume ls | grep solana-test-validator || echo "(no volumes remaining)")
EOF
```



[🔝 Back to Table of Contents](#table-of-contents)

---



## Shared Modules

All Beargrease scripts must utilize shared modules to ensure consistent behavior across the test harness. Re-implementing core functionality is prohibited.

- You **must** source the `logging.sh` and `parse_cli.sh` modules
  - `logging.sh` provides the required logging functions for structured, timestamped output
  - `parse_cli.sh` standardizes CLI flag parsing and sets the `VERBOSE` global flag

**Example:**

```
# At top of script
source "$(dirname "$0")/../lib/logging.sh"
source "$(dirname "$0")/../lib/parse_cli.sh"

parse_cli "$@"
```

These modules define the test harness's command-line and output protocol. All logging output must pass through the provided functions, and all CLI flag behavior must be parsed using the shared logic. This guarantees predictability across tools and scripts, avoids duplicated logic, and enforces consistency in UX and diagnostics.



[🔝 Back to Table of Contents](#table-of-contents)

--



## Script Structure

Beargrease scripts must follow a clear and uniform structure, ensuring consistency, readability, and traceability. The required order is:

1. Shebang (`#!/usr/bin/env bash`)
2. Strict mode (`set -euo pipefail`)
3. Header block with:
   - Title and purpose
   - License
   - Maintainer
   - Source URL (if published)
   - Exit Code Reference
4. Shared module sourcing
5. CLI flag parsing
6. CI guard (if applicable)
7. Initialization
8. Constant and path setup
9. Dependency check
10. Core procedure
11. Completion

Any script that violates these requirements is noncompliant and will be rejected.



[🔝 Back to Table of Contents](#table-of-contents)

------



# The 10 Required Structural Sections

All Beargrease scripts **must include the following 10 sections in this exact order**. Each section must begin with a full-width boxed header in title case (not necessarily uppercase):

> 🔒 Section omission, reordering, or merging is not permitted. Embedding these sections within unrelated logic blocks is non-compliant.

## 1. Shebang and Safety Settings

```
#!/usr/bin/env bash
set -euo pipefail
```

Every Beargrease script must begin with a strict and portable invocation of the Bash interpreter, followed immediately by the activation of **fail-fast safety settings**. This section is **not optional**, and its omission renders the script structurally invalid.

------

#### Breakdown

- `#!/usr/bin/env bash`
   This line invokes the Bash interpreter using the user’s `PATH`, ensuring portability across UNIX-like environments. It avoids hardcoding a platform-specific path such as `/bin/bash`, which may not be valid on all systems (e.g., NixOS, macOS with Homebrew).
- `set -euo pipefail`
   This compound directive is a **non-negotiable contract** for execution integrity:
  - `-e`: Exit immediately if any command returns a nonzero status.
  - `-u`: Treat unset variables as an error.
  - `-o pipefail`: Ensure that a failure in any part of a pipeline propagates and causes the pipeline to fail.

Together, these settings transform the shell from a loose command processor into a **deterministic, auditable execution environment**. Without them, silent failures, undetected typos, and swallowed errors can render even a correct-looking script epistemically invalid.

------

#### Purpose

This section establishes the **foundational execution discipline** upon which all subsequent logic relies. It protects against:

- Undeclared variables introducing non-determinism
- Partially failing pipelines generating misleading output
- Command errors propagating silently through conditionals or loops

It ensures that all failures are **fail-fast**—caught immediately, logged explicitly, and never masked.

> In Beargrease, a script must fail clearly and early, or not at all.

------

#### Placement

The shebang and safety settings must appear **as the first non-comment lines** in the file, preceding all headers, module sourcing, or logic. This guarantees that even early-stage diagnostics, such as script header parsing or CI guard detection, occur under full safety constraints.

------

**Valid Example (from `run-tests.sh`):**

```
#!/usr/bin/env bash
set -euo pipefail

# ----------------------------------------------------------------------
# 🐻 run-tests.sh - Beargrease Test Runner (Local and CI Mode)
# ----------------------------------------------------------------------
```

This satisfies all requirements:

- Uses an environment-resolved shebang
- Enables strict mode
- Appears at the top of the script, before any logic or headers

------

#### Prohibited Patterns

```
#!/bin/bash
```

> ❌ Non-portable. May break in sandboxed or non-standard environments.

```
# Missing `set -euo pipefail`
```

> ❌ Script may silently ignore failures, unset variables, or broken pipelines—resulting in indeterminate behavior.

------

#### Rationale

This section is not syntactic boilerplate—it is **execution epistemology**. It defines the rules of the game before any moves are made. In a test harness built on rigor, reproducibility, and traceability, such rules must be clear, universal, and inviolable.

A Beargrease script that does not begin with a strict, portable invocation is not a Beargrease script. It is an unsafe hypothesis.



[🔝 Back to Table of Contents](#table-of-contents)

------



## 2. Script Header Block

Every Beargrease script must begin with a **structured, full-width header block** that declares its identity, purpose, constraints, authorship, licensing, and behavioral contract. This header is not a comment—it is a **semantic preamble** that serves as the script’s public declaration of intent.

It communicates to both human readers and automated tools the script’s:

- Operational scope
- Authorship and version lineage
- Required arguments and available flags
- Enumerated exit codes and their meanings
- Environmental constraints (e.g., local-only, CI-safe)

> A script that lacks a complete header block cannot be audited, versioned, or safely reused—and is therefore noncompliant.

------

#### Required Format

The header must be boxed using full-width `# ----------------------------------------------------------------------` lines and must follow this order:

```
# ----------------------------------------------------------------------
# 🐻 script-name.sh - One-line summary
# ----------------------------------------------------------------------
# High-level description of the script’s purpose and environment constraints.
#
# Maintainer: Cabrillo Labs, Ltd. 2025
# License: MIT
# Source: https://github.com/rgmelvin/beargrease-by-cabrillo
# Version: vX.Y.Z (YYYY-MM-DD)
# ----------------------------------------------------------------------
#
# Exit Code Reference:
#   0    - Success
#   31   - Missing dependency (docker, etc.)
#   35   - Shutdown failure (example)
# ----------------------------------------------------------------------
#
# Usage:
#   scripts/script-name.sh [--verbose] [--help] [flags...]
#
# Options:
#   --verbose           Enables detailed diagnostic output.
#   --help              Displays this help message and exits.
#   --non-interactive   Skips prompts (if supported).
# ----------------------------------------------------------------------
```

------

#### Header Components

1. **Title Line**
   - Includes the script name and a concise description of its role.
   - Emoji identifiers (`🐻`, `🧹`, `🚀`) are encouraged to reinforce functional classification and improve visual scanning across scripts.
2. **Description Block**
   - One or two lines that explain the purpose and execution context.
   - Must mention local-only restrictions or CI compatibility if relevant.
3. **Metadata Fields**
   - **Maintainer:** Required. Attribution must include the organization and year.
   - **License:** Default is MIT unless otherwise specified.
   - **Source:** GitHub URL for traceability.
   - **Version:** Semantic version plus date of last meaningful revision.
4. **Exit Code Reference**
   - Exhaustive list of all exit codes used within the script.
   - Each code must be described in a single line.
   - Exit codes **must not overlap** in meaning across scripts.
5. **Usage Summary**
   - Canonical invocation form, including path and flags.
   - Reflects what a user would type to invoke the script from the project root.
6. **Options**
   - Lists all supported CLI flags.
   - Describes behavior for each, including whether flags are optional or mutually exclusive.
   - If the script uses `parse_cli.sh`, this section must match the parser’s configuration exactly.

------

**Valid Example (from `shutdown-validator.sh`):**

```
# ----------------------------------------------------------------------
# 🐻 shutdown-validator.sh - Beargrease Validator Shutdown Script
# ----------------------------------------------------------------------
# Gracefully shuts down the Solana validator container and cleans up ledger
# and lingering volumes. Provides rigorous evidentiary proof for both
# positive and negative results, and actionable next steps.
#
# ❗ LOCAL-ONLY script. Exits immediately in CI environments.
#
# Maintainer: Cabrillo Labs, Ltd. 2025
# License: MIT
# Source: https://github.com/rgmelvin/beargrease-by-cabrillo
# Version: v1.0.0 (2025-06-23)
# ----------------------------------------------------------------------
#
# Exit Code Reference:
#   0    - Success
#   31   - Missing dependency (docker)
#   35   - Docker compose down failure
# ----------------------------------------------------------------------
#
# Usage:
#   scripts/shutdown-validator.sh [--verbose]
#
# Options:
#   --verbose           Enables detailed diagnostic output.
# ----------------------------------------------------------------------
```

This header:

- Provides a precise and complete description of purpose
- Documents constraints (“LOCAL-ONLY”)
- Links to its authoritative source of truth
- Enumerates exit codes used in the script body
- Presents a canonical usage form with real flags

------

#### Prohibited Patterns

```
# shutdown.sh
# Takes down the container
```

> ❌ Lacks structure, metadata, and actionable detail. Impossible to audit or version.

```
# No header block at all
```

> ❌ Silent scripts are epistemically defective. They may run—but they are not Beargrease-compliant.

```
# exit codes scattered in logic, undocumented
```

> ❌ All exit codes must be declared here. Runtime-only discovery is unacceptable.

------

#### Rationale

A header is not ornamental—it is **operational infrastructure**. It provides the stable surface against which user expectations, system behaviors, and future revisions are aligned. It is the script’s *contractual self-description*, and without it, no execution is justifiable, regardless of outcome.

In Beargrease, a script that lacks a complete and structured header **has no identity**, and therefore cannot be trusted.



[🔝 Back to Table of Contents](#table-of-contents)

---



## 3. Beargrease Shared Module Sourcing

```
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../shared/logging.sh"
source "$SCRIPT_DIR/../shared/parse_cli.sh"
```

All Beargrease scripts must **source shared modules** for logging and CLI flag parsing immediately after defining `SCRIPT_DIR`. These modules enforce consistent behavior, formatting, and diagnostics across the entire harness. They are not optional: they constitute the shared semantic foundation of all Beargrease scripts.

> No Beargrease script is permitted to implement its own logging, flag parsing, or path resolution logic.

------

#### Required Modules

- `logging.sh`
   Provides all approved output functions: `log_ts`, `log_verbose`, `log_block`, etc.
- `parse_cli.sh`
   Handles parsing of command-line flags (`--verbose`, `--help`, etc.) and sets global variables such as `VERBOSE`.

These modules ensure that every script:

- Emits timestamped and structured logs
- Honors verbosity flags consistently
- Responds predictably to CLI flags and user error
- Can be understood and audited without internal guesswork

------

#### Path Resolution: `SCRIPT_DIR`

Every script must resolve its absolute directory path at runtime using:

```
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
```

This construct ensures that all sourced modules and referenced resources (e.g., configs, Docker files) are resolved **relative to the script itself**, regardless of where the script is invoked from.

> **Hardcoded or relative paths without `SCRIPT_DIR` are prohibited.** Scripts must never assume the caller’s working directory.

------

#### Valid Example (from `run-tests.sh`):

```
# ----------------------------------------------------------------------
# 📦 Beargrease Shared Module Sourcing
# ----------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../shared/logging.sh"
source "$SCRIPT_DIR/../shared/parse_cli.sh"
```

This block satisfies all requirements:

- Resolves the script directory deterministically
- Sources both required shared modules
- Prepares the script for reliable logging and argument handling

------

#### Prohibited Patterns

```
source ../shared/logging.sh
```

> ❌ This is context-sensitive and will fail if the script is called from a different directory.

```
# No sourcing; defines its own log_ts() inline
```

> ❌ Reinventing logging functions violates Beargrease's structural contract and breaks cross-script predictability.

```
SCRIPT_DIR=$(dirname "$0")
```

> ❌ This yields a relative path and can break if the script is called through a symlink or from a different directory.

------

#### Rationale

Shared module sourcing is **the first act of convergence** in a Beargrease script: it binds the script to the standard behavior model, enables instrumentation, and disables improvisation.

These modules do not just prevent redundancy—they are part of the **test protocol's epistemological scaffold**. They encode the contract of structured output and predictable behavior, and no script may proceed without them.

In Beargrease, all certainty begins with `SCRIPT_DIR`.



[🔝 Back to Table of Contents](#table-of-contents)

---



## 4. CLI Flags Parsing

```
parse_standard_cli_flags "$@"
set -- "${ARGS[@]}"
```

All Beargrease scripts must parse command-line arguments using the **shared flag parser** defined in `parse_cli.sh`. This parser enforces consistency, validates user input, and produces meaningful diagnostics. It is the **only** allowed mechanism for handling CLI flags in Beargrease.

------

#### Required Invocation

Every script that accepts CLI flags must call:

1. `parse_standard_cli_flags "$@"`
    Parses the full set of known flags and captures any positional arguments.
2. `set -- "${ARGS[@]}"`
    Restores cleaned and validated positional arguments into `$@` for later use in the script body.

This pattern must appear immediately after shared module sourcing and before any logic that relies on argument state.

------

#### Supported Flags

At a minimum, all Beargrease scripts must support:

- `--verbose`: Enables detailed logging
- `--help`: Displays usage and exits

Scripts may define additional flags (e.g., `--non-interactive`) if needed, but they **must be declared** in the header block and **validated** through `parse_cli.sh`. Unknown flags must cause the script to exit with a structured usage message and exit code `2`.

------

**Valid Example (from `run-tests.sh`):**

```
parse_standard_cli_flags "$@"
set -- "${ARGS[@]}"

if [[ "$HELP" == true ]]; then
  log_block <<EOF
Usage: scripts/run-tests.sh [--verbose] [--help]
Runs the full Beargrease test sequence against a local validator.

Flags:
  --verbose   Enable diagnostic output
  --help      Show this message and exit
EOF
  exit 2
fi
```

This example:

- Delegates flag parsing to the shared module
- Restores positional arguments cleanly
- Honors `--help` with explanatory output
- Terminates with a meaningful usage error code

------

#### Prohibited Patterns

```
while getopts ":hv" opt; do
  case $opt in
    h) echo "Help";;
    v) VERBOSE=true;;
  esac
done
```

> ❌ `getopts` is cryptic, does not support long flags, lacks positional argument support, and cannot emit structured errors.

```
while [[ $# -gt 0 ]]; do
  case "$1" in
    --verbose) VERBOSE=true ;;
    --help) HELP=true ;;
    *) echo "Unknown flag";;
  esac
  shift
done
```

> ❌ Ad hoc parsing fails to validate unknown flags, creates silent logic errors, and requires every script to reinvent control flow.

```
shift $((OPTIND - 1))
```

> ❌ Manual argument shifting is fragile, especially in mixed flag/positional contexts. It obscures behavior and breaks auditability.

------

#### Rationale

Flag parsing in Beargrease is not a trivial concern. It is a **core interface contract** between the script and the user. A consistent parsing layer ensures:

- Predictable help output
- Reliable verbosity behavior
- Clear failure modes on incorrect usage

By centralizing this logic in `parse_cli.sh`, Beargrease scripts remain simple, uniform, and auditable.

> CLI parsing is not a place for cleverness. It is a place for clarity.

The user should never have to guess what a flag does—or why an unknown argument failed.



[🔝 Back to Table of Contents](#table-of-contents)

---



## 5. CI Guard (if applicable)

```
if [[ "${CI:-}" == "true" ]]; then
  log_ts "🏃‍♂️ Skipping shutdown-validator.sh in CI environment."
  exit 0
fi
```

Any Beargrease script that alters **system state**—such as filesystem contents, Docker containers, or persistent volumes—**must include an explicit CI guard** unless such behavior is formally permitted and documented in the header block.

The CI guard is not a conditional convenience. It is a **categorical boundary** that distinguishes human-invoked operations from machine-executed automation. Its presence ensures that destructive or irreversible commands are never executed in CI unless explicitly allowed.

------

#### Required Pattern

The correct CI detection idiom is:

```
[[ "${CI:-}" == "true" ]]
```

This guards against unbound variables while allowing the detection of `CI=true` in GitHub Actions and other standard CI systems.

If CI context is detected, the script must:

1. Emit a visible log line via `log_ts` describing the action being skipped
2. Exit with `exit 0` to indicate intentional early termination
3. Skip **all downstream state-altering logic**

------

**Valid Example (from `shutdown-validator.sh`):**

```
# ----------------------------------------------------------------------
# ❗ LOCAL-ONLY script. Exits immediately in CI environments.
# ----------------------------------------------------------------------

if [[ "${CI:-}" == "true" ]]; then
  log_ts "🏃‍♂️ Skipping shutdown-validator.sh in CI environment."
  exit 0
fi
```

This satisfies all requirements:

- CI context is checked before any system-modifying logic
- A clear log line communicates the reason for exit
- No downstream operations are executed

------

#### CI Guard Omission

If a script is **intentionally CI-safe**, and does not perform any state mutation, the CI guard may be omitted. In this case, the script header **must include** an explicit comment stating:

```
# ✅ CI-safe: This script performs no destructive operations
```

This communicates that omission was intentional—not accidental.

------

#### Prohibited Patterns

```
# Missing CI guard in script that removes volumes
```

> ❌ Destructive behavior in CI without protection is strictly forbidden.

```
if [[ "$CI" == "true" ]]; then echo "Skipping" && exit; fi
```

> ❌ No logging, unclear intent, and unguarded use of unbound variable `$CI`.

------

#### Rationale

The CI guard is a **behavioral firewall**. It ensures that operations intended for local, human-controlled environments are not executed by automated systems without full review and understanding.

Beargrease must be safe to run in CI by default. This section makes that safety **explicit, visible, and enforceable**.



[🔝 Back to Table of Contents](#table-of-contents)

---



## 6. Initialization

```
log_ts "🐻 [shutdown-validator.sh] Starting Beargrease Validator Shutdown Script"
```

Every Beargrease script must open execution with a **timestamped initialization log** that announces the script’s identity and purpose. This log is the epistemic entry point of the script—it is where the narrative begins.

The initialization message must:

- Use `log_ts` for visibility and timestamping
- Include the script name in square brackets (`[script-name.sh]`)
- State the script’s primary function in natural language

------

#### Optional Verbose Diagnostics

Additional environment details may be logged via `log_verbose`, including:

```
log_verbose "SCRIPT_DIR resolved to: $SCRIPT_DIR"
log_verbose "CI mode: ${CI:-false}"
log_verbose "Target container: $CONTAINER_NAME"
```

These lines aid debugging and provide contextual grounding early in the execution trace. They are especially useful in CI, parallel test runs, or environments where assumptions about state or path may not hold.

------

**Valid Example (from `shutdown-validator.sh`):**

```
log_ts "🐻 [shutdown-validator.sh] Starting Beargrease Validator Shutdown Script"
log_verbose "SCRIPT_DIR resolved to: $SCRIPT_DIR"
log_verbose "CI mode: ${CI:-false}"
log_verbose "Target container: $CONTAINER_NAME"
```

------

#### Placement

Initialization must occur:

- After the CI guard (if present)
- Before any procedure or conditional logic
- Before any use of external paths, containers, or variables

------

#### Prohibited Patterns

```
# Script begins performing actions with no log output
```

> ❌ Ambiguous start state. Cannot determine what script is or what it is doing.

```
echo "Starting..."
```

> ❌ Direct `echo` usage violates structured logging requirements and lacks timestamps.

------

#### Rationale

Initialization is the **intent declaration**. It allows the reader, the user, and the test harness to know **what is about to happen**, from whom, and why.

In Beargrease, a script that does not introduce itself **cannot be trusted to complete responsibly**.



[🔝 Back to Table of Contents](#table-of-contents)

---



## 7. Constants and Path Setup

```
COMPOSE_FILE="$SCRIPT_DIR/../docker/docker-compose.yml"
CONTAINER_NAME="solana-test-validator"
```

All Beargrease scripts must define operational constants and file paths **explicitly**, near the beginning of execution. These values must be **named, immutable, and centralized** within a dedicated section immediately following Initialization.

Constants serve as the declarative interface between **procedure** and **configuration**. By isolating these values from logic, we create a surface for introspection, validation, and—when necessary—override.

#### Required Properties

- Constants must be declared as variables in **uppercase with underscores** (e.g., `LEDGER_DIR`, `CONTAINER_NAME`).
- Paths must be resolved **relative to `SCRIPT_DIR`**, never hardcoded from the root or current directory.
- Script logic must **refer only to these variables**, never reintroducing literal strings midstream.

> **Hardcoded paths or magic strings outside this section are noncompliant.**

#### Purpose

This section serves both machine and human readers:

- To the shell: it creates a stable namespace of known values
- To the maintainer: it localizes all operational parameters for review or modification
- To the user: it ensures traceable behavior and avoids logic that “knows too much” about the system

------

**Valid Example (from `shutdown-validator.sh`):**

```
# ----------------------------------------------------------------------
# 📍 Constants and Paths
# ----------------------------------------------------------------------

LEDGER_DIR="$SCRIPT_DIR/../.ledger"
COMPOSE_FILE="$SCRIPT_DIR/../docker/docker-compose.yml"
CONTAINER_NAME="solana-test-validator"
```

These declarations:

- Use fully qualified relative paths resolved from `SCRIPT_DIR`
- Isolate key values that may be reused or printed in later logic
- Are declared **after logging has begun**, but **before dependencies are invoked**

Each constant must be logged (preferably under `log_verbose`) **before first use**, unless its effect is independently observable in logs or system output.

------

**Prohibited Patterns:**

```
docker volume rm placebo_solana-test-validator-data
```

> ❌ This embeds a literal container name that should have been defined as `CONTAINER_NAME`.

```
rm -rf ../.ledger
```

> ❌ This bypasses `LEDGER_DIR` and obscures intent and traceability.

------

**Why This Matters:**

Constants are not just syntactic conveniences—they are **contractual surfaces**. They encode the assumptions under which the script operates and must be visible to both code reviewers and automated tools.

A Beargrease script that buries its constants inside logic is not merely disorganized—it is untrustworthy. Every script must declare its constants visibly, early, and in a manner that resists both drift and duplication.



[🔝 Back to Table of Contents](#table-of-contents)

---



## 8. Dependency Check

```
MISSING_DEPS=()
for cmd in docker grep jq; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    MISSING_DEPS+=("$cmd")
  fi
done

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
  log_ts "❌ Missing dependencies: ${MISSING_DEPS[*]}"
  log_block <<EOF
💡 NEXT STEPS:
  1. Install all missing tools:
     ${MISSING_DEPS[*]}
  2. Re-run this script.
EOF
  exit 31
fi
```

Dependency checks are a formal precondition to all Beargrease script execution. A script **must not assume the presence** of required executables, even if they are ubiquitous on developer systems. Instead, it must **detect, enumerate, and report** its runtime dependencies with full diagnostic clarity.

This is not a formality—it is a **pre-execution epistemic gate**. Any failure to meet environmental prerequisites must be logged, explained, and exited from cleanly and intentionally.

#### Required Characteristics

- All dependencies must be listed explicitly in the `for` loop (e.g., `docker`, `grep`, `jq`)
- Discovery must be performed using `command -v`, which is POSIX-compliant and portable
- Failures must:
  - Be collected into a structured array (`MISSING_DEPS`)
  - Emit a clear `log_ts` failure message
  - Include a `log_block` with `NEXT STEPS` installation guidance
  - Exit with code `31`, which is reserved for dependency failure

------

**Valid Example (from `cleanup-validator-volumes.sh`):**

```
MISSING_DEPS=()
for cmd in docker grep du; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    MISSING_DEPS+=("$cmd")
  fi
done

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
  log_ts "❌ Missing required tools: ${MISSING_DEPS[*]}"
  log_block <<EOF
💡 NEXT STEPS:
  1. Install the missing utilities listed above.
  2. Re-run this script after verifying installation:
     command -v ${MISSING_DEPS[0]}
EOF
  exit 31
fi
```

This block is:

- Predictable and consistent across all Beargrease scripts
- Greppable in CI or logs for dependency failure triage
- Self-remediating via the `NEXT STEPS` block
- Epistemically complete: it explains what failed, why it matters, and how to resolve it

------

**Prohibited Patterns:**

```
docker ps >/dev/null 2>&1 || {
  echo "Docker is not installed"
  exit 1
}
```

> ❌ This fails silently unless docker is missing, does not detect other dependencies, emits no structured logs, uses `echo`, and exits with a generic and undocumented code.

```
command -v docker >/dev/null || exit 1
```

> ❌ Bare exit with no logging, no user guidance, and no declared exit rationale.

------

**Rationale:**

Beargrease scripts are meant to be **deployable in unconfigured environments**. This includes first-run onboarding, continuous integration nodes, and educational contexts. A missing dependency is not an error—it is a **knowable precondition** that must be surfaced, diagnosed, and resolved with precision.

A proper dependency check is the script's handshake with its environment. Without it, execution proceeds on uncertain ground.9. Script Procedure Steps

Each script must contain clearly divided logic blocks for each major step. These may include:

- Validator shutdown
- Volume cleanup
- File or container detection
- Health checks

Each step **must**:

- Begin with a boxed comment header
- Use `log_ts` or `log_block` before and after actions
- Include `NEXT STEPS` guidance on any failure
- Print `docker` or `ls` output under `log_verbose` to prove action occurred
- Exit with a specific code documented in the script header



[🔝 Back to Table of Contents](#table-of-contents)

------



## 9. Script Procedure Steps

Each Beargrease script must implement its core logic as a **series of clearly divided, auditable procedural blocks**. These steps form the heart of the script’s execution flow—and must be both visible to the reader and introspectable in logs.

> These are not just commands. They are **narrative phases** in a system orchestration protocol.

Every procedural step must:

1. Begin with a **boxed section header** (e.g., `# ----------------------------------------------------------------------`)
2. Use `log_ts` or `log_block` to state **what is about to occur** and **why**
3. Include `NEXT STEPS` guidance and a documented `exit` code on failure
4. Log **system output** under `log_verbose` to confirm action outcomes
5. Operate **only on declared constants**, never on magic strings

------

#### Required Structure for Each Step

- **Intent Declaration:**
   Use `log_ts` to announce the action.
- **Action Execution:**
   Execute the operation (e.g., container check, volume deletion).
- **Diagnostic Capture:**
   Print system state before and/or after via `log_block` or `log_verbose`.
- **Failure Handling:**
   Catch any nonzero result, explain it, and exit with a documented code.

------

**Valid Example (from `cleanup-validator-volumes.sh`):**

```
# ----------------------------------------------------------------------
# 🧹 Remove Stale Validator Volumes
# ----------------------------------------------------------------------

log_ts "🧹 Cleaning up stale validator volumes (local mode)"

log_block <<EOF
🧾 Before:
$(docker volume ls | grep solana-test-validator || echo "(no volumes found)")
EOF

if ! docker volume rm "$VOLUME_NAME" >/dev/null 2>&1; then
  log_ts "❌ Failed to remove volume: $VOLUME_NAME"
  log_block <<EOF
💡 NEXT STEPS:
  1. Manually inspect the volume state:
     docker volume inspect $VOLUME_NAME
  2. Try force-removal or volume pruning:
     docker volume rm -f $VOLUME_NAME
EOF
  exit 38
fi

log_block <<EOF
🧾 After:
$(docker volume ls | grep solana-test-validator || echo "(no volumes remaining)")
EOF
```

This block is fully compliant:

- Begins with a boxed comment header
- Uses `log_ts` to announce the operation
- Emits before-and-after diagnostics
- Catches and logs failures with recovery steps
- Exits using a specific, documented code

------

#### Additional Procedural Examples:

- **Validator Shutdown**
   `"Shutting down container: $CONTAINER_NAME"`
   Use `docker compose down` with success/failure logs and `exit 35` on error.
- **File or Directory Cleanup**
   `"Removing stale ledger directory: $LEDGER_DIR"`
   Use `rm -rf` only after diagnostic logs and conditional existence checks.
- **Health Checks**
   `"Waiting for validator to become healthy"`
   Use polling with timeouts, log intermediate state, and exit with `exit 54` on timeout.

------

#### Prohibited Patterns

```
docker volume rm some-name
```

> ❌ Undeclared volume name; no logging, no error capture.

```
rm -rf ../.ledger
```

> ❌ Magic path outside of constants section; no log or user guidance.

```
if ! do_thing; then exit 1; fi
```

> ❌ Bare exit with no explanation, no recovery instructions, no epistemic value.

------

#### Rationale

A procedural step is not just a command—it is an assertion of intent and an opportunity to demonstrate outcome. In Beargrease, every action must be auditable: the reader must see **what happened**, the user must see **what to do next**, and the logs must contain **evidence** of both.

Each step is a self-contained **epistemic unit**: a claim, an attempt, a proof.



[🔝 Back to Table of Contents](#table-of-contents)

---



## 10. Completion

The **Completion** phase of any script is a vital finality marker. It ensures that every execution has been completed successfully or that actionable next steps are in place should the script encounter an issue. This section must provide:

- **Final confirmation** of successful execution
- **Exit codes** that reflect the script's outcome, helping users quickly identify success or failure
- **Clean state** assurance, particularly when dealing with Docker containers or volumes

The goal of **Completion** is to leave the system in a predictable and *documented* state after each operation, guiding the user clearly through any post-execution actions, if necessary.

------

#### Key Elements of the Completion Phase:

1. **Log Completion Status:**
    Use `log_ts` or `log_block` to confirm the script's execution state. This tells the user clearly if the operation was successful or failed and whether any further action is needed.
2. **Exit Code:**
    The final `exit` statement should give a status code that reflects the success or failure of the script. The exit codes should align with the general exit code reference at the beginning of the script.
3. **State Verification:**
    Always verify that any expected state changes have occurred, such as the removal of Docker containers, deletion of volumes, or restoration of directories. If any expected outcome is not met, provide **clear recovery steps**.
4. **Recovery & Cleanup Instructions:**
    If the script encounters errors that the user should manually address, provide clear, actionable instructions for those actions. **Be explicit** about the command steps or concepts necessary to restore system integrity.

------

#### Required Structure for Completion

- **Completion Log Message:**
   Use `log_ts` to announce that the script has finished its run. This ensures the user knows the script is done.
- **Exit Code Based on Result:**
   Conclude with a `exit 0` if successful. Otherwise, choose an exit code that matches the problem and provides guidance.

------

**Valid Example (from `shutdown-validator.sh`):**

```
# ----------------------------------------------------------------------
# 🐻 Completion of Beargrease Validator Shutdown
# ----------------------------------------------------------------------

log_ts "✅ Validator container shutdown complete."

# Verification step to ensure the container and volumes are no longer present
log_block <<EOF
🧾 Final state check:
$(docker ps -a || echo "(no containers found)")
$(docker volume ls || echo "(no volumes found)")
EOF

exit 0
```

Here, the script completes by confirming that the container has been shutdown and the volumes are no longer present. The state is explicitly logged, ensuring the user is confident about the system’s integrity. The exit code `0` marks a successful run.

------

#### Additional Considerations:

1. **For CI-Based Runs:**
    The completion logic in CI must ensure that any temporary containers or volumes created during the test or deployment are removed, even in case of failure. Use `docker-compose down -v` and check for lingering states post-run.
2. **Post-Script Verification:**
    If the script’s outcome includes external system effects (e.g., cleaning up volumes or shutting down services), the script should assert that these effects have occurred—log the system’s final state and confirm that no expected files or processes are still active.

------

#### Prohibited Patterns:

```
exit 1
```

> ❌ An abrupt exit with no message, no final state check, and no instructions on what to do next.

```
echo "Done."
exit 0
```

> ❌ No system verification, no logging, no action to confirm the expected state. Just an empty success message.

------

#### Rationale

The **Completion** phase is the final arbiter of a script’s intent. It is the moment where users gain confidence in the outcome of the script. Not only should it tell them whether the script worked, but it must give them actionable guidance for any next steps—whether for troubleshooting or simply confirming the process has been fully executed.🧰 Logging System Requirements

All Beargrease scripts must exclusively use the shared `logging.sh` functions:

- `log` – Standard output line
- `log_ts` – Timestamped log line
- `log_verbose` – Output only if `VERBOSE=true`
- `log_block` – Multiline output block
- `log_block_verbose` – Multiline output block (verbose only)

> 🔎 No `echo`, `printf`, or silent errors are allowed. Logging is diagnostic evidence.

**Any command that might fail must be accompanied by a `NEXT STEPS` block and logged output.**



[🔝 Back to Table of Contents](#table-of-contents)

------



# Additional Standards



## Shared Module Libraries

All Beargrease scripts must source the project’s **shared module libraries**—specifically `logging.sh` and `parse_cli.sh`—to ensure consistency, enforce correctness, and prevent duplication of core logic.

These modules define the **semantic layer** of all Beargrease shell interactions. They do not merely provide utility—they **encode the project’s behavioral contract**: how scripts log, how they parse arguments, and how they communicate with users.

> Reimplementation of functionality covered by these modules is explicitly forbidden. Scripts that bypass shared modules violate project structure and are noncompliant by definition.

------

#### Required Modules

- `logging.sh`
   Provides structured, timestamped, and verbosity-aware output functions.
   Functions include:
  - `log_ts`: timestamped single-line logs
  - `log_block`: multiline formatted output
  - `log_verbose`: gated output based on the `VERBOSE` flag
  - `log_block_verbose`: gated multiline logs
- `parse_cli.sh`
   Parses command-line arguments consistently across all scripts.
   Responsibilities include:
  - Flag validation and error reporting
  - Standard flag support: `--verbose`, `--help`, `--non-interactive`
  - Automatic population of the `$VERBOSE`, `$HELP`, and `$ARGS` variables

------

#### Sourcing Pattern

Modules must be sourced using the following structure:

```
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../shared/logging.sh"
source "$SCRIPT_DIR/../shared/parse_cli.sh"
```

This ensures:

- Absolute resolution of the script’s own directory
- Robust sourcing regardless of the user’s working directory
- Safe reuse in CI, nested calls, or symlinked environments

Scripts **must not** use relative paths without `SCRIPT_DIR`, and must **never hardcode absolute paths**.

------

#### Valid Example

```
# ----------------------------------------------------------------------
# 📦 Beargrease Shared Module Sourcing
# ----------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../shared/logging.sh"
source "$SCRIPT_DIR/../shared/parse_cli.sh"
```

This guarantees that the script conforms to the global logging and CLI behavior model.

------

#### Prohibited Patterns

```
source ../shared/logging.sh
```

> ❌ Relative path is context-sensitive and may break when invoked from a different directory.

```
log_ts() { echo "$@"; }  # redefines logging
```

> ❌ Reimplementation is not allowed. Scripts must never define their own logging or flag-handling logic.

```
SCRIPT_DIR=$(dirname "$0")
```

> ❌ Yields a relative path. Unsafe in symlinked or nested environments. Must use `cd` + `pwd`.

------

#### Rationale

The shared modules represent the **behavioral infrastructure** of Beargrease. They encapsulate not only reusable logic, but the **project’s design contract** for output structure, argument parsing, and interaction clarity.

No script may bypass this infrastructure. No improvisation is permitted. Consistency is not just a matter of readability—it is a requirement for **predictable behavior across dozens of scripts and environments**.



[🔝 Back to Table of Contents](#table-of-contents)

---



## Logging System Requirements

Logging in Beargrease is not commentary. It is **evidence**. Every emitted line must support the goals of **traceability, auditability, and reproducibility**. The output of a script is not incidental—it is the **primary diagnostic surface** by which users, maintainers, and automated systems determine what occurred, when, and why.

> In Beargrease, logs are formal instruments of record.
>  A script that fails to log with structure and purpose cannot be trusted to run.

------

### 🔒 Logging Must Be Structured

Beargrease scripts must never emit output using raw primitives such as `echo`, `printf`, or `read -p`. These tools lack timestamping, verbosity control, and structural enforcement. They produce output that is untraceable, ungreppable, and semantically ambiguous.

All logging **must route through** the shared `logging.sh` module, which defines the approved interface for structured output.

------

### ✅ Approved Logging Functions

| Function            | Purpose                                                    |
| ------------------- | ---------------------------------------------------------- |
| `log`               | Emit a standard log line (non-timestamped, always visible) |
| `log_ts`            | Emit a **timestamped** log line (always visible)           |
| `log_verbose`       | Emit a line **only if `VERBOSE=true`**                     |
| `log_block`         | Emit a **multiline** log block with preserved indentation  |
| `log_block_verbose` | Emit a gated multiline block **only if `VERBOSE=true`**    |



------

### 🧠 Logging Requirements

All log messages must be:

- **Timestamped** where appropriate (`log_ts`) to support chronological debugging
- **Greppable**, with meaningful and unique keywords or emoji for quick scanning
- **Non-ambiguous**, avoiding empty phrases like “done,” “error,” or “success” without context
- **Actionable**, especially when reporting failures—logs should point to files, commands, or recovery options
- **Truthful**, meaning they must describe what was actually attempted or observed, not what was assumed

------

### ✅ Valid Logging Pattern (from `run-tests.sh`)

```
log_ts "🔍 Checking validator container status"

if [[ "$RUNNING" == false ]]; then
    log_ts "❌ Validator container not found"
    log_block <<EOF
💡 NEXT STEPS:
  1. Confirm that the container was started successfully:
     docker ps -a | grep solana-test-validator
  2. Retry startup script:
     scripts/start-validator.sh
EOF
    exit 42
fi

log_verbose "Validator container is present. ID: $CONTAINER_ID"
```

This example:

- Uses visible, timestamped logs to document system state
- Surfaces failure in plain language
- Provides actionable recovery steps in a dedicated block
- Gated verbosity keeps diagnostic details available but unobtrusive

------

### ❌ Prohibited Logging Patterns

```
echo "Done"
```

> ❌ No timestamp, no context, not greppable, and may appear midstream with no indication of what was “done.”

```
printf "Error: %s\n" "$1"
exit 1
```

> ❌ Unstructured output with a generic exit. No indication of what failed, where to look, or what to do.

```
read -p "Continue? [y/N]"
```

> ❌ Direct prompts without verbosity or scripting support. Interactive input must be gated by `--non-interactive` and logged accordingly.

------

### 📄 Multiline Logging

Any time a script emits a list of steps, output from Docker or system commands, or a diagnostic trail, it must use `log_block` or `log_block_verbose`. This ensures formatting is preserved and that output is easily distinguishable from single-line status logs.

```
log_block <<EOF
🧾 Docker volumes before cleanup:
$(docker volume ls | grep solana-test-validator || echo "(none)")
EOF
```

------

### Rationale

Beargrease scripts are run in environments where **log output may be the only evidence** available during failure diagnosis. This includes CI runners, sandboxed containers, and collaborative testing scenarios.

Logs must carry epistemic weight. They must **show what is known**, **how it was determined**, and **what should happen next**.

In Beargrease, to log is not to “print”—it is to make a formal claim, backed by procedure and followed by consequence.



[🔝 Back to Table of Contents](#table-of-contents)

---



## Failure Handling

In Beargrease, **failure is not an anomaly**. It is a valid and expected part of orchestration—one that must be detected, logged, explained, and remediated with precision.

> A script that fails silently—or unclearly—**has already failed epistemically**, regardless of its exit code.

All errors must be surfaced as **explicit operational states**, accompanied by an explanation and a recovery pathway. Failures are not edge cases. They are **instructional events**.

------

### Required Failure Pattern

Every nonzero exit must:

1. Be preceded by a visible `log_ts` failure message
2. Include a structured `log_block` with `💡 NEXT STEPS`
3. Exit with a **documented exit code**
4. Halt execution immediately (no partial continuation)
5. Refer to actionable recovery techniques or observable system state

------

### Valid Example (from `wait-for-program.ts → wrapped shell usage`)

```
if [[ $WAIT_EXIT -ne 0 ]]; then
  log_ts "❌ Health check failed with exit code: $WAIT_EXIT"
  log_block <<EOF
💡 NEXT STEPS:
  1. Examine validator logs for error details:
       docker logs solana-test-validator
  2. Verify container is running and healthy.
  3. Re-run this script after addressing any errors.
EOF
  exit 54
fi
```

This pattern:

- Declares the failure and its immediate cause
- Assigns a unique, documented exit code
- Guides the user toward resolution
- Uses structured output for scanability and parsing

------

### Exit Code Contract

Every failure must correspond to a **predefined and uniquely meaningful exit code**, documented in the script’s header under `Exit Code Reference`.

**Prohibited:**

```
exit 1
```

> ❌ Bare exit with no explanation, no structured output, no recovery instructions.

**Required:**

```
exit 42  # (with corresponding reference: 42 - Missing config file)
```

------

### All Failures Must Teach

A failed script must leave the user knowing:

- **What failed** (system state or expectation)
- **Why it matters** (consequences of failure)
- **What to do next** (path to resolution)

Even in CI or non-interactive use, these logs form the basis for automated triage and human debugging. They must not assume context—they must **create** context.

------

### Prohibited Patterns

```
if [[ ! -f config.toml ]]; then
  echo "Missing config"
  exit 1
fi
```

> ❌ Unstructured, unexplained, and undocumented. No actionable output.

```
some_command || exit 1
```

> ❌ Silent failure. No log, no diagnosis, no learning.

```
echo "error"; exit 1
```

> ❌ Generic string. Not greppable. Not actionable. No location or cause.

------

### Failure States as Narrative Units

Every failure block must behave as a **self-contained instructional unit**. That is: a reader encountering the block in a CI log or terminal session must not need additional context to understand the problem and respond intelligently.

A well-structured failure output answers these questions:

1. What was attempted?
2. What was observed?
3. What is the likely cause?
4. What are the next actions?

------

### Rationale

Failure handling in Beargrease is not about damage control. It is about maintaining a **continuous epistemic thread**—a visible and truthful account of system state, right up to the point of failure.

A script that teaches nothing when it fails is not a script—it is a black box.
 In Beargrease, **every failure is an opportunity to clarify, instruct, and recover**.



[🔝 Back to Table of Contents](#table-of-contents)

---



## CLI Flag Parsing via `parse_cli.sh`

All Beargrease scripts must use the shared module `parse_cli.sh` to handle command-line flags. This module provides a centralized, auditable, and consistent interface for CLI behavior across the entire toolchain.

> CLI parsing is not an implementation detail.
>  It is the **user-facing contract** between script and operator.

By routing all flag logic through `parse_cli.sh`, we eliminate behavioral drift between scripts, reduce surface area for bugs, and ensure consistent handling of common flags like `--verbose` and `--help`.

------

### Required Invocation Pattern

Every script that supports CLI flags must include the following sequence **immediately after module sourcing**:

```
parse_standard_cli_flags "$@"
set -- "${ARGS[@]}"
```

This does two things:

1. Parses and validates all CLI flags (known or unknown)
2. Restores any positional arguments into `$@` for later use

The parser sets global variables (e.g., `VERBOSE=true`, `HELP=true`) and populates `ARGS` with the remaining positional arguments.

------

### Supported Flags

All Beargrease scripts must support the following standard flags unless explicitly exempt:

| Flag                | Behavior                                            |
| ------------------- | --------------------------------------------------- |
| `--verbose`         | Enables diagnostic logging via `log_verbose`        |
| `--help`            | Prints a usage message and exits with code `2`      |
| `--non-interactive` | Disables user prompts (if the script supports them) |



Additional flags may be added **only if** they are documented in the script header and handled using `parse_cli.sh`’s extension points.

------

### Valid Implementation Example

```
parse_standard_cli_flags "$@"
set -- "${ARGS[@]}"

if [[ "$HELP" == true ]]; then
  log_block <<EOF
Usage: scripts/cleanup-validator-volumes.sh [--verbose] [--help] [--non-interactive]

Flags:
  --verbose           Show detailed logs
  --help              Show this message and exit
  --non-interactive   Run without user prompts
EOF
  exit 2
fi
```

This ensures:

- All arguments are routed through the shared parser
- Help output matches the script’s declared behavior
- The exit code signals user-invoked usage (not system failure)

------

### Prohibited Patterns

```
while [[ $# -gt 0 ]]; do
  case "$1" in
    --verbose) VERBOSE=true ;;
    --help) echo "Help" ;;
    *) echo "Unknown flag: $1" ;;
  esac
  shift
done
```

> ❌ Ad hoc parsing fails to validate unknown arguments consistently.
>  Breaks shared behavior. Lacks usage formatting and verbosity control.

```
getopts ":hv" opt
```

> ❌ Does not support long flags (`--verbose`).
>  Non-descriptive. Difficult to maintain. Not greppable.

```
shift $((OPTIND - 1))
```

> ❌ Manual shifting introduces fragile and error-prone control flow.

------

### Rationale

In Beargrease, CLI parsing must be:

- **Consistent** across all scripts
- **Traceable** in logs and behavior
- **Defensive** against malformed or unsupported arguments

The purpose of `parse_cli.sh` is to **eliminate behavioral drift**, enforce safe defaults, and unify the UX surface across the test harness.

A user should not need to “learn each script” individually.
 Flags should behave the same, everywhere.



[🔝 Back to Table of Contents](#table-of-contents)

------



## Exit Codes (Expanded)

In Beargrease, **exit codes are not incidental**. They are part of the formal communication contract between a script and its environment—whether that environment is a developer, a CI pipeline, or a dependent script.

Every nonzero exit must be:

- **Deliberate** — no accidental fall-throughs
- **Documented** — described in the script’s `Exit Code Reference` block
- **Unique** — each code must correspond to exactly one meaning
- **Recoverable** — paired with explanatory logs and `NEXT STEPS`

Exit codes in Beargrease **are not just numeric outcomes**.
 They are formal declarations of failure state, intent, and recoverability.

------

### Exit Code Requirements

- **Zero (0)** must be used only for complete and successful execution
- All **nonzero codes** must:
  - Be declared in the script’s header block under `Exit Code Reference`
  - Appear nowhere else in the script unless emitted intentionally
  - Be accompanied by explanatory `log_ts` and `log_block` output before exit

------

### Valid Example

Script header:

```
# Exit Code Reference:
#   0    - Success
#   31   - Missing dependency (e.g., docker, grep)
#   54   - Validator health check failure
```

In script body:

```
if [[ ! -x "$(command -v docker)" ]]; then
  log_ts "❌ Missing required dependency: docker"
  log_block <<EOF
💡 NEXT STEPS:
  1. Install Docker using your package manager.
  2. Verify installation:
     command -v docker
EOF
  exit 31
fi
```

This structure:

- Logs the failure
- Gives actionable recovery steps
- Uses a meaningful, documented, greppable exit code

------

### Prohibited Patterns

```
exit 1
```

❌ Undocumented. Cannot be traced. No reason is given. Impossible to distinguish from other errors.

```
exit $SOME_EXIT_CODE
```

❌ Dynamically assigned codes are not permitted. All codes must be known, documented, and meaningful at author time.

```
# Exit code appears in script but not in header
```

❌ All emitted codes must be explicitly declared and explained in the script header.

------

### Standard Code Registry (Project-Wide)

Beargrease maintains a central code registry to avoid conflicts and ensure semantic clarity. Each code represents a **single failure state** that must be both human and machine readable.

| Code | Meaning                          |
| ---- | -------------------------------- |
| 0    | Success                          |
| 1    | General failure / missing arg    |
| 2    | CLI usage error                  |
| 11   | Invalid project structure        |
| 21   | Test runner failure              |
| 30   | Cleanup not needed               |
| 31   | Missing dependency               |
| 32   | CLI misusage                     |
| 33   | No validator running             |
| 34   | Log not detected                 |
| 35   | Validator shutdown failure       |
| 36   | Ledger directory cleanup failure |
| 37   | Docker volume listing failure    |
| 38   | Docker volume removal failure    |
| 40   | Wallet not injected in CI        |
| 50   | Invalid numeric input            |
| 51   | Airdrop failure                  |
| 52   | Docker compose down failed       |
| 53   | Docker compose up failed         |
| 54   | Validator health check failed    |



🔐 Exit codes **must not be reused** for multiple meanings.
 If your script requires a new failure mode, reserve a unique code.

------

### Rationale

Exit codes are often the only information available to a CI runner, log aggregator, or downstream script. In these contexts, they must carry meaning **on their own**—without relying on stdout messages, manual interpretation, or time-intensive debugging.

A script that exits with `1` tells you nothing.
 A script that exits with `38` tells you: *“Docker volume removal failed. You can grep for that. You know where to look. You know what to do.”*

That is Beargrease.



[🔝 Back to Table of Contents](#table-of-contents)

---



## Script Submission Requirements

No Beargrease script may be submitted for review, merged, or distributed unless it complies **fully and verifiably** with the structural, behavioral, and diagnostic standards defined in this document.

This section defines the **minimum, testable requirements** that must be met before any script is eligible for inclusion.

> In Beargrease, a script is not just a file—it is a **public protocol**.
>  Submission is not permitted unless the script teaches, explains, and behaves predictably.

------

### Requirements for Review Eligibility

To be accepted, a script must:

#### Structural Compliance

-  Include **all 10 required sections** in the **correct order**:
  1. Shebang and safety settings
  2. Script header block
  3. Shared module sourcing
  4. CLI flag parsing
  5. CI guard (if applicable)
  6. Initialization
  7. Constants and path setup
  8. Dependency check
  9. Script procedure steps
  10. Completion
-  Use **boxed section headers** in **Title Case** (not all caps)

#### Logging Compliance

-  Emit all output via approved `log_*` functions from `logging.sh`
-  Include timestamped `log_ts` messages at all critical transitions
-  Use `log_block` or `log_block_verbose` for multiline output
-  Avoid all `echo`, `printf`, or raw output primitives

#### CLI Compliance

-  Use `parse_cli.sh` for all flag handling
-  Support `--verbose`, `--help`, and `--non-interactive` where applicable
-  Restore positional arguments with `set -- "${ARGS[@]}"`

#### Failure Handling

-  Use `log_ts` to explain all nonzero exits
-  Include a structured `NEXT STEPS` block for each failure
-  Exit with a **specific, documented code** (never `exit 1`)
-  Halt execution immediately after failure (no fallthrough)

#### Exit Code Compliance

-  Document all emitted exit codes in the script header
-  Use only **predefined codes** from the Beargrease exit registry
-  Avoid reusing exit codes for multiple meanings

#### CI Safety

-  Include a CI guard if the script alters system state
-  Clearly state local-only or CI-safe status in the script header
-  Refuse destructive actions in CI unless explicitly required

#### Documentation

-  Include complete usage block in header (`Usage:` and `Options:`)
-  Explain all required arguments and flags
-  Use emoji classification if applicable (e.g., 🐻, 🧹, 🚀)

#### Re-runnability

-  Script must be **idempotent** where possible
-  Script must be safe to re-run without damage
-  No temporary or persistent artifacts may remain after failure unless logged

------

### Grounds for Immediate Rejection

- Missing or out-of-order structural sections
- Use of raw output or flag parsing primitives
- Undocumented or reused exit codes
- Silent failure or generic exit behavior
- Logic that mutates system state without CI guard
- Header block that omits version, license, or maintainer

------

### Final Review Protocol

Before submission, the contributor must:

1. Perform a self-audit against the above checklist
2. Attach the completed **Script Submission Checklist** to the pull request
3. Tag the review as `type:script-compliance`
4. Receive sign-off from the **project maintainer** (not just a collaborator)

------

### Rationale

Beargrease scripts are not exploratory shell fragments—they are **reference implementations of test orchestration logic**. Every script reflects not only individual authorship but the philosophical guarantees of the project.

Submission requirements are not bureaucracy. They are the gate through which **rigor becomes repeatability**.🔚 Summary

This document defines the technical and procedural standard for writing shell scripts in Beargrease. It exists to ensure that every script is maintainable, auditable, and safe to run.

**No deviation is permitted without documented exemption from the project maintainer.**



[🔝 Back to Table of Contents](#table-of-contents)

------



## Summary

This document defines the structural and procedural contract for all shell scripts in the Beargrease system. It establishes not just a common format, but a shared philosophy: that clarity, reproducibility, and traceability are the foundation for meaningful automation.

Each requirement here—whether it governs a shebang line, a logging function, or an exit code—serves the same purpose: to ensure that every script teaches what it does, why it does it, and how to respond when it fails.

These are not limitations. They are **enablers**. They make it possible for Beargrease to scale across environments, contributors, and projects without losing its identity or becoming brittle under pressure.

We do not enforce structure for its own sake. We do so because it allows experimentation to begin from a place of trust.

Rigor, in Beargrease, is not the enemy of creativity.
It is the precondition that allows it to mean something.

A Beargrease script is not just a means to an end. It is part of a **diagnostic narrative**—an instrument that must stand on its own as an explanation, not just an execution.

This document, then, is more than a checklist. It is a definition of what it means for a script to belong to this system. It offers a **starting point**—one that is firm enough to prevent chaos, but open enough to evolve.

Future scripts may introduce new procedures, new contexts, even new runtime environments. But they must do so from within this framework—or consciously extend it—never by escaping it.

Beargrease will grow. These standards are where that growth begins.

------

**Signed:**
 Cabrillo Labs, Ltd.
 *"No opaque wrappers. No hidden state. Just truth and trace."*



[🔝 Back to Table of Contents](#table-of-contents)

---



## Appendix A: Logging Function Reference

This appendix provides a concise, authoritative reference for the `log_*` functions defined in `logging.sh`, including their purpose, usage patterns, and expected behavior.

These functions are **mandatory** for all Beargrease scripts. No raw output primitives (`echo`, `printf`, `read`) may appear in a compliant script’s main logic.

------

### Function Index

| Function            | Description                                             |
| ------------------- | ------------------------------------------------------- |
| `log`               | Standard log line (non-timestamped, always visible)     |
| `log_ts`            | Timestamped status log (primary output function)        |
| `log_verbose`       | Verbose log line (visible only if `VERBOSE=true`)       |
| `log_block`         | Multiline block (always visible, preserves indentation) |
| `log_block_verbose` | Multiline block gated by verbosity                      |



------

### `log` — Basic Output (Non-Timestamped)

```
log "This is a basic log line"
```

- No timestamp, no prefix
- Always visible
- Suitable only for **non-critical side notes**, spacing, or diagnostics already gated by context
- **Use sparingly**

------

### `log_ts` — Timestamped Log Line

```
log_ts "🔍 Checking container health"
```

- Prepends a timestamp: `🕒 2025-07-12T10:33:19Z`
- Always visible
- Should be used for:
  - Section transitions
  - System state declarations
  - Errors and warnings
  - Anything you might later grep for in CI logs

> **This is the primary log function.** All major actions must be announced with `log_ts`.

------

### `log_verbose` — Conditional Diagnostic Line

```
log_verbose "SCRIPT_DIR resolved to: $SCRIPT_DIR"
```

- Only emits output if `VERBOSE=true`
- No timestamp
- Used for:
  - Showing resolved paths or values
  - Printing command execution details
  - Debugging variable contents
  - Internal checkpoints not needed in normal operation

------

### `log_block` — Multiline Visible Block

```
log_block <<EOF
🧾 Volumes before cleanup:
$(docker volume ls | grep solana-test-validator || echo "(none)")
EOF
```

- Always visible
- Maintains spacing, indentation, and command output
- Used for:
  - Displaying Docker or system output
  - Structured instructions (`NEXT STEPS`)
  - Visual grouping of logs
  - Narrative context in CI pipelines

> **Use for evidence, not commentary.** Blocks are part of the procedural narrative.

------

### `log_block_verbose` — Multiline Verbose Block

```
log_block_verbose <<EOF
🛠️ Full environment dump:
SCRIPT_DIR=$SCRIPT_DIR
CI=$CI
EOF
```

- Only emits if `VERBOSE=true`
- Ideal for showing:
  - Pre-flight environment state
  - Output from quiet commands (e.g., `ls`, `grep`)
  - Debug logs that are not part of normal operator flow

------

### Choosing the Right Log Function

| Situation                           | Function to Use                          |
| ----------------------------------- | ---------------------------------------- |
| Start of script                     | `log_ts`                                 |
| Describing an action or status      | `log_ts`                                 |
| Explaining a failure                | `log_ts` + `log_block` with `NEXT STEPS` |
| Printing Docker/system output       | `log_block`                              |
| Emitting command output (verbose)   | `log_block_verbose`                      |
| Describing environment (verbose)    | `log_verbose`                            |
| Inserting blank line / minor marker | `log`                                    |



------

### Best Practices

- Do not mix `log_ts` and `log` arbitrarily—be deliberate about what deserves timestamping
- Use emoji or consistent keywords to aid greppability (`✅`, `❌`, `🧹`, `💡`)
- Treat logs as part of the **diagnostic contract**—they are not decorative
- Avoid repetition; log once per event, with clarity
- Always show `NEXT STEPS` in a `log_block`—never in single lines

------

### What Not To Do

```
echo "Error"
```

> No timestamp, no structure, no context.

```
printf "Volumes: %s\n" "$(docker volume ls)"
```

> Unstructured output. No gating. Not formatted. Not traceable.



[🔝 Back to Table of Contents](#table-of-contents)

---



## Appendix B: Canonical Exit Code Registry

This appendix defines the authoritative list of exit codes used throughout the Beargrease test harness. These codes form a **semantic interface** between scripts, users, CI pipelines, and dependent tools. They must be treated not as incidental integers, but as **typed diagnostic signals**.

> Every nonzero exit in Beargrease must correspond to exactly one code in this registry, and that code must describe a **specific, auditable failure state**.

This list is normative. It may be expanded by the project maintainer, but exit codes may **never** be reused for multiple failure modes. Authors are responsible for consulting this registry before introducing new codes.

------

### Exit Code Usage Rules

- **`0` is reserved exclusively for success.**
- All nonzero codes:
  - Must appear in the `Exit Code Reference` of the script that emits them
  - Must be logged with `log_ts` and paired with a `NEXT STEPS` block
  - Must terminate the script immediately
- **Exit codes must never be dynamically assigned** or imported from external sources
- **Unused codes may not be “borrowed”** for approximate meanings

------

### 📑 Canonical Exit Code Table

| Code | Meaning                          | Use Case                                   |
| ---- | -------------------------------- | ------------------------------------------ |
| `0`  | Success                          | Script completed without error             |
| `1`  | General failure / missing arg    | Reserved fallback for misuse; avoid        |
| `2`  | CLI usage error                  | Triggered by invalid or unknown flags      |
| `11` | Invalid project structure        | Missing anchors, files, or test layout     |
| `21` | Test runner failure              | Mocha/Anchor tests exited with error       |
| `30` | Cleanup not needed               | Script ran, but no action was required     |
| `31` | Missing dependency               | Required tool (e.g. `docker`) not found    |
| `32` | CLI misusage                     | Script called with invalid positional args |
| `33` | No validator running             | Container not present at expected name     |
| `34` | Log not detected                 | Program log output missing after wait      |
| `35` | Validator shutdown failure       | `docker compose down` failed               |
| `36` | Ledger directory cleanup failure | `rm -rf` of ledger directory failed        |
| `37` | Docker volume listing failure    | `docker volume ls` returned error          |
| `38` | Docker volume removal failure    | `docker volume rm` failed                  |
| `40` | Wallet not injected in CI        | `.wallet/id.json` missing inside CI        |
| `50` | Invalid numeric input            | Script received malformed integer          |
| `51` | Airdrop failure                  | `solana airdrop` failed                    |
| `52` | Docker compose down failed       | Infrastructure shutdown failure            |
| `53` | Docker compose up failed         | Infrastructure startup failure             |
| `54` | Validator health check failed    | Failed readiness probe (e.g. `/health`)    |



------

### Reserved & Special Notes

- `1` may be used in **ad hoc tools**, but **not in Beargrease official scripts**. All first-class failures must be typed.
- `2` is the only acceptable usage error exit code. It should appear only when help output is triggered or user flags are invalid.
- Codes `90–99` are **reserved for future environment mode errors** (e.g., CI-only enforcement, test mode mismatch).
- All new codes must be requested and documented by filing a `type:standards` issue.

------

### Sample Reference Block (in script header)

```
# Exit Code Reference:
#   0    - Success
#   31   - Missing dependency (docker, grep, jq)
#   35   - Validator shutdown failure
```

This reference must appear before the first logic section of the script and must include **only** the codes that the script can emit.

------

### Prohibited Practices

```
exit 1  # (undocumented)
```

> ❌ No explanation, no documentation, no semantic value.

```
exit $SOME_RESULT
```

> ❌ Dynamic code injection is non-auditable and error-prone.

```
exit 33  # Used for both “not running” and “invalid structure”
```

> ❌ Exit codes must have a **one-to-one** correspondence with failure states.

------

### Rationale

Exit codes are not implementation trivia. They are part of the **contractual output surface** of every Beargrease script. When surfaced correctly, they allow:

- CI systems to fail fast and meaningfully
- Developers to grep logs and triage incidents
- Test harnesses to branch or retry based on specific failure causes

Used correctly, they make the difference between **automated clarity** and **manual guesswork**.



[🔝 Back to Table of Contents](#table-of-contents)

---



## Appendix C: CI Guard Examples and Behavior Matrix

The CI guard is one of the most essential and misunderstood constructs in Beargrease. It is not merely a conditional block. It is a **semantic boundary** that delineates automation from human-directed control, and defines whether a script is permitted to alter state when running in CI.

This appendix provides canonical examples of CI guard implementation, explains refusal logic, and offers a behavior matrix for interpreting script behavior across contexts.

------

### Purpose of the CI Guard

Beargrease scripts are often destructive: they remove Docker volumes, terminate containers, wipe ledger directories, and alter persistent test artifacts. These operations may be appropriate during local debugging—but are rarely safe in CI.

The CI guard prevents unintended consequences by enforcing this rule:

> If a script modifies system state, it must **refuse to run in CI unless explicitly authorized**.

------

### Canonical CI Guard Pattern

```
if [[ "${CI:-}" == "true" ]]; then
  log_ts "🏃‍♂️ Skipping shutdown-validator.sh in CI environment."
  exit 0
fi
```

This idiom is:

- **Safe** — it avoids unbound variable errors by using `:-`
- **Portable** — it works across GitHub Actions, GitLab CI, and other runners
- **Visible** — it logs a timestamped message before exiting
- **Final** — it halts the script before any mutation occurs

This check must occur **before** any file deletion, container stop, or other irreversible action.

------

### CI Guard Bypass (When Permitted)

There are rare cases when state mutation is required in CI—such as initializing a ledger in ephemeral test environments.

In such cases, the script must:

1. **Include explicit documentation** in the script header:

   ```
   # ✅ CI-safe: This script performs necessary setup for test environments
   ```

2. **Log and explain its behavior conditionally**:

   ```
   if [[ "${CI:-}" == "true" ]]; then
     log_ts "⚠️ Running in CI mode: mutating validator ledger directory"
     # proceed with caution
   fi
   ```

3. **Use runtime flags to require confirmation**, such as `--ci-unsafe` or `--force`, and log accordingly.

------

### Refusal Must Be Explicit

If a script is blocked from running in CI, it must:

- Use `log_ts` to announce the refusal
- Include a `log_block` with `NEXT STEPS` explaining what the user should do
- Exit with a **documented and unique** code (e.g., `exit 91` if assigned)

------

### Valid Refusal Example

```
if [[ "${CI:-}" == "true" ]]; then
  log_ts "⛔ Refusing to remove validator volumes in CI environment"
  log_block <<EOF
💡 NEXT STEPS:
  1. Run this script locally to perform cleanup safely.
  2. If CI cleanup is required, seek maintainer approval and document the case.
EOF
  exit 91
fi
```

This pattern prevents silent or partial execution in CI and explains how to proceed.

------

### Behavior Matrix

| Script Type                    | State Mutation? | CI Guard Required?     | CI Behavior                         |
| ------------------------------ | --------------- | ---------------------- | ----------------------------------- |
| `shutdown-validator.sh`        | Yes             | ✅ Yes                  | Exits immediately with log          |
| `cleanup-validator-volumes.sh` | Yes             | ✅ Yes                  | Refuses with instructions           |
| `run-tests.sh`                 | No (delegates)  | ❌ No                   | May proceed, logs CI state          |
| `check-deps.sh`                | No              | ❌ No                   | Always safe                         |
| `init-wallet.sh` (CI Mode)     | Yes             | ⚠️ Documented Exception | Logs CI behavior and requires flags |



------

### Prohibited Patterns

```
if [[ "$CI" == "true" ]]; then exit 0; fi
```

> ❌ Silent exit. No logging, no rationale, no traceability.

```
# CI guard is present but after Docker volume deletion
```

> ❌ Too late. Destructive operations may already have occurred.

```
# Script mutates `.ledger/` in CI without explanation
```

> ❌ Behavioral ambiguity. Must either refuse or declare CI safety explicitly.

------

### Rationale

CI is not a safe or neutral environment. It is a **high-speed, often contextless automation surface**. In such an environment, **ambiguity is dangerous**.

The CI guard is Beargrease’s formal mechanism for refusing unsafe behavior. It allows us to draw a boundary between “automated” and “deliberate,” and to do so **consistently, visibly, and safely**.



[🔝 Back to Table of Contents](#table-of-contents)

---



## Appendix D: Structural Template (Full Script Skeleton)

This appendix provides a complete, annotated scaffold for writing a new Beargrease-compliant shell script. It implements all **10 required sections**, in canonical order, with boxed headers, standardized logging, CI safeguards, and usage formatting.

This template is not an example—it is a **contractual outline**. All official scripts must follow this structure **exactly**, with no reordering, omission, or merging of structural sections.

> Copy this skeleton when writing a new script. Replace only the logic inside the boxed headers.
>  The surrounding structure must remain intact.

------

### Beargrease Script Skeleton

```
#!/usr/bin/env bash
set -euo pipefail

# ----------------------------------------------------------------------
# 🐻 script-name.sh - One-line summary of the script's function
# ----------------------------------------------------------------------
# Brief description of the script's purpose and execution constraints.
#
# Maintainer: Cabrillo Labs, Ltd. 2025
# License: MIT
# Source: https://github.com/rgmelvin/beargrease-by-cabrillo
# Version: v0.0.0 (YYYY-MM-DD)
# ----------------------------------------------------------------------
#
# Exit Code Reference:
#   0    - Success
#   31   - Missing dependency (docker, jq)
#   35   - Example failure (shutdown failed)
# ----------------------------------------------------------------------
#
# Usage:
#   scripts/script-name.sh [--verbose] [--help] [--non-interactive]
#
# Options:
#   --verbose           Enable detailed logs
#   --help              Show usage and exit
#   --non-interactive   Disable user prompts (if supported)
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# 📦 Beargrease Shared Module Sourcing
# ----------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../shared/logging.sh"
source "$SCRIPT_DIR/../shared/parse_cli.sh"

# ----------------------------------------------------------------------
# 🛠️ CLI Flag Parsing
# ----------------------------------------------------------------------

parse_standard_cli_flags "$@"
set -- "${ARGS[@]}"

if [[ "$HELP" == true ]]; then
  log_block <<EOF
Usage: scripts/script-name.sh [--verbose] [--help]

Options:
  --verbose           Enable detailed logs
  --help              Show this message and exit
  --non-interactive   Disable user prompts (if applicable)
EOF
  exit 2
fi

# ----------------------------------------------------------------------
# 🚧 CI Guard (if applicable)
# ----------------------------------------------------------------------

if [[ "${CI:-}" == "true" ]]; then
  log_ts "🏃‍♂️ Skipping script-name.sh in CI environment."
  exit 0
fi

# ----------------------------------------------------------------------
# 🐻 Initialization
# ----------------------------------------------------------------------

log_ts "🐻 [script-name.sh] Starting Beargrease XYZ Script"
log_verbose "SCRIPT_DIR resolved to: $SCRIPT_DIR"
log_verbose "CI mode: ${CI:-false}"

# ----------------------------------------------------------------------
# 📍 Constants and Paths
# ----------------------------------------------------------------------

CONTAINER_NAME="solana-test-validator"
LEDGER_DIR="$SCRIPT_DIR/../.ledger"
COMPOSE_FILE="$SCRIPT_DIR/../docker/docker-compose.yml"

# ----------------------------------------------------------------------
# ✅ Dependency Check
# ----------------------------------------------------------------------

MISSING_DEPS=()
for cmd in docker jq grep; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    MISSING_DEPS+=("$cmd")
  fi
done

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
  log_ts "❌ Missing required dependencies: ${MISSING_DEPS[*]}"
  log_block <<EOF
💡 NEXT STEPS:
  1. Install the missing tools listed above.
  2. Re-run this script once all dependencies are available.
EOF
  exit 31
fi

# ----------------------------------------------------------------------
# 🔁 Script Procedure Steps
# ----------------------------------------------------------------------

# Example Step: Attempt shutdown
log_ts "🛑 Shutting down container: $CONTAINER_NAME"

if ! docker compose -f "$COMPOSE_FILE" down >/dev/null 2>&1; then
  log_ts "❌ Failed to shut down validator container"
  log_block <<EOF
💡 NEXT STEPS:
  1. Manually inspect the container state:
     docker ps -a | grep $CONTAINER_NAME
  2. Re-run the shutdown script or remove the container manually.
EOF
  exit 35
fi

log_ts "✅ Validator container shut down successfully"

# ----------------------------------------------------------------------
# 🎉 Completion
# ----------------------------------------------------------------------

log ""
log_ts "✅ [script-name.sh] completed successfully."
exit 0
```

------

### Notes for Authors

- Replace all placeholder names (`script-name.sh`, `XYZ Script`) before submitting
- Exit codes used in the procedure steps must be listed in the header block
- All log messages should be meaningful, not decorative—logs are part of the protocol
- If the script has no CI guard, you must **explicitly document CI-safety** in the header

------

### Why This Template Exists

Beargrease does not tolerate structural drift. This template guarantees that:

- Reviewers never need to guess where to look for behavior
- Test harnesses can parse and analyze script metadata consistently
- Users can predict what a Beargrease script will do before running it

> Structure is not negotiable.
>  Clarity is not optional.
>  In Beargrease, **format is a form of trust**.



[🔝 Back to Table of Contents](#table-of-contents)

---



## Appendix E: Troubleshooting Submission Rejection Scenarios

This appendix presents **common reasons** why a Beargrease script may be rejected during review, along with explanations and corrections. It is not merely a fault list—it is a pedagogical guide. Every rejection is an opportunity to reinforce the underlying standards and ensure future compliance.

> **A rejected script is not a failed contribution.**
>  It is a signal that structure, clarity, or safety has not yet been fully established.

------

### Rejection Case Index

| Case ID | Rejection Reason                             | Resolution Summary                           |
| ------- | -------------------------------------------- | -------------------------------------------- |
| E01     | Missing required sections                    | Use full template; include all 10 sections   |
| E02     | Exit code undocumented or misused            | Add to header and log before use             |
| E03     | Direct `echo` or `printf` used               | Replace with `log`, `log_ts`, or `log_block` |
| E04     | CLI flags parsed manually                    | Use `parse_cli.sh`                           |
| E05     | CI guard omitted for destructive script      | Add guard or document CI-safe status         |
| E06     | Failure logged but no `NEXT STEPS` provided  | Add structured recovery instructions         |
| E07     | Ad hoc logic merged into structural sections | Restore proper boxed section boundaries      |
| E08     | Script not re-runnable or leaves residue     | Refactor for idempotency                     |



------

### E01 — Missing Required Sections

**Symptom:** Reviewer notes that key elements—such as dependency checks or completion logs—are missing or merged into unrelated logic.

**Explanation:** Beargrease scripts must implement all 10 required sections in the prescribed order, each with a visible boxed header.

**Fix:**

- Reconstruct the script using the template in [Appendix D](#appendix-d-structural-template-full-script-skeleton)
- Ensure that section headers are present, labeled in title case, and separated by full-width boxes

------

### E02 — Undocumented Exit Code

**Symptom:** Script exits with a specific nonzero code (e.g. `exit 42`), but this code is not listed in the script header.

**Explanation:** All exit codes must be listed in the `Exit Code Reference` block and explained before being emitted.

**Fix:**

- Add a comment block in the header:

  ```
  # Exit Code Reference:
  #   42 - Configuration file missing
  ```

- Confirm the exit code is unique within the Beargrease [Exit Code Registry](#appendix-b-canonical-exit-code-registry)

------

### E03 — Use of `echo`, `printf`, or Raw Output

**Symptom:** Logs are emitted with `echo` or `printf`, or prompts use `read` without gating.

**Explanation:** Beargrease scripts must route all output through the `log_*` functions in `logging.sh`. Raw output is unstructured and not compliant.

**Fix:**

- Replace with:

  ```
  log_ts "❌ Something went wrong"
  log_block <<EOF
  💡 NEXT STEPS:
    1. Do something.
    2. Try again.
  EOF
  ```

- For prompts, use `--non-interactive` gating and document behavior clearly

------

### E04 — Manual CLI Parsing

**Symptom:** Script uses `getopts` or `while [[ $# -gt 0 ]]` to process flags.

**Explanation:** Flag parsing must be delegated to `parse_cli.sh`. Manual parsing is non-standard and often error-prone.

**Fix:**

- Replace logic with:

  ```
  parse_standard_cli_flags "$@"
  set -- "${ARGS[@]}"
  ```

- Define behavior for `--help`, `--verbose`, and others within this shared system

------

### E05 — Missing or Improper CI Guard

**Symptom:** Script modifies containers, files, or volumes but runs in CI without restriction.

**Explanation:** Destructive actions in CI must be explicitly guarded, logged, and refused unless permitted and documented.

**Fix:**

- Add CI guard early in script:

  ```
  if [[ "${CI:-}" == "true" ]]; then
    log_ts "⛔ Refusing to run in CI environment"
    exit 0
  fi
  ```

- If permitted, declare CI safety in the header and log explicitly

------

### E06 — Failure Without `NEXT STEPS`

**Symptom:** Script logs an error condition but provides no guidance for what to do next.

**Explanation:** Every failure must teach. This includes structured recovery steps, observable commands, or escalation paths.

**Fix:**

- Add:

  ```
  log_block <<EOF
  💡 NEXT STEPS:
    1. Run docker ps -a to inspect.
    2. Re-run with --verbose for more details.
  EOF
  ```

------

### E07 — Structural Sections Merged or Reordered

**Symptom:** CLI flag parsing appears after core logic. Constants are declared mid-script. CI guard is embedded in procedural logic.

**Explanation:** Each section must appear in the required order, with its own boxed header. Logical merging is disallowed.

**Fix:**

- Reorganize using [Appendix D](#appendix-d-structural-template-full-script-skeleton)
- Maintain visual and functional separation of concerns

------

### E08 — Script Not Re-runnable or Leaves Artifacts

**Symptom:** Script leaves behind partial state or fails on second invocation due to missing conditionals.

**Explanation:** All Beargrease scripts must be re-runnable or safely idempotent. Cleanup actions must be safe even when redundant.

**Fix:**

- Add guards like:

  ```
  if [[ ! -d "$LEDGER_DIR" ]]; then
    log_ts "ℹ️ No ledger directory found; skipping removal"
    exit 30
  fi
  ```

- Use `docker volume rm || true` when failure is acceptable and non-fatal

------

### Final Advice

Each rejection scenario is not just a point of failure—it is a **teachable moment**. This appendix is designed not to penalize but to clarify, and to ensure that every contributor—whether author or reviewer—has a shared understanding of what excellence in Beargrease scripting looks like.



[🔝 Back to Table of Contents](#table-of-contents)

---



## Appendix F: Beargrease Submission Checklist (Author Use)

This checklist is a condensed, actionable version of the **Script Submission Requirements** section. It is intended for use by script authors during development and before submitting a pull request.

> This is not a courtesy form. It is a **compliance declaration**.
>  A submitted script must satisfy every item on this list unless explicitly exempted by the project maintainer.

Authors are encouraged to copy this checklist into PR descriptions, `.devnotes/`, or the script itself under a comment block labeled `# 🔎 Author Compliance Review`.

------

### Structural Compliance

-  All **10 required sections** are present and ordered correctly:
  -  Shebang and safety settings
  -  Script header block
  -  Shared module sourcing
  -  CLI flag parsing
  -  CI guard (if applicable)
  -  Initialization
  -  Constants and paths
  -  Dependency check
  -  Script procedure steps
  -  Completion
-  Boxed headers are used for all structural sections
-  Headers follow **Title Case**, not all caps

------

### Logging and Output

-  All output uses `log`, `log_ts`, `log_block`, or `log_verbose`
-  No `echo`, `printf`, or raw shell output appears in logic blocks
-  Timestamps (`log_ts`) are present at all major execution boundaries
-  `log_block` is used for all multiline messages and `NEXT STEPS`

------

### CLI Behavior

-  Flags are parsed using `parse_cli.sh`
-  Positional arguments restored via `set -- "${ARGS[@]}"`
-  `--verbose`, `--help`, and `--non-interactive` are supported (if applicable)
-  Usage message appears when `--help` is passed
-  Script exits with code `2` on usage error

------

### Exit Code Handling

-  All exit codes are listed in the script’s `Exit Code Reference` header
-  No use of `exit 1` unless declared and explained
-  All failures are logged with `log_ts` and followed by `NEXT STEPS`
-  All nonzero exits are final—no logic runs afterward

------

### CI Safety and Idempotency

-  CI guard is present for all scripts that delete, remove, or alter persistent state
-  If CI-safe, script header declares it explicitly
-  Re-running the script does not corrupt test state or leave unlogged artifacts
-  All cleanup logic is safe when repeated (e.g., `rm -rf || true`)

------

### Documentation and Submission

-  Script header includes:
  -  Maintainer
  -  License
  -  Source URL
  -  Version and date
  -  Complete usage and options block
-  Emoji or visual identifiers used in header (`🐻`, `🧹`, etc.)
-  `README.md` or index script updated if this tool introduces a new interface
-  PR includes a brief explanation of purpose and any deviations (if applicable)

------

### Final Acknowledgment

By submitting this script, I affirm that:

-  It adheres to the standards laid out in *Cabrillo Labs Shell Script Standards for Beargrease*
-  It does not introduce hidden state, non-deterministic behavior, or unclear failure modes
-  It is intended to teach, trace, and serve as a reliable part of the Beargrease harness



[🔝 Back to Table of Contents](#table-of-contents)

---



## Quick Reference Sheet

This one-page guide distills the full Beargrease shell script standard into a terse, implementation-focused format suitable for pinning in `docs/`, copying into `.devnotes/`, or printing for code review.

It is not a substitute for the full specification. It is a **field checklist** for authors and maintainers.

> 🛡️ **Every Beargrease script is a diagnostic instrument.**
>  It must be readable, re-runnable, and responsible at all times.

------

### Required Structure (All 10 Sections in Order)

1. `#!/usr/bin/env bash` and `set -euo pipefail`

2. Script header block with:

   - Summary line
   - Maintainer, license, source, version
   - `Exit Code Reference`
   - `Usage:` and `Options:` blocks

3. `SCRIPT_DIR` and module sourcing:

   ```
   source "$SCRIPT_DIR/../shared/logging.sh"
   source "$SCRIPT_DIR/../shared/parse_cli.sh"
   ```

4. CLI flag parsing:

   ```
   parse_standard_cli_flags "$@"
   set -- "${ARGS[@]}"
   ```

5. CI guard (if destructive):

   ```
   if [[ "${CI:-}" == "true" ]]; then log_ts "..."; exit 0; fi
   ```

6. Initialization:

   - `log_ts` with script name
   - `log_verbose` with CI state and key paths

7. Constants and paths (`CONTAINER_NAME`, `LEDGER_DIR`, etc.)

8. Dependency check with `command -v` loop and `exit 31`

9. Script procedure steps:

   - `log_ts` before each action
   - `log_block` for output
   - Failure handling with `NEXT STEPS` and specific `exit`

10. Completion:

    - `log_ts` confirmation
    - `exit 0`

------

### Logging Rules

| Purpose                 | Function            |
| ----------------------- | ------------------- |
| Timestamped status      | `log_ts`            |
| Conditional detail      | `log_verbose`       |
| Multiline visible block | `log_block`         |
| Multiline verbose block | `log_block_verbose` |
| Basic spacing or markup | `log` (rare)        |



❌ No `echo`, `printf`, `read -p`
 ✅ All logs must be structured, greppable, and traceable

------

### Exit Code Rules

- `0` = success
- Nonzero codes must:
  - Be documented in header
  - Match canonical registry
  - Be preceded by `log_ts` + `NEXT STEPS`
  - Exit immediately

Example:

```
exit 35  # Validator shutdown failure
```

------

### CI Guard

Required for any script that alters:

- Docker volumes
- Container state
- Local filesystem

Must appear **before** destructive logic. Must **log and exit** clearly.
 If safe in CI, declare so in header.

------

### Failure Handling

- No silent failures
- Every error must:
  - Log what failed and why
  - Include a `log_block` with recovery steps
  - Exit with a **specific code**

------

### Pre-Submission Checklist (Abbreviated)

-  All 10 structural sections present and ordered
-  All output uses `log_*` functions
-  CI guard present if needed
-  Exit codes documented and specific
-  Help output available via `--help`
-  Script safe to re-run
-  Header includes maintainer, license, usage

------

### 📎 Appendix Links

- [Appendix A: Logging Reference](#appendix-a-logging-function-reference)
- [Appendix B: Exit Code Registry](#appendix-b-canonical-exit-code-registry)
- [Appendix D: Full Script Skeleton](#appendix-d-structural-template-full-script-skeleton)
- [Appendix F: Submission Checklist](#appendix-f-✅-beargrease-submission-checklist-author-use)

------

This completes the Quick Reference Sheet.



[🔝 Back to Table of Contents](#table-of-contents)
