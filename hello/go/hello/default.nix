{
  pkgs ? import <nixpkgs> { },
}:

pkgs.buildGoModule {
  pname = "hello";
  version = "0.1.0";

  src = ./.;

  vendorHash = null;

  meta = with pkgs.lib; {
    description = "A simple Hello World Go application";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
