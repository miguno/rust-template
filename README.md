# rust-template
[![Docker workflow status](https://github.com/miguno/rust-template/actions/workflows/docker-image.yml/badge.svg)](https://github.com/miguno/rust-template/actions/workflows/docker-image.yml)
[![Rust workflow status](https://github.com/miguno/rust-template/actions/workflows/rust.yml/badge.svg)](https://github.com/miguno/rust-template/actions/workflows/rust.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Use [just](https://github.com/casey/just) to run the [justfile](justfile).

```
$ just
just -l
Available recipes:
    audit      # detect known vulnerabilities (requires https://github.com/rustsec/rustsec)
    build      # build debug executable
    default    # show available targets
    format     # format source code
    lint       # linters (requires https://github.com/rust-lang/rust-clippy)
    outdated   # detect outdated crates (requires https://github.com/kbknapp/cargo-outdated)
    release    # build release executable
    run        # build and run
    test       # run tests (requires https://nexte.st/)
    watch-test # run check then tests when sources change (requires https://github.com/watchexec/cargo-watch)
```

Good luck, have fun!
