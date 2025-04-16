#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# install_meson_dependencies
# -----------------------------------------------------------------------------
#
# Installs all required dependencies to build software using the Meson build
# system.
# Supports LLVM installation via either Xcode Command Line Tools or Homebrew,
# and installs `meson` and `ninja` via Homebrew.
#
# Supports quiet mode for suppressing output during installations.
#
# -----------------------------------------------------------------------------
# Usage:
#   install_meson_dependencies [xcode|brew] [quiet]
#
# Arguments:
#   $1: llvm_method – Required. Either 'xcode' (uses Xcode CLI) or 'brew' (Homebrew LLVM).
#   $2: quiet       – Optional. If set to 'quiet', suppresses output for all installs.
#
# -----------------------------------------------------------------------------
# Example:
#   install_meson_dependencies brew quiet
#   # => 📦 Installing llvm...
#   # => ✅ llvm installed successfully.
#   # => ✅ All Meson dependencies installed successfully.
#
# -----------------------------------------------------------------------------
# Dependencies:
#   - macOS with Homebrew installed
#   - A writable shell profile (e.g., .bashrc, .zshrc, or config.fish)
#
# Environment Config:
#   When LLVM is installed via Homebrew, the following environment variables
#   are appended to the shell profile (if not already present):
#     - PATH
#     - LDFLAGS
#     - CPPFLAGS
#
# Shells supported:
#   - bash
#   - zsh
#   - fish
# -----------------------------------------------------------------------------
install_meson_dependencies() {
    local llvm_method="$1"
    local quiet="$2"

    # ⏱ Waits for Xcode CLI installation to finish
    wait_for_xcode_cli() {
        echo "⏳ Waiting for installation to complete..."
        while ! xcode-select -p &>/dev/null; do
            sleep 5
        done
    }

    # 📦 Installs Xcode Command Line Tools
    install_xcode_cli() {
        local quiet="$1"

        echo "🧰 Checking for Xcode Command Line Tools..."
        if ! xcode-select -p &>/dev/null; then
            echo "📦 Installing Xcode Command Line Tools..."
            if [[ "$quiet" == "quiet" ]]; then
                xcode-select --install &>/dev/null
            else
                xcode-select --install
            fi
            wait_for_xcode_cli
            echo "✅ Xcode Command Line Tools installed successfully."
        else
            echo "✅ Xcode Command Line Tools are already installed."
        fi
    }

    # ➕ Appends a line to a file if not already present
    add_if_missing() {
        local file="$1"
        local line="$2"
        grep -Fxq "$line" "$file" || echo "$line" >> "$file"
    }

    # 🔧 Configures environment variables for LLVM based on the shell
    configure_llvm_env() {
        local shell_name file
        shell_name="$(basename "$SHELL")"
        echo "🔧 Configuring environment for: $shell_name"

        case "$shell_name" in
            bash) file="$HOME/.bashrc" ;;
            zsh)  file="$HOME/.zshrc" ;;
            fish)
                file="$HOME/.config/fish/config.fish"
                mkdir -p "$(dirname "$file")"
                touch "$file"
                ;;
            *)
                echo "❌ Unsupported shell: $shell_name"
                return 1
                ;;
        esac

        local env_lines=(
            "PATH=\"/opt/homebrew/opt/llvm/bin:\$PATH\""
            "LDFLAGS=\"-L/opt/homebrew/opt/llvm/lib\""
            "CPPFLAGS=\"-I/opt/homebrew/opt/llvm/include\""
        )

        for line in "${env_lines[@]}"; do
            if [[ "$shell_name" == "fish" ]]; then
                add_if_missing "$file" "set -x ${line//=/ }"
            else
                add_if_missing "$file" "export $line"
            fi
        done

        # Reload shell config
        if [[ "$shell_name" == "fish" ]]; then
            fish -c "source $file"
        else
            # shellcheck source=/dev/null
            source "$file"
        fi

        echo "✅ LLVM environment variables configured for $shell_name"
    }

    # 🍺 Installs any Homebrew package with optional quiet mode
    brew_install() {
        local package="$1"
        local quiet="$2"
        echo "📦 Installing $package..."
        if [[ "$quiet" == "quiet" ]]; then
            brew install "$package" &>/dev/null
        else
            brew install "$package"
        fi
        echo "✅ $package installed successfully."
    }

    # 🍺 Installs LLVM with Homebrew and configures the environment
    install_llvm_brew() {
        local quiet="$1"
        brew_install llvm "$quiet"
        configure_llvm_env
    }

    # 🚀 Main LLVM installation dispatcher
    install_llvm() {
        local method="$1"
        local quiet="$2"

        case "$method" in
            xcode) install_xcode_cli "$quiet" ;;
            brew)  install_llvm_brew "$quiet" ;;
            *)
                echo "❌ Unknown LLVM installation method: '$method'"
                echo "   Use: install_meson_dependencies xcode|brew [quiet]"
                return 1
                ;;
        esac
    }

    install_meson() { brew_install meson "$1"; }
    install_ninja() { brew_install ninja "$1"; }

    # ✅ Validate input and install all
    if [[ "$llvm_method" != "brew" && "$llvm_method" != "xcode" ]]; then
        echo "❌ Invalid LLVM installation method: '$llvm_method'"
        echo "   Use: install_meson_dependencies xcode|brew [quiet]"
        return 1
    fi

    echo "🚀 Installing dependencies for Meson using LLVM via $llvm_method..."

    install_llvm "$llvm_method" "$quiet" || return 1
    install_meson "$quiet" || return 1
    install_ninja "$quiet" || return 1

    echo "✅ All Meson dependencies installed successfully."
}