# MAGMA 2.9.0 static for NVIDIA H100, H200, L40S (SM90) -- AVX -- CUDA 12.9
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkMagma.nix { sm = "90"; isa = "avx"; }
