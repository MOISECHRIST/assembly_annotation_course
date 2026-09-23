#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=02:00:00
#SBATCH --job-name=fastp_pacbio
#SBATCH --mail-user=moise.meka@students.unibe.ch
#SBATCH --mail-type=start,end,fail
#SBATCH --output=/data/users/mmeka/assembly_annotation_course/.log/output/fastqc_%j.o
#SBATCH --error=/data/users/mmeka/assembly_annotation_course/.log/error/fastqc_%j.e
#SBATCH --partition=pibu_el8

THREADS=$SLURM_CPUS_PER_TASK
WORKDIR=/data/users/mmeka/assembly_annotation_course
OUTDIR=results/reads_QC/fastp/Nov-02

mkdir -p "${OUTDIR}"

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/fastp_0.23.2--h5f740d0_3.sif \
    fastp -i data/Nov-02/ERR11437321.fastq.gz -o "${OUTDIR}/ERR11437321.fastq.gz" \
        --disable_quality_filtering --disable_length_filtering \
        --json "${OUTDIR}/ERR11437321_report.json" --html "${OUTDIR}/ERR11437321_report.html" --thread "$THREADS"
