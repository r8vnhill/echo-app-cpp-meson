# echo-app-cpp-meson

[![License: BSD-2-Clause](https://img.shields.io/badge/License-BSD--2--Clause-blue.svg)](./LICENSE)
[![Build System: Meson](https://img.shields.io/badge/build%20system-meson-ff6600?logo=meson&logoColor=white)](https://mesonbuild.com)
[![Language: C++](https://img.shields.io/badge/language-C++-blue?logo=c%2B%2B&logoColor=white)](https://isocpp.org/)
[![Lesson Available (Spanish)](https://img.shields.io/badge/lesson-español-yellowgreen)](https://dibs.pages.dev/docs/build-systems/init/meson/)

This repository accompanies the lesson [Creando un Proyecto Básico en C++ con Meson](https://dibs.pages.dev/docs/build-systems/init/meson/), part of the **DIBS** course (*Diseño e Implementación de Bibliotecas de Software*).

> 🧠 **Note:** The lesson is written in **Spanish**, but this repository and its source code are documented in **English** to make the content more accessible to an international audience.

## 🚀 What does this project demonstrate?

This is a minimal but well-structured example that shows how to:

- Create a basic **C++** project using the [Meson build system](https://mesonbuild.com).
- Set up a clean project structure with root-level and `src/` directory configurations.
- Automate the creation of essential project files using shell and PowerShell scripts.
- Build and run the project with **Meson**, **Ninja**, and **Clang**.
- Apply best practices for portable, modular, and maintainable software libraries.

## 📂 Project structure

```text
echo-app-cpp-meson/
├── meson.build
└── src/
    ├── meson.build
    └── main.cpp
```

Each `meson.build` file corresponds to its directory's role in the build process, enabling modular compilation as the project scales.

## 🛠️ Dependencies

To compile and run this project, you need:

- [Meson](https://mesonbuild.com)
- [Ninja](https://ninja-build.org)
- [Clang (LLVM)](https://clang.llvm.org) or another C++ compiler

The lesson includes helper scripts to install these tools automatically for Windows, macOS, and Debian/Ubuntu.

## 🧪 How to build and run

```bash
meson setup build
meson compile -C build
./build/src/main
```

Expected output:

```text
Nothing can happen till you swing the bat
```

## 📚 Related lesson

For a full walkthrough, check the companion lesson (in Spanish):

👉 [Creando un Proyecto Básico en C++ con Meson](https://dibs.pages.dev/docs/build-systems/init/meson/)

It covers:

- Installing Meson, Ninja, and Clang
- Creating a project structure
- Configuring `meson.build` files
- Automating boilerplate setup
- Reflections on software library maintainability

## 🤝 Code of Conduct

This project follows the [Contributor Covenant](https://www.contributor-covenant.org/) to foster a welcoming and inclusive environment. Please read [`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md) for details.

## ⚖️ License

This project is licensed under the [BSD 2-Clause License](./LICENSE).

You are free to use, modify, and distribute the code with minimal restrictions. See the license file for full terms.
