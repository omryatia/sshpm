#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${HOME}/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

detect_pkg_manager() {
    if command -v apt-get &>/dev/null; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v yum &>/dev/null; then
        echo "yum"
    else
        echo "unknown"
    fi
}

install_deps() {
    local pkg_mgr
    pkg_mgr=$(detect_pkg_manager)

    echo "Detected package manager: ${pkg_mgr}"

    case "${pkg_mgr}" in
        apt)
            sudo apt update
            sudo apt install -y pass sshpass gpg
            ;;
        dnf)
            sudo dnf install -y pass sshpass gnupg2
            ;;
        yum)
            sudo yum install -y pass sshpass gnupg2
            ;;
        *)
            echo "Error: unsupported package manager. Install manually: pass, sshpass, gpg"
            exit 1
            ;;
    esac
}

install_sshpm() {
    mkdir -p "${INSTALL_DIR}"
    cp "${SCRIPT_DIR}/sshpm" "${INSTALL_DIR}/sshpm"
    chmod +x "${INSTALL_DIR}/sshpm"
    echo "Installed sshpm to ${INSTALL_DIR}/sshpm"
}

ensure_path() {
    if [[ ":${PATH}:" != *":${INSTALL_DIR}:"* ]]; then
        local shell_name
        shell_name=$(basename "${SHELL}")
        local rc_file="${HOME}/.bashrc"
        [[ "${shell_name}" == "zsh" ]] && rc_file="${HOME}/.zshrc"

        if ! grep -q 'export PATH="$HOME/bin:$PATH"' "${rc_file}" 2>/dev/null; then
            echo "" >> "${rc_file}"
            echo '# Added by sshpm installer' >> "${rc_file}"
            echo 'export PATH="$HOME/bin:$PATH"' >> "${rc_file}"
            echo "Added ~/bin to PATH in ${rc_file}"
            echo "Run: source ${rc_file}"
        fi
    fi
}

echo "=== sshpm installer ==="
echo ""

if [[ "${1:-}" == "--deps" ]]; then
    install_deps
    echo ""
fi

install_sshpm
ensure_path

echo ""
echo "Done. Run: sshpm --help"
