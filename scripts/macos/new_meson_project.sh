#!/bin/bash

# ------------------------------------------------------------------------------
# new_meson_project
# ------------------------------------------------------------------------------
#
# Creates a new C++ project scaffold compatible with the Meson build system.
#
# This function sets up a directory structure with a root `meson.build` file,
# a `src/` folder containing its own `meson.build`, and one or more C++ source
# files.
# If no source files are provided, it defaults to creating `main.cpp`.
#
# ------------------------------------------------------------------------------
# Usage:
#   new_meson_project <project_name> [source_file1 source_file2 ...]
#
# Arguments:
#   project_name   The name of the project directory to create (required).
#   source_files   (Optional) One or more source file names to include
#                             (default: main.cpp).
#
# Returns:
#   The absolute path to the newly created project directory (written to stdout).
#
# Exit Codes:
#   0  Success
#   1  Missing project name or failure to create directory structure
#
# ------------------------------------------------------------------------------
# Example (The Hobbit themed):
#  $ new_meson_project Engine main.cpp engine.cpp player.cpp
#     Output:
#     🚀 Creating new Meson project: Engine
#     📁 Creating folders and Meson files...
#     📄 Created source file: main.cpp
#     📄 Created source file: engine.cpp
#     📄 Created source file: player.cpp
#     ✅ Meson project 'Engine' created successfully.
#     /full/path/to/Engine
#
# $ cd "$(new_meson_project Engine main.cpp engine.cpp player.cpp)"
# ------------------------------------------------------------------------------

new_meson_project() {
    local project_name="$1"
    shift
    local source_files=("$@")
    local default_files=("main.cpp")

    if [[ -z "$project_name" ]]; then
        echo "❌ Project name is required." >&2
        return 1
    fi

    # Use default source file if none provided
    if [[ ${#source_files[@]} -eq 0 ]]; then
        source_files=("${default_files[@]}")
    fi

    echo "🚀 Creating new Meson project: $project_name" >&2

    # Get absolute path
    local project_path
    if command -v realpath &>/dev/null; then
        project_path="$(realpath "$project_name")"
    else
        project_path="$PWD/$project_name"
    fi

    # Create base directory structure
    if ! mkdir -p "$project_path/src"; then
        echo "❌ Failed to create project structure." >&2
        return 1
    fi

    echo "📁 Creating folders and Meson files..." >&2
    : > "$project_path/meson.build"
    : > "$project_path/src/meson.build"

    for file in "${source_files[@]}"; do
        local file_path="$project_path/src/$file"
        if [[ ! -f "$file_path" ]]; then
            : > "$file_path"
            echo "📄 Created source file: $file" >&2
        else
            echo "⚠️ File already exists: $file" >&2
        fi
    done

    echo "✅ Meson project '$project_name' created successfully." >&2

    # Output path for chaining with cd
    echo "$project_path"
}
