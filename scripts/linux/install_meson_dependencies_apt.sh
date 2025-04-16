#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# install_meson_dependencies
# -----------------------------------------------------------------------------
#
# Installs the required dependencies for building software with the Meson build
# system on Debian-based systems using `apt`.
#
# This function checks for the presence of `clang`, `meson`, and `ninja`, and
# installs any missing dependencies. It supports a `quiet` mode to suppress
# command output.
#
# -----------------------------------------------------------------------------
# Usage:
#   install_meson_dependencies [quiet]
#
# Arguments:
#   quiet  Optional. If set to 'quiet', suppresses output from commands.
#
# -----------------------------------------------------------------------------
# Behavior:
# - Runs `sudo apt update` before checking/installing dependencies.
# - Installs:
#     - Clang (via `clang`)
#     - Meson (via `meson`)
#     - Ninja (via `ninja-build`)
# - Skips installation if the corresponding command is already available.
#
# -----------------------------------------------------------------------------
# Example:
#   install_meson_dependencies
#   install_meson_dependencies quiet
#
# -----------------------------------------------------------------------------
install_meson_dependencies() {
    local quiet="$1"

    # 🚫 Silences output if quiet mode is enabled
    run() {
        if [[ "$quiet" == "quiet" ]]; then
            "$@" &>/dev/null
        else
            "$@"
        fi
    }

    # ✅ Installs a package if its command is missing
    install_if_missing() {
        local name="$1"     # Friendly name (for messages)
        local cmd="$2"      # Command to check
        local pkg="$3"      # Package to install

        echo "🔍 Checking for $name..."
        if command -v "$cmd" &>/dev/null; then
            echo "✅ $name is already installed."
        else
            echo "📦 Installing $name..."
            if run sudo apt install -y "$pkg"; then
                echo "✅ $name installed successfully."
            else
                echo "❌ Failed to install $name." >&2
                return 1
            fi
        fi
    }

    echo "🔄 Updating package list..."
    if ! run sudo apt update; then
        echo "❌ Failed to update package list." >&2
        return 1
    fi

    install_if_missing "Clang" "clang" "clang" || return 1
    install_if_missing "Meson" "meson" "meson" || return 1
    install_if_missing "Ninja" "ninja" "ninja-build" || return 1

    echo "✅ All Meson dependencies installed successfully."
}
