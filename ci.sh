#!/usr/bin/env bash
set -euo pipefail

cargo --version
rustc --version
cargo build --release
cargo test --release

binary="build/release/hello"
if [[ ! -x "$binary" ]]; then
    printf 'Expected executable not found: %s\n' "$binary" >&2
    exit 1
fi

"$binary"
mkdir -p dist
cp "$binary" dist/hello
