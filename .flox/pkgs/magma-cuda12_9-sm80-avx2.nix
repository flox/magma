# MAGMA 2.9.0 static for NVIDIA A100, A30 (SM80) -- AVX2 -- CUDA 12.9
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkMagma.nix { sm = "80"; isa = "avx2"; }
