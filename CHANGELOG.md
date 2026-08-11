# Changelog

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
