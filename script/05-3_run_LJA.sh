#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=run_LJA
#SBATCH --mail-user=moise.meka@students.unibe.ch
#SBATCH --mail-type=start,end,fail
#SBATCH --output=/data/users/mmeka/assembly_annotation_course/.log/output/fastqc_%j.o
#SBATCH --error=/data/users/mmeka/assembly_annotation_course/.log/error/fastqc_%j.e
#SBATCH --partition=pibu_el8

THREADS=$SLURM_CPUS_PER_TASK
WORKDIR=/data/users/mmeka/assembly_annotation_course
OUTDIR=results/Assemblies/LJA

mkdir -p "$OUTDIR"

apptainer exec \
    --bind $WORKDIR \
    /containers/apptainer/lja-0.2.sif \
    lja -o "$OUTDIR" --reads results/reads_QC/fastp/Nov-02/ERR11437321.fastq.gz \
    --threads "$THREADS" 