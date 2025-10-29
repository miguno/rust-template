# rust-template

[![Rust workflow status](https://github.com/miguno/rust-template/actions/workflows/ci.yml/badge.svg)](https://github.com/miguno/rust-template/actions/workflows/ci.yml)
[![Valgrind workflow status](https://github.com/miguno/rust-template/actions/workflows/valgrind.yml/badge.svg)](https://github.com/miguno/rust-template/actions/workflows/valgrind.yml)
[![Docker workflow status](https://github.com/miguno/rust-template/actions/workflows/docker-image.yml/badge.svg)](https://github.com/miguno/rust-template/actions/workflows/docker-image.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Features

- Simple app ([main.rs](src/main.rs)) that uses a
  toy library ([lib.rs](src/lib.rs)), along with a simple unit test setup
  ([tests.rs](tests/tests.rs)).
- Create and run Docker images for your Rust app.
  The [Docker build](Dockerfile) uses a
  [multi-stage build setup](https://docs.docker.com/build/building/multi-stage/)
  to minimize the size of the generated Docker image, which is only 5MB.
- [GitHub Action workflows](https://github.com/miguno/rust-template/actions)
  for CI/CD support.

# Usage

Use [just](https://github.com/casey/just) to run the [justfile](justfile).

```shell
$ just
Available recipes:
    [development]
    asm *args=''                           # show Assembly, LLVM-IR, MIR and WASM for Rust code (requires https://github.com/pacak/cargo-show-asm)
    bloat-biggest-deps                     # list the biggest dependencies in the release build (requires https://github.com/RazrFalcon/cargo-bloat)
    bloat-biggest-functions                # list the biggest functions in the release build (requires https://github.com/RazrFalcon/cargo-bloat)
    build                                  # build debug executable
    build-static                           # build a static debug executable
    check                                  # analyze the current package and report errors, but don't build object files (faster than 'build')
    clean                                  # remove generated artifacts
    coverage                               # show test coverage (requires https://lib.rs/crates/cargo-llvm-cov)
    dependencies                           # show dependencies of this project
    deps                                   # alias for 'dependencies'
    docs                                   # generate the documentation of this project
    format                                 # format source code
    install                                # build and install the binary locally
    install-static                         # build and install the static binary locally
    license                                # Show license of dependencies (requires https://github.com/onur/cargo-license)
    lint                                   # linters (requires https://github.com/rust-lang/rust-clippy)
    outdated                               # detect outdated crates (requires https://github.com/kbknapp/cargo-outdated)
    pre-release                            # check, test, lint, miri
    profile-release                        # profile the release binary (requires https://github.com/mstange/samply, which uses profiler.firefox.com as UI)
    test                                   # run tests (requires https://nexte.st/)
    test-vanilla                           # run tests in vanilla mode (use when nextest is not installed)
    timings                                # generate report for compilation times
    version                                # show version of this project
    watch                                  # run build when sources change (requires https://github.com/watchexec/watchexec)
    watch-test                             # run check then tests when sources change (requires https://github.com/watchexec/cargo-watch)
    watch-test-bacon                       # run tests when sources change (requires https://github.com/Canop/bacon)

    [docker]
    docker-image-create $SHOW_PROGRESS="0" # create a docker image (requires Docker); run with SHOW_PROGRESS=1 to enable verbose output
    docker-image-run                       # run the docker image (requires Docker)
    docker-image-size                      # size of the docker image (requires Docker)

    [production]
    release                                # build release executable
    run                                    # build and run

    [project-agnostic]
    default                                # show available just recipes
    just-vars                              # evaluate and print all just variables
    system-info                            # print system information such as OS and architecture

    [security]
    audit                                  # detect known vulnerabilities (requires https://github.com/rustsec/rustsec)
    miri                                   # detect undefined behavior with miri (requires https://github.com/rust-lang/miri)
```

Good luck, have fun!
