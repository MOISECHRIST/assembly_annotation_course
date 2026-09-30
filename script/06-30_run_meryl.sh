#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --job-name=run_meryl
#SBATCH --mail-user=moise.meka@students.unibe.ch
#SBATCH --mail-type=start,end,fail
#SBATCH --output=/data/users/mmeka/assembly_annotation_course/.log/output/%x_%j.o
#SBATCH --error=/data/users/mmeka/assembly_annotation_course/.log/error/%x_%j.e
#SBATCH --partition=pshort_el8

# Usage: sbatch run_meryl.sh <reads.fastq.gz> <k>
READS=$(realpath "$1")
K=$2
WORKDIR=/data/users/mmeka/assembly_annotation_course
OUTDIR=$WORKDIR/results/Assemblies_QC/merqury
CONTAINER=/containers/apptainer/merqury_1.3.sif

mkdir -p "$OUTDIR"
cd "$OUTDIR"

apptainer exec --bind $WORKDIR "$CONTAINER" \
    meryl k=$K threads=$SLURM_CPUS_PER_TASK memory=60 count output reads.meryl "$READS"