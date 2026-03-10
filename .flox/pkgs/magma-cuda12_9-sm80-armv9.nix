# MAGMA 2.9.0 static for NVIDIA A100, A30 (SM80) -- ARMv9 -- CUDA 12.9
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkMagma.nix { sm = "80"; isa = "armv9"; }
