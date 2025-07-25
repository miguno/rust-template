# syntax=docker/dockerfile:1

# We use a multi-stage build setup.
# (https://docs.docker.com/build/building/multi-stage/)

# Stage 1 (to create a "build" image)
# ===================================
# Official rust images at https://hub.docker.com/_/rust
FROM rust:1.87.0 AS builder
# smoke test to verify if rust toolchain is available
RUN rustc --version

WORKDIR /app
COPY . .
# Lint
RUN rustup component add clippy && \
    cargo clippy --all-targets --all-features -- -D warnings
# Test
RUN cargo test
# Miri
RUN rustup toolchain install nightly --component miri && \
    cargo +nightly miri setup
RUN cargo +nightly miri test
RUN cargo +nightly miri run
# Build and install a static binary
RUN \
    # Ensure that a static binary is built.  Otherwise trying to run a
    # container from this image will error with "<the binary> not found".
    # The error message is misleading; "not found" can also mean that the ELF
    # interpreter is missing, see https://stackoverflow.com/questions/2716702.
    # You can verify whether a binary is static with `readelf`:
    #
    #   $ readelf -l /path/to/binary
    #
    # If the binary is static, the ELF interpreter should NOT be listed in the
    # output.  That is, for a static binary, there should NOT be a line such as
    # the following:
    #
    #   [Requesting program interpreter: /lib/ld-linux-aarch64.so.1]
    #
    RUSTFLAGS='-C target-feature=+crt-static' \
    # Installs the binary locally.
    # `cargo install` uses "$CARGO_HOME" in this setup as install location, which
    # defaults to `/usr/local/cargo`.  See `cargo help install`.
    cargo install --path .

# Stage 2 (to create a downsized "container executable", ~5MB)
# ============================================================
#
# If you need SSL certificates for HTTPS, replace `FROM scratch` with:
#
#   FROM alpine:3.18.0
#   RUN apk --no-cache add ca-certificates
#
FROM scratch
WORKDIR /root/
COPY --from=builder /usr/local/cargo/bin/rust-template-app /usr/local/bin/rust-template-app
CMD ["rust-template-app"]
