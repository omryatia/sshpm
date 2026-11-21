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

Or clone and install (auto-installs missing dependencies):

```bash
git clone https://github.com/omryatia/sshpm.git
cd sshpm
./install.sh
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

### SSH options (optional)

Force password auth (adds `IdentitiesOnly=yes`, `PubkeyAuthentication=no`, `PreferredAuthentications=password`) — useful on "Too many authentication failures":

```bash
sshpm add myserver --host 1.2.3.4 --user admin --password 'Pass!' --password-only
sshpm update myserver --password-only      # enable on existing profile
sshpm update myserver --no-password-only   # disable
sshpm connect --password-only myserver     # one-off, not saved

# Any custom ssh -o option (repeatable), saved in profile
sshpm update myserver -o ServerAliveInterval=30 -o Compression=yes
sshpm update myserver --clear-options
```

## How It Works

- Profiles stored in `~/.config/sshpm/config.json`
- Passwords encrypted via `pass` + GPG in `~/.password-store/servers/<profile>`
- Connects using `sshpass -e ssh` with password from `pass`
