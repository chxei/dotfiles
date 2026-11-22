# Project Summary: DotFiles Setup

## Current State
- **Language:** Bash scripts (`setup.sh`, `apps.sh`, `scripts/*.sh`).
- **Functionality:** 
  - Backup/Restore of KDE Plasma and app configs.
  - Interactive TUI using `dialog` for app selection and system configuration.
  - Installation of packages via `dnf` (including COPR), `flatpak`, `pip`, and manual source builds.
  - System-level tweaks (sudoers, sysctl, systemd services).
- **Structure:** Modular scripts in `scripts/`, assets in `assets/`, and configuration files in `configs/`.

## Goals
1. **Short Term:** Modularize the current Bash scripts to improve maintainability and separate data from logic.
2. **Long Term:** Transition to a more robust configuration management system.
3. **Use Case:** Personal setup migration to a fresh install (single device focus).

## Strategy
### Phase 1: Short-Term (Modular Bash)
- **Data/Logic Separation:** Move package lists (dnf, flatpak, copr) into standalone text files or a clean JSON.
- **Refactoring:** Break down large scripts like `preSetup.sh` into smaller, task-oriented functions.
- **Improved TUI:** Clean up the `dialog` logic to be more dynamic based on the data files.

### Phase 2: Long-Term (Advanced Tools)
- **Re-evaluate Ansible/Chezmoi:** Determine if the overhead is worth it for a single-device setup.
- **Potential Transition:** Move to a declarative setup if idempotency and error handling become high priorities.
