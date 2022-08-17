{
  description = "A devShell example";

  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        devShell = mkShell {
          buildInputs = [
            openssl
            pkgconfig
            rust-bin.nightly."2022-06-22".default
            # protobuf
            # libcxxClang
            # libcxx
            clang
          ];

          PROTOC = "${pkgs.protobuf}/bin/protoc";
          PROTOC_INCLUDE = "${pkgs.protobuf}/include";
          LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
          # CLANG_RESOURCE_DIR="${llvmPackages.clang-unwrapped}";

          RUST_BACKTRACE="full";
        };
      }
    );
}
