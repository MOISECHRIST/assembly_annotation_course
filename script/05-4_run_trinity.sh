#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=run_Trinity
#SBATCH --mail-user=moise.meka@students.unibe.ch
#SBATCH --mail-type=start,end,fail
#SBATCH --output=/data/users/mmeka/assembly_annotation_course/.log/output/%x_%j.o
#SBATCH --error=/data/users/mmeka/assembly_annotation_course/.log/error/%x_%j.e
#SBATCH --partition=pibu_el8

module load Trinity/2.15.1-foss-2021a

THREADS=$SLURM_CPUS_PER_TASK
MEMORY=$(echo "${SLURM_MEM_PER_NODE}/1024" | bc)
OUTDIR=results/Assemblies/trinity_out_dir
reads_1="results/reads_QC/fastp/RNAseq/ERR754081_trimmed_1.fastq.gz"
reads_2="results/reads_QC/fastp/RNAseq/ERR754081_trimmed_2.fastq.gz"

mkdir -p "$OUTDIR"

Trinity --seqType fq --left "$reads_1" --right "$reads_2" \
 --CPU "$THREADS" --max_memory "${MEMORY}G" --output "$OUTDIR"

