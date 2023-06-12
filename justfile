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

# show available targets
default:
    @just --list --justfile {{justfile()}}

# show Assembly, LLVM-IR, MIR and WASM for Rust code (requires https://github.com/pacak/cargo-show-asm)
asm *args='':
    # Examples:
    # just asm --lib
    # just asm --lib 0
    # just asm --lib "rust_template::doubler"
    cargo asm {{args}}

# detect known vulnerabilities (requires https://github.com/rustsec/rustsec)
audit:
    cargo audit

# build debug executable
build: lint
    cargo build && echo "Executable at target/debug/{{binary}}"

# analyze the current package and report errors, but don't build object files (faster than 'build')
check:
    cargo check

# show test coverage (requires https://lib.rs/crates/cargo-llvm-cov)
coverage:
    cargo llvm-cov nextest --open

# show dependencies of this project
deps:
    cargo tree

# create a docker image (requires Docker); run with SHOW_PROGRESS=1 to enable verbose output
docker-image-create $SHOW_PROGRESS="0":
    @echo "Creating a docker image ... (add SHOW_PROGRESS=1 to just command to enable verbose output)"
    ./tools/docker/create_image.sh

# size of the docker image (requires Docker)
docker-image-size:
    docker images $DOCKER_IMAGE_NAME

# run the docker image (requires Docker)
docker-image-run:
    @echo "Running container from docker image ..."
    ./tools/docker/start_container.sh
# generate the documentation of this project
docs:
    cargo doc --open

# format source code
format:
    cargo +nightly fmt

# build and install the binary locally
install: build test
    cargo install --path .

# build and install the static binary locally
install-static: build test
    RUSTFLAGS='-C target-feature=+crt-static' cargo install --path .

# evaluate and print all just variables
just-vars:
    @just --evaluate

# Show license of dependencies (requires https://github.com/onur/cargo-license)
license:
    cargo license

# linters (requires https://github.com/rust-lang/rust-clippy)
lint:
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
    cargo clippy --verbose --all-targets --all-features -- -D warnings

# detect undefined behavior with miri (requires https://github.com/rust-lang/miri)
miri:
    cargo clean
    cargo +nightly miri test
    cargo +nightly miri run

# detect outdated crates (requires https://github.com/kbknapp/cargo-outdated)
outdated:
    cargo outdated

# check, test, lint, miri
pre-release: check test lint audit miri

# build release executable
release: pre-release
    cargo build --release && echo "Executable at target/release/{{binary}}"

# build and run
run:
    cargo run

# print system information such as OS and architecture
system-info:
  @echo "architecture: {{arch()}}"
  @echo "os: {{os()}}"
  @echo "os family: {{os_family()}}"

# run tests (requires https://nexte.st/)
test: lint
    cargo nextest run

# run tests in vanilla mode (use when nextest is not installed)
test-vanilla: lint
    cargo test

# show version of this project
version:
    @echo "{{version}}"

# run check then tests when sources change (requires https://github.com/watchexec/cargo-watch)
watch-test:
    cargo watch -q -c -x check -x 'nextest run'

