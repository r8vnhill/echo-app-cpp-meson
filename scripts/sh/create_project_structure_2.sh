#!/bin/sh
# -----------------------------------------------------------------------------
# File: create_project_structure_2.sh
# Initializes the standard directory and file structure for a modular C++
# project using Meson build system.
#
# This script creates the following files:
# - src/app/main.cpp
# - src/app/meson.build
# - src/core/echo.cpp
# - src/core/echo.hpp
# - src/core/meson.build
#
# For each file, it ensures the parent directory exists and creates an empty
# file if it doesn't already exist.
#
# Intended for use in teaching contexts (e.g., DIBS) or quick prototyping.
#
# Usage:
#   ./create_project_structure_2.sh
#
# Output:
#   📦 Creating project structure...
#   ✅ src/app/main.cpp
#   ✅ src/app/meson.build
#   ✅ src/core/echo.cpp
#   ✅ src/core/echo.hpp
#   ✅ src/core/meson.build
#   🟢 Project initialized successfully.
# -----------------------------------------------------------------------------

set -e  # Exit immediately if a command exits with a non-zero status

echo "📦 Creating project structure..."

for file in \
    src/app/main.cpp \
    src/app/meson.build \
    src/core/echo.cpp \
    src/core/echo.hpp \
    src/core/meson.build
do
    dir=$(dirname "$file")
    mkdir -p "$dir"
    touch "$file"
    echo "✅ $file"
done

echo "🟢 Project initialized successfully."
