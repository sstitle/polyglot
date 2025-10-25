{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation {
  pname = "hello";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    clang
  ];

  cmakeFlags = [
    "-GNinja"
  ];

  env = {
    CC = "clang";
    CXX = "clang++";
  };

  meta = with pkgs.lib; {
    description = "A simple Hello World C++ application built with CMake, Clang, and Ninja";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
