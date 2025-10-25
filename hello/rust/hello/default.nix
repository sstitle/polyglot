{
  pkgs ? import <nixpkgs> { },
}:

pkgs.rustPlatform.buildRustPackage {
  pname = "hello";
  version = "0.1.0";

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = with pkgs.lib; {
    description = "A simple Hello World Rust application";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
