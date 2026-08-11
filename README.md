# sshpm - SSH Profile Manager

Manage SSH connection profiles with passwords stored securely via [pass](https://www.passwordstore.org/) (GPG-encrypted).

## Supported Distros

- Ubuntu / Debian
- RHEL / CentOS / Fedora

## Quick Install

One-liner (latest release):

```bash
mkdir -p ~/bin && curl -sL https://github.com/omryatia/sshpm/releases/latest/download/sshpm -o ~/bin/sshpm && chmod +x ~/bin/sshpm
```

Or clone and use install script:

```bash
git clone https://github.com/omryatia/sshpm.git
cd sshpm

# Install sshpm to ~/bin (no deps)
./install.sh

# Install sshpm + system dependencies (pass, sshpass, gpg)
./install.sh --deps
```

## Prerequisites

You need `pass` initialized with a GPG key. See the docstring in `sshpm` for detailed setup steps, or:

```bash
gpg --full-generate-key
pass init "your-email@example.com"
```

## Usage

```bash
# Add a profile
sshpm add myserver --host 10.0.0.1 --user admin --port 22 --password 'MyPass!'

# Connect
sshpm connect myserver

# List all profiles
sshpm list

# Show profile details
sshpm show myserver

# Show stored password
sshpm show-pass myserver

# Update profile
sshpm update myserver --password 'NewPass!'

# Delete profile
sshpm delete myserver

# Install shell completion
sshpm completion --install
```

## How It Works

- Profiles stored in `~/.config/sshpm/config.json`
- Passwords encrypted via `pass` + GPG in `~/.password-store/servers/<profile>`
- Connects using `sshpass -e ssh` with password from `pass`
