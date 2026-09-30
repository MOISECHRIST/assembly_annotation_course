#!/usr/bin/env bash
set -euo pipefail

# Usage: bash launch_merqury.sh <reads.fastq.gz> [k]
READS=$(realpath "$1")
K=${2:-21}

WORKDIR=/data/users/mmeka/assembly_annotation_course
cd "$WORKDIR"

# Assemblies: name -> path (edit the paths to match your results)
declare -A ASSEMBLIES=(
    [flye]=results/Assemblies/Flye/assembly.fasta
    [hifiasm]=results/Assemblies/HiFiASM/ERR11437321.asm.bp.p_ctg.fa
    [LJA]=results/Assemblies/LJA/assembly.fasta
)

# 1. Build the k-mer database
jid=$(sbatch --parsable script/06-30_run_meryl.sh "$READS" "$K")
echo "meryl submitted: job $jid"

# 2. One merqury job per assembly, each waiting for meryl
for NAME in "${!ASSEMBLIES[@]}"; do
    mjid=$(sbatch --parsable --dependency=afterok:$jid \
        script/06-31_run_merqury.sh "${ASSEMBLIES[$NAME]}" "$NAME")
    echo "merqury $NAME submitted: job $mjid (after $jid)"
done