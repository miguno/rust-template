# Load environment variables from `.env` file.
set dotenv-load

# Extracts the binary name from the settings `name = <...>` in the `[[bin]]`
# section of Cargo.toml
#
# Alternative command:
# `sed -n '/[[bin]]/,/name =/p' Cargo.toml | awk '/^name =/{gsub(/"/, "", $3); print $3}'`
binary := `sed -n '/[[bin]]/,/name =/p' Cargo.toml | awk '/^name =/{gsub(/"/, "", $3); print $3}'`

# Get version from Cargo.toml/Cargo.lock
#
# Alternative command:
# `cargo metadata --format-version=1 | jq '.packages[]|select(.name=="rust-template").version'`
version := `cargo pkgid | sed -rn s'/^.*#(.*)$/\1/p'`

project_dir := justfile_directory()

# show available just recipes
[group('project-agnostic')]
default:
    @just --list --justfile {{justfile()}}

# evaluate and print all just variables
[group('project-agnostic')]
just-vars:
    @just --evaluate

# print system information such as OS and architecture
[group('project-agnostic')]
system-info:
    @echo "architecture: {{arch()}}"
    @echo "os: {{os()}}"
    @echo "os family: {{os_family()}}"

# show Assembly, LLVM-IR, MIR and WASM for Rust code (requires https://github.com/pacak/cargo-show-asm)
[group('development')]
asm *args='':
    # Examples:
    # just asm --lib
    # just asm --lib 0
    # just asm --lib "rust_template::doubler"
    # just asm --bin rust-template-app 0
    cargo asm {{args}}

# detect known vulnerabilities (requires https://github.com/rustsec/rustsec)
[group('security')]
audit:
    cargo audit

# list the biggest functions in the release build (requires https://github.com/RazrFalcon/cargo-bloat)
[group('development')]
bloat-biggest-functions:
    cargo bloat --release -n 10

# list the biggest dependencies in the release build (requires https://github.com/RazrFalcon/cargo-bloat)
[group('development')]
bloat-biggest-deps:
    cargo bloat --release --crates

# build debug executable
[group('development')]
build: lint
    cargo build && echo "Executable at target/debug/{{binary}}"

# build a static debug executable
[group('development')]
build-static: lint
    RUSTFLAGS='-C target-feature=+crt-static' cargo build && echo "Executable at target/debug/{{binary}}"

# analyze the current package and report errors, but don't build object files (faster than 'build')
[group('development')]
check:
    cargo check

# remove generated artifacts
[group('development')]
clean:
    cargo clean

# show test coverage (requires https://lib.rs/crates/cargo-llvm-cov)
[group('development')]
coverage:
    cargo llvm-cov nextest --open

# show dependencies of this project
[group('development')]
dependencies:
    cargo tree

# alias for 'dependencies'
[group('development')]
deps: dependencies

# create a docker image (requires Docker); run with SHOW_PROGRESS=1 to enable verbose output
[group('docker')]
docker-image-create $SHOW_PROGRESS="0":
    @echo "Creating a docker image ... (add SHOW_PROGRESS=1 to just command to enable verbose output)"
    ./tools/docker/create_image.sh

# size of the docker image (requires Docker)
[group('docker')]
docker-image-size:
    docker images $DOCKER_IMAGE_NAME

# run the docker image (requires Docker)
[group('docker')]
docker-image-run:
    @echo "Running container from docker image ..."
    ./tools/docker/start_container.sh

# generate the documentation of this project
[group('development')]
docs:
    cargo doc --open

# format source code
[group('development')]
format:
    cargo +nightly fmt -- --config imports_granularity=Item

# build and install the binary locally
[group('development')]
install: build test
    cargo install --path .

# build and install the static binary locally
[group('development')]
install-static: build test
    RUSTFLAGS='-C target-feature=+crt-static' cargo install --path .

# Show license of dependencies (requires https://github.com/onur/cargo-license)
[group('development')]
license:
    cargo license

# lint the sources
[group('development')]
lint:
    #!/usr/bin/env bash
    #
    # Default clippy settings (used by `cargo [build, test]` automatically):
    #
    #   cargo clippy
    #
    # If you want stricter clippy settings, start with the suggestion below
    # and consider adding this `lint` target as a dependency to other just
    # targets like `build` and `test`.
    #
    # --all-targets:  check sources and tests
    # --all-features: check non-default crate features
    # -D warnings:    fail the build when encountering warnings
    #
    cargo clippy --verbose --all-targets --all-features --tests -- -D warnings

# auto-apply fixes to lint problems
[group('development')]
lint-autocorrect:
    cargo clippy --fix --verbose --all-targets --all-features --tests --allow-dirty "$@"

# detect undefined behavior with miri (requires https://github.com/rust-lang/miri)
[group('security')]
miri:
    cargo clean
    cargo +nightly miri test
    cargo +nightly miri run

# detect outdated crates (requires https://github.com/kbknapp/cargo-outdated)
[group('development')]
outdated:
    cargo outdated

# check, test, lint, miri
[group('development')]
pre-release: check test lint audit miri

# profile the release binary (requires https://github.com/mstange/samply, which uses profiler.firefox.com as UI)
[group('development')]
profile-release:
    # Requires a profile named 'profiling' in ~/.cargo/config.toml
    cargo build --profile profiling && \
    RUST_BACKTRACE=1 samply record target/profiling/{{binary}}

# build release executable
[group('production')]
release: pre-release
    cargo build --release && echo "Executable at target/release/{{binary}}"

# build and run
[group('production')]
run:
    cargo run

# run tests (requires https://nexte.st/)
#
# `--no-fail-fast` is important to ensure all tests are being run.
#
# Run `cargo install cargo-nextest` if you don't have nextest installed.
[group('development')]
test: lint
    cargo nextest run --no-fail-fast

# run tests in vanilla mode (use when nextest is not installed)
[group('development')]
test-vanilla: lint
    cargo test

# generate report for compilation times
[group('development')]
timings:
    @echo "Details at https://doc.rust-lang.org/stable/cargo/reference/timings.html"
    cargo build --timings

# show version of this project
[group('development')]
version:
    @echo "Project {{version}}"
    @rustc --version
    @cargo --version

# test a debug binary with valgrind (requires valgrind; supported on Linux, but not on, e.g., macOS)
[group('development')]
[linux]
valgrind: clean build
    valgrind -v --error-exitcode=1 --track-origins=yes --leak-check=full target/debug/rust-template-app

# run build when sources change (requires https://github.com/watchexec/watchexec)
[group('development')]
watch:
    # Watch all rs and toml files in the current directory and all
    # subdirectories for changes.  If something changed, re-run the build.
    CARGO_INCREMENTAL=1 watchexec --clear --exts rs,toml -- just build

# run check then tests when sources change (requires https://github.com/watchexec/cargo-watch)
[group('development')]
watch-test:
    CARGO_INCREMENTAL=1 cargo watch -q -c -x check -x 'nextest run'

# run tests when sources change (requires https://github.com/Canop/bacon)
[group('development')]
watch-test-bacon:
    CARGO_INCREMENTAL=1 bacon --no-wrap test
