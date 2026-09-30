#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --job-name=run_nucmer
#SBATCH --mail-user=moise.meka@students.unibe.ch
#SBATCH --mail-type=start,end,fail
#SBATCH --output=/data/users/mmeka/assembly_annotation_course/.log/output/%x_%j.o
#SBATCH --error=/data/users/mmeka/assembly_annotation_course/.log/error/%x_%j.e
#SBATCH --partition=pshort_el8

# Usage: sbatch 07-1_run_nucmer.sh <ref.fa> <query.fa> <prefix>
REF=$(realpath "$1")
QUERY=$(realpath "$2")
PREFIX=$3
WORKDIR=/data/users/mmeka/assembly_annotation_course
OUTDIR=$WORKDIR/results/Genome_comparison
CONTAINER=/containers/apptainer/mummer4_gnuplot.sif

mkdir -p "$OUTDIR"
cd "$OUTDIR"

apptainer exec \
    --bind $WORKDIR \
    --bind /data/courses/assembly-annotation-course \
    "$CONTAINER" \
    nucmer --prefix "$PREFIX" \
           --breaklen 1000 \
           --mincluster 1000 \
           --threads $SLURM_CPUS_PER_TASK \
           "$REF" "$QUERY"