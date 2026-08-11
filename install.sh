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

check_and_install_deps() {
    local missing=()

    command -v pass &>/dev/null   || missing+=("pass")
    command -v sshpass &>/dev/null || missing+=("sshpass")
    command -v gpg &>/dev/null    || missing+=("gpg")

    if [[ ${#missing[@]} -eq 0 ]]; then
        echo "All dependencies found."
        return
    fi

    echo "Missing dependencies: ${missing[*]}"

    local pkg_mgr
    pkg_mgr=$(detect_pkg_manager)
    echo "Detected package manager: ${pkg_mgr}"

    local pkgs=()
    for dep in "${missing[@]}"; do
        case "${dep}" in
            gpg)
                if [[ "${pkg_mgr}" == "apt" ]]; then
                    pkgs+=("gpg")
                else
                    pkgs+=("gnupg2")
                fi
                ;;
            *)
                pkgs+=("${dep}")
                ;;
        esac
    done

    case "${pkg_mgr}" in
        apt)
            sudo apt update
            sudo apt install -y "${pkgs[@]}"
            ;;
        dnf)
            sudo dnf install -y "${pkgs[@]}"
            ;;
        yum)
            sudo yum install -y "${pkgs[@]}"
            ;;
        *)
            echo "Error: unsupported package manager. Install manually: ${missing[*]}"
            exit 1
            ;;
    esac

    echo "Dependencies installed."
}

setup_pass() {
    if [[ -f "${HOME}/.password-store/.gpg-id" ]]; then
        echo "pass already initialized."
        return
    fi

    echo ""
    echo "=== Setting up pass (password store) ==="

    local gpg_id
    gpg_id=$(gpg --list-keys --with-colons 2>/dev/null | awk -F: '/^uid/{print $10; exit}')

    if [[ -z "${gpg_id}" ]]; then
        echo "No GPG key found. Creating one..."
        echo "You will be asked for your name, email, and a passphrase."
        echo ""
        gpg --full-generate-key
        gpg_id=$(gpg --list-keys --with-colons 2>/dev/null | awk -F: '/^uid/{print $10; exit}')
    fi

    if [[ -z "${gpg_id}" ]]; then
        echo "Error: GPG key creation failed." >&2
        echo "Create one manually: gpg --full-generate-key" >&2
        echo "Then run: pass init \"your-email@example.com\"" >&2
        exit 1
    fi

    echo "Initializing pass with GPG ID: ${gpg_id}"
    pass init "${gpg_id}"
    echo "pass initialized."
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

check_and_install_deps
echo ""
setup_pass
echo ""
install_sshpm
ensure_path

echo ""
echo "Done. Run: sshpm --help"
