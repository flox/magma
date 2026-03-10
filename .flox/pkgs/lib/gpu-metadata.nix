# GPU metadata: SM architecture -> capability string, architecture name, GPU names.
# Used by mkMagma.nix for CUDA variant configuration and by generate-variants.sh for matrix generation.
# All ISAs are allowed for all architectures (no allowedISAs restrictions).
{
  "61" = {
    capability = "6.1";
    archName = "Pascal";
    gpuNames = "P40, GTX 1080 Ti";
  };
  "75" = {
    capability = "7.5";
    archName = "Turing";
    gpuNames = "T4, RTX 2080 Ti";
  };
  "80" = {
    capability = "8.0";
    archName = "Ampere";
    gpuNames = "A100, A30";
  };
  "86" = {
    capability = "8.6";
    archName = "Ampere";
    gpuNames = "A40, RTX 3090";
  };
  "89" = {
    capability = "8.9";
    archName = "Ada Lovelace";
    gpuNames = "L40, RTX 4090";
  };
  "90" = {
    capability = "9.0";
    archName = "Hopper";
    gpuNames = "H100, H200, L40S";
  };
  "100" = {
    capability = "10.0";
    archName = "Blackwell";
    gpuNames = "B200, GB200";
  };
  "120" = {
    capability = "12.0";
    archName = "Vera Rubin";
    gpuNames = "R100";
  };
}
