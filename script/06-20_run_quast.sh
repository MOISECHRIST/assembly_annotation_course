#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --job-name=run_quast
#SBATCH --mail-user=moise.meka@students.unibe.ch
#SBATCH --mail-type=start,end,fail
#SBATCH --output=/data/users/mmeka/assembly_annotation_course/.log/output/%x_%j.o
#SBATCH --error=/data/users/mmeka/assembly_annotation_course/.log/error/%x_%j.e
#SBATCH --partition=pshort_el8

# Usage: sbatch run_quast.sh <assembly.fa> <assembler_name> [0|1]
#   3rd argument: 0 = without reference (default), 1 = with reference
ASM=$(realpath "$1")
ASSEMBLER=$2
USE_REF_GENOME=${3:-0}

WORKDIR=/data/users/mmeka/assembly_annotation_course
COURSE=/data/courses/assembly-annotation-course
FASTQ_FILE=$WORKDIR/data/Nov-02/ERR11437321.fastq.gz
FEATURES_PATH=$COURSE/references/TAIR10_GFF3_genes.gff
REF_GENOME=$COURSE/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz
CONTAINER=/containers/apptainer/quast_5.2.0.sif

cd "$WORKDIR"

if [ "$USE_REF_GENOME" -eq 0 ]; then
    OUTDIR=$WORKDIR/results/Assemblies_QC/QUAST/${ASSEMBLER}/no_ref
    OPTS=(--est-ref-size 161758467)
else
    OUTDIR=$WORKDIR/results/Assemblies_QC/QUAST/${ASSEMBLER}/with_ref
    OPTS=(-r "$REF_GENOME" --features "$FEATURES_PATH")
fi

mkdir -p "$OUTDIR"

apptainer exec \
    --bind $WORKDIR \
    --bind $COURSE \
    "$CONTAINER" \
    quast.py "$ASM" \
        --output-dir "$OUTDIR" \
        --threads "$SLURM_CPUS_PER_TASK" \
        --eukaryote \
        --labels "$ASSEMBLER" \
        --pacbio "$FASTQ_FILE" \
        "${OPTS[@]}"