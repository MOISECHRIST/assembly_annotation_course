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
OUTDIR=results/reads_QC/jellyfish
WORKDIR=/data/users/mmeka/assembly_annotation_course
R1=$1
R2=$2
if [ -z "$R1" ]; then
    echo "ERROR : Input file not provided"
    echo "USAGE : $0 /path/to/r1_fastq.gz [/path/to/r2_fastq.gz]"
    exit 1
fi


mkdir -p "${OUTDIR}"

if [ -z "$R2" ]; then 
    SAMPLE_NAME=$(basename "$R1" | cut -d "." -f1) #With the hypothesis : read1 fastq file = <sample name>.fastq.gz
    apptainer exec --bind "$WORKDIR:/workdir" --pwd /workdir /containers/apptainer/jellyfish-2.2.6--0.sif \
    jellyfish count -C -m 21 -s 5G -t "${THREADS}" -o "${OUTDIR}/${SAMPLE_NAME}.jf" \
        <(zcat "${R1}")
else 
    SAMPLE_NAME=$(basename "$R1" | cut -d "_" -f1) #With the hypothesis : read1 fastq file = <sample name>_1.fastq.gz or <sample name>_R1.fastq.gz
    apptainer exec --bind "$WORKDIR:/workdir" --pwd /workdir /containers/apptainer/jellyfish-2.2.6--0.sif \
    jellyfish count -C -m 21 -s 5G -t "${THREADS}" -o "${OUTDIR}/${SAMPLE_NAME}.jf" \
        <(zcat "${R1}") \
        <(zcat "${R2}")
fi
