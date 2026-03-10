# MAGMA 2.9.0 static for NVIDIA T4, RTX 2080 Ti (SM75) -- ARMv8.2 -- CUDA 12.9
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkMagma.nix { sm = "75"; isa = "armv8_2"; }
