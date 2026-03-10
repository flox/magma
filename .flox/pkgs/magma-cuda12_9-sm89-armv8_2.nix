# MAGMA 2.9.0 static for NVIDIA L40, RTX 4090 (SM89) -- ARMv8.2 -- CUDA 12.9
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkMagma.nix { sm = "89"; isa = "armv8_2"; }
