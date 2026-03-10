# MAGMA 2.9.0 static for NVIDIA A40, RTX 3090 (SM86) -- AVX2 -- CUDA 12.9
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkMagma.nix { sm = "86"; isa = "avx2"; }
