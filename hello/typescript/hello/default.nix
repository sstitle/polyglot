{
  pkgs ? import <nixpkgs> { },
}:

let
  # Separate derivation for node_modules
  # This only rebuilds when package.json or package-lock.json changes
  nodeModules = pkgs.buildNpmPackage {
    pname = "hello-node-modules";
    version = "0.1.0";

    src = pkgs.lib.cleanSourceWith {
      src = ./.;
      filter = path: type:
        let baseName = baseNameOf path;
        in baseName == "package.json" || baseName == "package-lock.json";
    };

    npmDepsHash = "sha256-91MQLJ3icG7JWObNQvPVdkJKdQh4ecw5G4+oiMf1ltA=";

    dontNpmBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -r node_modules $out/
    '';
  };
in
pkgs.stdenv.mkDerivation {
  pname = "hello";
  version = "0.1.0";

  src = pkgs.lib.cleanSourceWith {
    src = ./.;
    filter = path: type:
      let
        baseName = baseNameOf path;
        relativePath = pkgs.lib.removePrefix (toString ./. + "/") (toString path);
      in
        baseName == "tsconfig.json" ||
        baseName == "package.json" ||
        (type == "directory" && baseName == "src") ||
        (pkgs.lib.hasPrefix "src/" relativePath && type == "regular");
  };

  nativeBuildInputs = [ pkgs.nodejs ];

  buildPhase = ''
    # Link to pre-built node_modules
    ln -s ${nodeModules}/node_modules node_modules

    # Compile TypeScript
    npx tsc
  '';

  installPhase = ''
    mkdir -p $out/share/hello

    # Copy the compiled JavaScript
    cp -r dist $out/share/hello/

    # Create a wrapper script that runs the compiled code
    mkdir -p $out/bin
    cat > $out/bin/hello <<EOF
#!/bin/sh
exec ${pkgs.nodejs}/bin/node $out/share/hello/dist/main.js
EOF
    chmod +x $out/bin/hello
  '';

  meta = with pkgs.lib; {
    description = "A simple Hello World TypeScript application";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
