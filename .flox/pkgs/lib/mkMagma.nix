# Parametric MAGMA builder
# Creates GPU-architecture-specific MAGMA 2.9.0 static libraries for CUDA 12.9.
# Each variant targets a single SM architecture + CPU ISA, producing a smaller
# optimized static library compared to the default all-architecture build.
#
# Arguments:
#   sm:  SM architecture number (e.g., "90")
#   isa: CPU ISA key from cpu-isa.nix (e.g., "avx2", "armv9")
{ sm, isa }:

let
  # ── Lookup tables ─────────────────────────────────────────────────────
  cpuISAs = import ./cpu-isa.nix;
  gpuMeta = import ./gpu-metadata.nix;

  # ── ISA configuration ────────────────────────────────────────────────
  isaConfig = cpuISAs.${isa};
  platform  = isaConfig.platform;

  # ── GPU configuration ────────────────────────────────────────────────
  smMeta     = gpuMeta.${sm};
  capability = smMeta.capability;

  # ── Variant naming ───────────────────────────────────────────────────
  variantName = "magma-cuda12_9-sm${sm}-${isa}";
  description = "MAGMA 2.9.0 static for NVIDIA ${smMeta.gpuNames} (SM${sm}) -- ${isaConfig.name} -- CUDA 12.9";

  # ── MIN_ARCH format: SM90 → "900", SM100 → "1000" ───────────────────
  minArch = "${sm}0";

  # ── Nixpkgs pin (same as build-onnx-runtime CUDA 12.9) ──────────────
  nixpkgs_pinned = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/ed142ab1b3a092c4d149245d0c4126a5d7ea00b0.tar.gz";
  }) {
    config = {
      allowUnfree = true;
      cudaSupport = true;
      cudaCapabilities = [ capability ];
    };
    overlays = [ (final: prev: { cudaPackages = final.cudaPackages_12_9; }) ];
  };

  inherit (nixpkgs_pinned) lib;

in
  (nixpkgs_pinned.magma.override {
    cudaSupport = true;
    rocmSupport = false;
    static = true;
  }).overrideAttrs (oldAttrs: {
    pname = variantName;

    # Filter out default CMAKE_CUDA_ARCHITECTURES and MIN_ARCH, replace with single-SM values
    cmakeFlags = let
      filtered = builtins.filter (f:
        let s = builtins.toString f; in
        !(lib.hasPrefix "-DCMAKE_CUDA_ARCHITECTURES" s) &&
        !(lib.hasPrefix "-DMIN_ARCH" s)
      ) (oldAttrs.cmakeFlags or []);
    in filtered ++ [
      (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" sm)
      (lib.cmakeFeature "MIN_ARCH" minArch)
    ];

    # Append CPU ISA flags — preserves base derivation's env.CFLAGS = "-DADD_"
    preConfigure = (oldAttrs.preConfigure or "") + ''
      export CFLAGS="${lib.concatStringsSep " " isaConfig.flags} $CFLAGS"
      export CXXFLAGS="${lib.concatStringsSep " " isaConfig.flags} $CXXFLAGS"
    '';

    requiredSystemFeatures = [ "big-parallel" ];

    meta = oldAttrs.meta // {
      inherit description;
      platforms = [ platform ];
    };
  })
