# MAGMA 2.9.0 static for NVIDIA R100 (SM120) -- AVX -- CUDA 12.9
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkMagma.nix { sm = "120"; isa = "avx"; }
