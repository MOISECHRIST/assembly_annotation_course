#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=04:00:00
#SBATCH --job-name=k-mer_counting
#SBATCH --mail-user=moise.meka@students.unibe.ch
#SBATCH --mail-type=start,end,fail
#SBATCH --output=/data/users/mmeka/assembly_annotation_course/.log/output/%x_%j.o
#SBATCH --error=/data/users/mmeka/assembly_annotation_course/.log/error/%x_%j.e
#SBATCH --partition=pibu_el8

THREADS=$SLURM_CPUS_PER_TASK
WORKDIR=/data/users/mmeka/assembly_annotation_course
OUTDIR=results/reads_QC/jellyfish
FILE=$1
if [ -z "$FILE" ]; then
    echo "ERROR : Input file not provided"
    echo "USAGE : $0 /path/to/read.jf"
    exit 1
fi


mkdir -p "${OUTDIR}"


SAMPLE_NAME=$(basename "${FILE}" | cut -d "." -f1) #With the hypothesis : read1 fastq file = <sample name>.jf
apptainer exec --bind "$WORKDIR:/workdir" --pwd /workdir /containers/apptainer/jellyfish-2.2.6--0.sif \
    jellyfish histo -t "${THREADS}" "${FILE}" > "${OUTDIR}/${SAMPLE_NAME}.histo"
