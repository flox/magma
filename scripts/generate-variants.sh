#!/usr/bin/env bash
# Generate MAGMA variant wrapper .nix files for all SM × ISA combinations.
# Produces 56 thin wrapper files in .flox/pkgs/ (8 SMs × 7 ISAs).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="$SCRIPT_DIR/../.flox/pkgs"

# ── GPU architectures (SM number → architecture name → GPU names) ──────
declare -A SM_ARCH_NAME=(
  [61]="Pascal"
  [75]="Turing"
  [80]="Ampere"
  [86]="Ampere"
  [89]="Ada Lovelace"
  [90]="Hopper"
  [100]="Blackwell"
  [120]="Vera Rubin"
)

declare -A SM_GPU_NAMES=(
  [61]="P40, GTX 1080 Ti"
  [75]="T4, RTX 2080 Ti"
  [80]="A100, A30"
  [86]="A40, RTX 3090"
  [89]="L40, RTX 4090"
  [90]="H100, H200, L40S"
  [100]="B200, GB200"
  [120]="R100"
)

SM_LIST=(61 75 80 86 89 90 100 120)

# ── CPU ISAs ───────────────────────────────────────────────────────────
ISA_LIST=(avx avx2 avx512 avx512bf16 avx512vnni armv8_2 armv9)

declare -A ISA_DISPLAY_NAME=(
  [avx]="AVX"
  [avx2]="AVX2"
  [avx512]="AVX-512"
  [avx512bf16]="AVX-512 BF16"
  [avx512vnni]="AVX-512 VNNI"
  [armv8_2]="ARMv8.2"
  [armv9]="ARMv9"
)

# ── Generate wrappers ──────────────────────────────────────────────────
count=0
for sm in "${SM_LIST[@]}"; do
  for isa in "${ISA_LIST[@]}"; do
    filename="magma-cuda12_9-sm${sm}-${isa}.nix"
    filepath="$PKG_DIR/$filename"

    cat > "$filepath" <<EOF
# MAGMA 2.9.0 static for NVIDIA ${SM_GPU_NAMES[$sm]} (SM${sm}) -- ${ISA_DISPLAY_NAME[$isa]} -- CUDA 12.9
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkMagma.nix { sm = "${sm}"; isa = "${isa}"; }
EOF

    count=$((count + 1))
  done
done

echo "Generated $count variant files in $PKG_DIR"
