# rust-template
[![Docker workflow status](https://github.com/miguno/rust-template/actions/workflows/docker-image.yml/badge.svg)](https://github.com/miguno/rust-template/actions/workflows/docker-image.yml)
[![Rust workflow status](https://github.com/miguno/rust-template/actions/workflows/rust.yml/badge.svg)](https://github.com/miguno/rust-template/actions/workflows/rust.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Use [just](https://github.com/casey/just) to run the [justfile](justfile).

```shell
$ just
Available recipes:
    audit               # detect known vulnerabilities (requires https://github.com/rustsec/rustsec)
    build               # build debug executable
    check
    default             # show available targets
    docker-image-create # create a docker image (requires Docker)
    docker-image-size   # size of the docker image (requires Docker)
    docker-image-run    # run the docker image (requires Docker)
    format              # format source code
    install             # build and install the binary locally
    install-static      # build and install the static binary locally
    lint                # linters (requires https://github.com/rust-lang/rust-clippy)
    outdated            # detect outdated crates (requires https://github.com/kbknapp/cargo-outdated)
    pre-release
    release             # build release executable
    run                 # build and run
    system-info         # print system information such as OS and architecture
    test                # run tests (requires https://nexte.st/)
    test-vanilla        # run tests in vanilla mode (use when nextest is not installed)
    watch-test          # run check then tests when sources change (requires https://github.com/watchexec/cargo-watch)
```

Good luck, have fun!

## Features

* Simple app ([main.rs](src/main.rs)) with a simple unit test setup
  ([tests.rs](tests/tests.rs)).
* Create and run Docker images for your Rust app.
  The [Docker build](Dockerfile) uses a
  [multi-stage build setup](https://docs.docker.com/build/building/multi-stage/)
  to minimize the size of the generated Docker image, which is only 5MB.
* [GitHub Action workflows](https://github.com/miguno/rust-template/actions)
  for CI/CD support.
