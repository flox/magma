# CLAUDE.md

## Project Overview

GPU-architecture-specific MAGMA 2.9.0 static library builds for CUDA 12.9. Each variant targets a single CUDA SM architecture + CPU ISA, producing smaller, optimized static libraries compared to the default all-architecture `magma-cuda-static` from nixpkgs.

These libraries are consumed by downstream builds (PyTorch, ONNX Runtime) to avoid the ~7GB all-architecture closure.

## Architecture

Uses the parametric builder pattern (same as build-llamacpp):

```
.flox/pkgs/
├── lib/
│   ├── mkMagma.nix       # Core builder — all override logic lives here
│   ├── cpu-isa.nix       # 7 CPU ISA definitions (avx, avx2, avx512, avx512bf16, avx512vnni, armv8_2, armv9)
│   └── gpu-metadata.nix  # 8 SM architectures with metadata
└── magma-cuda12_9-*.nix  # 56 thin 3-line wrappers (8 SMs × 7 ISAs)
```

## Variant Matrix

**GPU Architectures (8):** SM61 (Pascal), SM75 (Turing), SM80 (Ampere), SM86 (Ampere), SM89 (Ada), SM90 (Hopper), SM100 (Blackwell), SM120 (Vera Rubin)

**CPU ISAs (7):** avx, avx2, avx512, avx512bf16, avx512vnni, armv8_2, armv9

**Total variants:** 56

## Common Commands

```bash
# Build a specific variant
flox build magma-cuda12_9-sm90-avx2

# Check output
ls result-magma-cuda12_9-sm90-avx2/lib/

# Regenerate wrapper files after editing gpu-metadata.nix or cpu-isa.nix
bash scripts/generate-variants.sh

# Publish a variant
flox publish magma-cuda12_9-sm90-avx2
```

## Key Technical Details

- **Nixpkgs pin:** `ed142ab1b3a092c4d149245d0c4126a5d7ea00b0` (matches build-onnx-runtime CUDA 12.9)
- **CUDA toolkit:** 12.9 via `cudaPackages_12_9` overlay
- **Build type:** Static only (dynamic CUDA MAGMA is broken in nixpkgs)
- **MIN_ARCH format:** SM number + "0" suffix (e.g., SM90 → "900", SM100 → "1000")
- **Base env:** `CFLAGS="-DADD_"` is set by upstream derivation and preserved

## Commit Conventions

- Package updates: `magma: update to <version>`
- New architectures: `magma: add SM<nn> variants`
- Infrastructure: `scripts:`, `manifest:`, `flox:`
