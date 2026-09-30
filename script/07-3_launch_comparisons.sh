#!/usr/bin/env bash
set -euo pipefail

WORKDIR=/data/users/mmeka/assembly_annotation_course
cd "$WORKDIR"
mkdir -p .log/output .log/error results/Genome_comparison

REF=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa

# Edit these paths to match your assemblies
FLYE=results/Assemblies/Flye/assembly.fasta
HIFIASM=results/Assemblies/HiFiASM/ERR11437321.asm.bp.p_ctg.fa
LJA=results/Assemblies/LJA/assembly.fasta

# prefix:reference:query
COMPARISONS=(
    "flye_vs_ref:$REF:$FLYE"
    "hifiasm_vs_ref:$REF:$HIFIASM"
    "LJA_vs_ref:$REF:$LJA"
    "flye_vs_hifiasm:$FLYE:$HIFIASM"
    "flye_vs_LJA:$FLYE:$LJA"
    "hifiasm_vs_LJA:$HIFIASM:$LJA"
)

for C in "${COMPARISONS[@]}"; do
    IFS=: read -r PREFIX R Q <<< "$C"
    nid=$(sbatch --parsable script/07-1_run_nucmer.sh "$R" "$Q" "$PREFIX")
    pid=$(sbatch --parsable --dependency=afterok:$nid script/07-2_run_mummerplot.sh "$R" "$Q" "$PREFIX")
    echo "$PREFIX: nucmer $nid -> mummerplot $pid"
done