# <img src="/home/rgmelvin/Projects/cabrillo/beargrease-by-cabrillo/docs/Images/BeargreaseIcon.png" alt="BeargreaseIcon" style="zoom:7%;" /> Beargrease Shell Script Linter

## **Overview**

The **Beargrease Linter** enforces the Cabrillo Labs Shell Script Protocol and Style Guide. It verifies structural, stylistic, and safety requirements for all scripts in the Beargrease ecosystem.

This tool ensures that every Beargrease script adheres to professional standards:

- **Clarity**
- **Consistency**
- **Safety**
- **Transparency**

------

## **Usage**

### **Run the Linter**

```
./linter/linter.sh <path-to-target-script>
```

### **Example**

```
./linter/linter.sh ./scripts/test-bad-script.sh
```

------

## **What It Checks**

| **Rule**                | **Description**                                           | **Status**    |
| ----------------------- | --------------------------------------------------------- | ------------- |
| `shebang.rule`          | Verifies correct shebang and strict mode                  | ✅ Implemented |
| `header-block.rule`     | Ensures full header block with required fields            | ✅ Implemented |
| `shared-sourcing.rule`  | Checks for `logging.sh` and `parse_cli.sh` sourcing       | ✅ Implemented |
| `cli-parsing.rule`      | Verifies CLI parsing pattern                              | 🚧 Placeholder |
| `constants.rule`        | Enforces global constants declaration                     | 🚧 Placeholder |
| `initialization.rule`   | Checks for script initialization sequence                 | 🚧 Placeholder |
| `procedure-steps.rule`  | Requires procedural step sections                         | 🚧 Placeholder |
| `ci-guard.rule`         | Checks for CI guard or CI-safe declaration                | ✅ Implemented |
| `dependency-check.rule` | Requires dependency check or explicit no-deps declaration | ✅ Implemented |
| `exit-codes.rule`       | Verifies all exit codes are documented                    | ✅ Implemented |
| `completion.rule`       | Requires final success log statement                      | ✅ Implemented |



------

## **Output Example**

A run against `test-bad-script.sh` will output structured error messages with:

- **Timestamps**
- **Clear icons**
- **NEXT STEPS guidance**

Example:

```
2025-07-14 15:01:42 ▶️ Running shebang.rule
2025-07-14 15:01:42 ❌ Missing or incorrect shebang line.
💡 NEXT STEPS:
  1. The first line of the script must be:
     #!/usr/bin/env bash
```

------

## **Exit Codes**

| Code | Meaning                               |
| ---- | ------------------------------------- |
| `0`  | Success                               |
| `81` | Missing target script argument        |
| `82` | Target script not found or unreadable |
| `83` | Linter rule failure                   |



------

## **Version**

`v0.1.0`
 MVP release of the Beargrease Shell Script Linter.

------

## **Roadmap**

- Implement placeholders in future versions
- Integrate with `placebo-pro` and advanced Beargrease modules

------

## **References**

- Cabrillo Labs Shell Script Protocol and Style Guide
- Beargrease Beginner's Guide

------

### **Maintainer**

Cabrillo Labs, Ltd.
 MIT License, 2025