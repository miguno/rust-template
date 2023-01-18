# rust-template
[![Docker workflow status](https://github.com/miguno/rust-template/actions/workflows/docker-image.yml/badge.svg)](https://github.com/miguno/rust-template/actions/workflows/docker-image.yml)
[![Rust workflow status](https://github.com/miguno/rust-template/actions/workflows/rust.yml/badge.svg)](https://github.com/miguno/rust-template/actions/workflows/rust.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Use [just](https://github.com/casey/just) to run the [justfile](justfile).

```
$ just
Available recipes:
    audit        # detect known vulnerabilities (requires https://github.com/rustsec/rustsec)
    build        # build debug executable
    default      # show available targets
    docker-image # create a docker image (requires Docker)
    docker-run   # run the docker image (requires Docker)
    format       # format source code
    install      # install locally
    lint         # linters (requires https://github.com/rust-lang/rust-clippy)
    outdated     # detect outdated crates (requires https://github.com/kbknapp/cargo-outdated)
    release      # build release executable
    run          # build and run
    system-info  # print system information such as OS and architecture
    test         # run tests (requires https://nexte.st/)
    watch-test   # run check then tests when sources change (requires https://github.com/watchexec/cargo-watch)
```

Good luck, have fun!

## Features

* Simple app ([main.rs](src/main.rs)) with a simple unit test setup
  ([tests.rs](tests/tests.rs)).
* Create and run Docker images for your Rust app.
  The [Docker build](Dockerfile) uses a
  [multi-stage build setup](https://docs.docker.com/build/building/multi-stage/)
  to minimize the size of the generated Docker image, which is 5M.
* [GitHub Action workflows](https://github.com/miguno/rust-template/actions)
  for CI/CD support.
