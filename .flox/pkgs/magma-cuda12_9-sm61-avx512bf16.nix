# MAGMA 2.9.0 static for NVIDIA P40, GTX 1080 Ti (SM61) -- AVX-512 BF16 -- CUDA 12.9
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkMagma.nix { sm = "61"; isa = "avx512bf16"; }
