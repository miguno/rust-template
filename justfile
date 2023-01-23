# Load environment variables from `.env` file.
set dotenv-load

# Extracts the binary name from the settings `name = <...>` in the `[[bin]]`
# section of Cargo.toml
#
# Alternative command:
# `sed -n '/[[bin]]/,/name =/p' Cargo.toml | awk '/^name =/{gsub(/"/, "", $3); print $3}'`
binary := `cargo pkgid | sed -rn s'/^.*\/(.*)#.*$/\1/p'`

# Get version from Cargo.toml/Cargo.lock
#
# Alternative command:
# `cargo metadata --format-version=1 | jq '.packages[]|select(.name=="rust-template").version'`
version := `cargo pkgid | sed -rn s'/^.*#(.*)$/\1/p'`

project_dir := justfile_directory()

# show available targets
default:
    @just --list --justfile {{justfile()}}

# detect known vulnerabilities (requires https://github.com/rustsec/rustsec)
audit:
    cargo audit

# format source code
format:
    cargo +nightly fmt

# build debug executable
build: lint
    cargo build && echo "Executable at target/debug/{{binary}}"

check:
    cargo check

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
    cargo clippy --all-targets --all-features -- -D warnings

pre-release: check test lint

# build release executable
release:
    cargo build --release && echo "Executable at target/release/{{binary}}"

# build and run
run:
    cargo run

# build and install the binary locally
install: build test
    cargo install --path .

# build and install the static binary locally
install-static: build test
    RUSTFLAGS='-C target-feature=+crt-static' cargo install --path .

# detect outdated crates (requires https://github.com/kbknapp/cargo-outdated)
outdated:
    cargo outdated

# run tests (requires https://nexte.st/)
test: lint
    cargo nextest run

# run tests in vanilla mode (use when nextest is not installed)
test-vanilla: lint
    cargo test

# run check then tests when sources change (requires https://github.com/watchexec/cargo-watch)
watch-test:
    cargo watch -x check -x 'nextest run'

# print system information such as OS and architecture
system-info:
  @echo "architecture: {{arch()}}"
  @echo "os: {{os()}}"
  @echo "os family: {{os_family()}}"

# create a docker image (requires Docker)
docker-image-create:
    @echo "Creating a docker image ..."
    ./create_image.sh

# size of the docker image (requires Docker)
docker-image-size:
    docker images $DOCKER_IMAGE_NAME

# run the docker image (requires Docker)
docker-run:
    @echo "Running container from docker image ..."
    ./start_container.sh
