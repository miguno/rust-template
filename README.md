# rust-template
[![Docker workflow status](https://github.com/miguno/rust-template/actions/workflows/docker-image.yml/badge.svg)](https://github.com/miguno/rust-template/actions/workflows/docker-image.yml)
[![Rust workflow status](https://github.com/miguno/rust-template/actions/workflows/rust.yml/badge.svg)](https://github.com/miguno/rust-template/actions/workflows/rust.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Features

* Simple app ([main.rs](src/main.rs)) that uses a
  toy library ([lib.rs](src/lib.rs)), along with a simple unit test setup
  ([tests.rs](tests/tests.rs)).
* Create and run Docker images for your Rust app.
  The [Docker build](Dockerfile) uses a
  [multi-stage build setup](https://docs.docker.com/build/building/multi-stage/)
  to minimize the size of the generated Docker image, which is only 5MB.
* [GitHub Action workflows](https://github.com/miguno/rust-template/actions)
  for CI/CD support.

# Usage

Use [just](https://github.com/casey/just) to run the [justfile](justfile).

```shell
$ just
Available recipes:
    asm *args=''      # show Assembly, LLVM-IR, MIR and WASM for Rust code (requires https://github.com/pacak/cargo-show-asm)
    audit             # detect known vulnerabilities (requires https://github.com/rustsec/rustsec)
    build             # build debug executable
    check             # analyze the current package and report errors, but don't build object files (faster than 'build')
    clean             # remove generated artifacts
    coverage          # show test coverage (requires https://lib.rs/crates/cargo-llvm-cov)
    default           # show available targets
    deps              # show dependencies of this project
    docker-image-create $SHOW_PROGRESS="0" # create a docker image (requires Docker); run with SHOW_PROGRESS=1 to enable verbose output
    docker-image-run  # run the docker image (requires Docker)
    docker-image-size # size of the docker image (requires Docker)
    docs              # generate the documentation of this project
    format            # format source code
    install           # build and install the binary locally
    install-static    # build and install the static binary locally
    just-vars         # evaluate and print all just variables
    license           # Show license of dependencies (requires https://github.com/onur/cargo-license)
    lint              # linters (requires https://github.com/rust-lang/rust-clippy)
    miri              # detect undefined behavior with miri (requires https://github.com/rust-lang/miri)
    outdated          # detect outdated crates (requires https://github.com/kbknapp/cargo-outdated)
    pre-release       # check, test, lint, miri
    profile-release   # profile the release binary (requires https://github.com/mstange/samply, which uses profiler.firefox.com as UI)
    release           # build release executable
    run               # build and run
    system-info       # print system information such as OS and architecture
    test              # run tests (requires https://nexte.st/)
    test-vanilla      # run tests in vanilla mode (use when nextest is not installed)
    version           # show version of this project
    watch-test        # run check then tests when sources change (requires https://github.com/watchexec/cargo-watch)
```

Good luck, have fun!

