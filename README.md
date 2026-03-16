# magma

GPU-architecture-specific MAGMA 2.9.0 static libraries for CUDA 12.9, built with [Flox](https://flox.dev).

Each variant targets a single CUDA SM architecture + CPU ISA, producing smaller optimized static libraries compared to the default all-architecture `magma-cuda-static` from nixpkgs (~7GB closure).

## Quick Start

```bash
# Build a variant for your GPU + CPU
flox build magma-cuda12_9-sm90-avx2

# Check the output
ls result-magma-cuda12_9-sm90-avx2/lib/
# libmagma.a  libmagma_sparse.a

# Publish to your catalog
flox publish magma-cuda12_9-sm90-avx2
```

## Build Matrix

### GPU Architectures

| SM | Architecture | GPUs | Naming |
|----|-------------|------|--------|
| 61 | Pascal | P40, GTX 1080 Ti | sm61 |
| 75 | Turing | T4, RTX 2080 Ti | sm75 |
| 80 | Ampere | A100, A30 | sm80 |
| 86 | Ampere | A40, RTX 3090 | sm86 |
| 89 | Ada Lovelace | L40, RTX 4090 | sm89 |
| 90 | Hopper | H100, H200, L40S | sm90 |
| 100 | Blackwell | B200, GB200 | sm100 |
| 120 | Vera Rubin | R100 | sm120 |

### CPU ISAs

| ISA | Platform | Flag |
|-----|----------|------|
| avx | x86_64 | `-mavx` |
| avx2 | x86_64 | `-mavx2 -mfma -mf16c` |
| avx512 | x86_64 | `-mavx512f -mavx512dq -mavx512vl -mavx512bw -mfma` |
| avx512bf16 | x86_64 | `-mavx512f -mavx512dq -mavx512vl -mavx512bw -mavx512bf16 -mfma` |
| avx512vnni | x86_64 | `-mavx512f -mavx512dq -mavx512vl -mavx512bw -mavx512vnni -mfma` |
| armv8_2 | aarch64 | `-march=armv8.2-a+fp16+dotprod` |
| armv9 | aarch64 | `-march=armv9-a+sve2+bf16+i8mm` |

### Variant Selection Guide

**Data center GPUs:**
- A100/A30 → `sm80`
- A40 → `sm86`
- L40/L40S → `sm89` or `sm90`
- H100/H200 → `sm90`
- B200/GB200 → `sm100`

**Consumer GPUs:**
- GTX 1080 Ti → `sm61`
- RTX 2080 Ti → `sm75`
- RTX 3090 → `sm86`
- RTX 4090 → `sm89`

**CPU ISA:** Use `avx2` for broad compatibility, `avx512` for Intel Xeon/Ice Lake+, `armv8_2` or `armv9` for ARM servers.

## Variant Naming

```
magma-cuda12_9-sm{SM}-{ISA}
```

Example: `magma-cuda12_9-sm90-avx2` = MAGMA for H100 (SM90) with AVX2 CPU optimizations on CUDA 12.9.

## Regenerating Variants

After modifying `gpu-metadata.nix` or `cpu-isa.nix`:

```bash
bash scripts/generate-variants.sh
```

## Technical Details

- **MAGMA version:** 2.9.0
- **CUDA:** 12.9 only
- **Build type:** Static (dynamic CUDA MAGMA is broken in nixpkgs)
- **Nixpkgs pin:** `ed142ab1b3a092c4d149245d0c4126a5d7ea00b0`
- **Output:** `libmagma.a`, `libmagma_sparse.a`, headers
