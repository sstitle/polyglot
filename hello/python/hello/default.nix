{
  pkgs ? import <nixpkgs> { },
}:

let
  # Separate derivation for the virtual environment
  # This only rebuilds when pyproject.toml or uv.lock changes
  venv = pkgs.stdenv.mkDerivation {
    pname = "hello-venv";
    version = "0.1.0";

    src = pkgs.lib.cleanSourceWith {
      src = ./.;
      filter = path: type:
        let baseName = baseNameOf path;
        in baseName == "pyproject.toml" || baseName == "uv.lock";
    };

    nativeBuildInputs = [ pkgs.uv ];
    buildInputs = [ pkgs.python313 ];

    buildPhase = ''
      export UV_CACHE_DIR=$TMPDIR/uv-cache
      export UV_PROJECT_ENVIRONMENT=$PWD/.venv
      ${pkgs.uv}/bin/uv sync
    '';

    installPhase = ''
      cp -r .venv $out
    '';
  };
in
pkgs.stdenv.mkDerivation {
  pname = "hello";
  version = "0.1.0";

  src = pkgs.lib.cleanSourceWith {
    src = ./.;
    filter = path: type:
      let baseName = baseNameOf path;
      in baseName == "main.py" || baseName == "pyproject.toml" || baseName == "uv.lock";
  };

  buildPhase = "true"; # No build needed, just copying files

  installPhase = ''
    mkdir -p $out/share/hello

    # Copy source files
    cp main.py $out/share/hello/
    cp pyproject.toml $out/share/hello/
    cp uv.lock $out/share/hello/

    # Link to the pre-built virtual environment
    ln -s ${venv} $out/share/hello/.venv

    mkdir -p $out/bin
    cat > $out/bin/hello <<EOF
#!/bin/sh
export UV_PROJECT_ENVIRONMENT=$out/share/hello/.venv
cd $out/share/hello
exec ${pkgs.uv}/bin/uv run --no-sync python main.py
EOF
    chmod +x $out/bin/hello
  '';

  meta = with pkgs.lib; {
    description = "A simple Hello World Python application";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
