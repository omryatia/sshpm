# Changelog

## [1.1.0] - 2026-11-21

### Added
- Optional per-profile ssh `-o` options (`-o/--ssh-option KEY=VALUE`, repeatable) on `add` and `update`
- `--password-only` flag to force password auth (`IdentitiesOnly=yes`, `PubkeyAuthentication=no`, `PreferredAuthentications=password`) on `add`, `update`, and one-off on `connect`
- `update --no-password-only` and `update --clear-options`
- `list` shows saved ssh options

## [1.0.0] - 2026-08-11

### Added
- SSH profile management (add, update, delete, list, show)
- Password storage via `pass` (GPG-encrypted)
- Connect to servers with `sshpm connect <profile>`
- Show stored passwords with `sshpm show-pass <profile>`
- Self-update command (`sshpm self-update`)
- Bash/zsh shell completion (`sshpm completion --install`)
- Support for Ubuntu/Debian (apt) and RHEL/CentOS/Fedora (dnf/yum)
- Install script with automatic dependency detection
- `--version` flag
