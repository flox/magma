# MAGMA 2.9.0 static for NVIDIA B200, GB200 (SM100) -- ARMv8.2 -- CUDA 12.9
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkMagma.nix { sm = "100"; isa = "armv8_2"; }
