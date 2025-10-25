{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation {
  pname = "hello";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.zig ];

  buildPhase = ''
    export XDG_CACHE_HOME=$TMPDIR/cache
    mkdir -p $XDG_CACHE_HOME
    zig build -Doptimize=ReleaseSafe
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp zig-out/bin/hello $out/bin/
  '';

  meta = with pkgs.lib; {
    description = "A simple Hello World Zig application";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
