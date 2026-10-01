#!/usr/bin/env bash
set -euo pipefail

WORKDIR=/data/users/mmeka/assembly_annotation_course
cd "$WORKDIR"
mkdir -p .log/output .log/error

declare -A ASSEMBLIES=(
    [flye]=results/Assemblies/Flye/assembly.fasta
    [hifiasm]=results/Assemblies/HiFiASM/ERR11437321.asm.bp.p_ctg.fa
    [LJA]=results/Assemblies/LJA/assembly.fasta
)

for NAME in "${!ASSEMBLIES[@]}"; do
    for REF in 0 1; do
        jid=$(sbatch --parsable script/06-20_run_quast.sh "${ASSEMBLIES[$NAME]}" "$NAME" "$REF")
        echo "$NAME (ref=$REF): job $jid"
    done
done