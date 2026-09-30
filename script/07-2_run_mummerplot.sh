#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --job-name=run_mummerplot
#SBATCH --mail-user=moise.meka@students.unibe.ch
#SBATCH --mail-type=start,end,fail
#SBATCH --output=/data/users/mmeka/assembly_annotation_course/.log/output/%x_%j.o
#SBATCH --error=/data/users/mmeka/assembly_annotation_course/.log/error/%x_%j.e
#SBATCH --partition=pshort_el8

# Usage: sbatch 07-2_run_mummerplot.sh <ref.fa> <query.fa> <prefix>
REF=$(realpath "$1")
QUERY=$(realpath "$2")
PREFIX=$3
WORKDIR=/data/users/mmeka/assembly_annotation_course
OUTDIR=$WORKDIR/results/Genome_comparison
CONTAINER=/containers/apptainer/mummer4_gnuplot.sif

cd "$OUTDIR"

apptainer exec \
    --bind $WORKDIR \
    --bind /data/courses/assembly-annotation-course \
    "$CONTAINER" \
    mummerplot --prefix "$PREFIX" \
               -R "$REF" -Q "$QUERY" \
               --filter --layout --fat --large \
               -t png \
               "${PREFIX}.delta"