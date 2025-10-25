{
  pkgs ? import <nixpkgs> { },
}:

pkgs.buildNpmPackage {
  pname = "hello";
  version = "0.1.0";

  src = ./.;

  npmDepsHash = "sha256-91MQLJ3icG7JWObNQvPVdkJKdQh4ecw5G4+oiMf1ltA=";

  npmBuildScript = "build";

  meta = with pkgs.lib; {
    description = "A simple Hello World TypeScript application";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
