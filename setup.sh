curl https://sh.rustup.rs -sSf|sh
#rustup self uninstall

rustup toolchain install nightly

rustup component add rustfmt
rustup component add rustfmt --toolchain nightly
rustup component add rustc-dev-x86_64-unknown-linux-gnu
rustup component add rustc-dev-x86_64-unknown-linux-gnu --toolchain nightly
rustup component add rls-x86_64-unknown-linux-gnu
rustup component add rls-x86_64-unknown-linux-gnu --toolchain nightly
rustup component add rust-analysis-x86_64-unknown-linux-gnu
rustup component add rust-analysis-x86_64-unknown-linux-gnu --toolchain nightly

rustup component add rust-src
cargo install cargo-nx --git https://github.com/aarch64-switch-rs/cargo-nx

rustup update
cargo nx --release