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

INPUT_SEQ=$1
ASSEMBLER=$2
USE_REF_GENOME=${3:-0}
FASTQ_FILE="data/Nov-02/ERR11437321.fastq.gz"
FEATURES_PATH="/data/courses/assembly-annotation-course/references/TAIR10_GFF3_genes.gff"
REF_GENOME="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz"
THREADS=$SLURM_CPUS_PER_TASK
OUTDIR="results/Assemblies_QC/QUAST/${ASSEMBLER}"
CONTAINER="/containers/apptainer/quast_5.2.0.sif"
WORKDIR=/data/users/mmeka/assembly_annotation_course

mkdir -p "$OUTDIR"

if [ "$USE_REF_GENOME" -eq 0 ]; then
    apptainer exec \
    --bind $WORKDIR \
    "$CONTAINER" \
        quast.py "$INPUT_SEQ" --output-dir "$OUTDIR" \
            --threads "$THREADS" --eukaryote --labels "Nov-02" \
            --pacbio "$FASTQ_FILE" \
            --est-ref-size 161758467
else 
    apptainer exec \
    --bind $WORKDIR \
    "$CONTAINER" \
        quast.py "$INPUT_SEQ" --output-dir "$OUTDIR" \
            --threads "$THREADS" --eukaryote --labels "Nov-02" \
            --pacbio "$FASTQ_FILE" --features "$FEATURES_PATH" \
            -r "$REF_GENOME"
fi