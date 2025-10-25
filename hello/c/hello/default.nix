{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation {
  pname = "hello";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.clang ];

  buildPhase = ''
    clang -o hello main.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp hello $out/bin/
  '';

  meta = with pkgs.lib; {
    description = "A simple Hello World C application";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
