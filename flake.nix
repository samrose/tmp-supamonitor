{
  inputs = {
    naersk.url = "github:nix-community/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, naersk }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        naersk-lib = pkgs.callPackage naersk { };
        isDarwin = pkgs.stdenv.isDarwin;

        # Platform-specific dependencies
        darwinDeps = with pkgs; [
          apple-sdk_15
          libiconv
        ];

        linuxDeps = with pkgs; [
          gcc
        ];

        platformDeps = if isDarwin then darwinDeps else linuxDeps;
        postgresql = pkgs.postgresql_17;
      in
      {
        defaultPackage = naersk-lib.buildPackage ./.;
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cargo
            rustc
            rustfmt
            pre-commit
            rustPackages.clippy
            cargo-pgrx
            postgresql
            pkg-config
            openssl
            readline
            zlib
            icu
            bison
            flex
            # Required for pgrx bindgen
            llvmPackages.libclang
            llvmPackages.clang
          ] ++ platformDeps;

          RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;

          # pgrx environment variables
          LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";

          shellHook = ''
            export PGRX_HOME="$PWD/.pgrx"
            export PG_CONFIG="${postgresql.pg_config}/bin/pg_config"
          '';
        };
      }
    );
}
