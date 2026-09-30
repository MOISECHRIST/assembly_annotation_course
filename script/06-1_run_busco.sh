#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --job-name=run_busco
#SBATCH --mail-user=moise.meka@students.unibe.ch
#SBATCH --mail-type=start,end,fail
#SBATCH --output=/data/users/mmeka/assembly_annotation_course/.log/output/%x_%j.o
#SBATCH --error=/data/users/mmeka/assembly_annotation_course/.log/error/%x_%j.e
#SBATCH --partition=pshort_el8

INPUT_SEQ=$1
ASSEMBLER=$2
MODE=${3:-"genome"}
THREADS=$SLURM_CPUS_PER_TASK
OUTDIR="results/Assemblies_QC/BUSCO/${ASSEMBLER}"
CONTAINER="/containers/apptainer/busco_5.7.1.sif"
WORKDIR=/data/users/mmeka/assembly_annotation_course

apptainer exec \
--bind $WORKDIR \
"$CONTAINER" \
    busco --in "$INPUT_SEQ" --mode "$MODE"  \
        -l brassicales_odb10 --cpu "$THREADS" \
        --out "$OUTDIR"

