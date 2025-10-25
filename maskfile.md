# Maskfile

This is a [mask](https://github.com/jacobdeichert/mask) task runner file.

## hello

> This is an example command you can run with `mask hello`

```nu
# keep-sorted enable
nix run .#hello-c
nix run .#hello-cpp
nix run .#hello-rust
nix run .#hello-zig
nix run .#hello-go
nix run .#hello-py
```
