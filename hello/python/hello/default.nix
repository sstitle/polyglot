{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "hello";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.uv ];
  buildInputs = [ pkgs.python313 ];

  buildPhase = ''
    # Create virtual environment using uv
    export UV_CACHE_DIR=$TMPDIR/uv-cache
    export UV_PROJECT_ENVIRONMENT=$PWD/.venv
    ${pkgs.uv}/bin/uv sync
  '';

  installPhase = ''
    mkdir -p $out/share/hello

    # Copy source files
    cp main.py $out/share/hello/
    cp pyproject.toml $out/share/hello/
    cp uv.lock $out/share/hello/

    # Copy the virtual environment
    cp -r .venv $out/share/hello/.venv

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
