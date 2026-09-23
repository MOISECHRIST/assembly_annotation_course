#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=02:00:00
#SBATCH --job-name=fastp_rnaseq
#SBATCH --mail-user=moise.meka@students.unibe.ch
#SBATCH --mail-type=start,end,fail
#SBATCH --output=/data/users/mmeka/assembly_annotation_course/.log/output/fastqc_%j.o
#SBATCH --error=/data/users/mmeka/assembly_annotation_course/.log/error/fastqc_%j.e
#SBATCH --partition=pibu_el8

THREADS=$SLURM_CPUS_PER_TASK
WORKDIR=/data/users/mmeka/assembly_annotation_course
OUTDIR=results/reads_QC/fastp/RNAseq

mkdir -p "${OUTDIR}"

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/fastp_0.23.2--h5f740d0_3.sif \
    fastp -i data/RNAseq_Sha/ERR754081_1.fastq.gz -I data/RNAseq_Sha/ERR754081_2.fastq.gz \
        -o "${OUTDIR}/ERR754081_trimmed_1.fastq.gz" -O "${OUTDIR}/ERR754081_trimmed_2.fastq.gz" \
        --unpaired1 "${OUTDIR}/ERR754081_unpaired_1.fastq.gz" --unpaired2 "${OUTDIR}/ERR754081_unpaired_2.fastq.gz"\
        --detect_adapter_for_pe --cut_front --cut_tail \
        --json "${OUTDIR}/ERR754081_report.json" --html "${OUTDIR}/ERR754081_report.html" --thread "$THREADS"
