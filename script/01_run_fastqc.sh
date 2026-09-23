#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc
#SBATCH --mail-user=moise.meka@students.unibe.ch
#SBATCH --mail-type=start,end,fail
#SBATCH --output=/data/users/mmeka/assembly_annotation_course/.log/output/fastqc_%j.o
#SBATCH --error=/data/users/mmeka/assembly_annotation_course/.log/error/fastqc_%j.e
#SBATCH --partition=pibu_el8
#SBATCH --array=0-2

THREADS=$SLURM_CPUS_PER_TASK
OUTDIR=results/reads_QC/fastqc
WORKDIR=/data/users/mmeka/assembly_annotation_course
FASTQ_FILE_LIST=("data/Nov-02/ERR11437321.fastq.gz" "data/RNAseq_Sha/ERR754081_1.fastq.gz" "data/RNAseq_Sha/ERR754081_2.fastq.gz")

mkdir -p "${OUTDIR}"

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/fastqc-0.12.1.sif \
fastqc -t "${THREADS}" ${FASTQ_FILE_LIST[${SLURM_ARRAY_TASK_ID}]} \
    -o "${OUTDIR}"
