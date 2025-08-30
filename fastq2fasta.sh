#!/bin/bash

# ==============================
# Batch convert gzipped FASTQ → FASTA (seqtk-free)
# ==============================

# create output folder
mkdir -p fasta_files

# Loop over all FASTQ files in the subfolder
for fq in "wetransfer_filtered-files-for-athina_2025-07-26_0926"/*.fastq.gz
do
    # Check if any files matched the wildcard
    if [ ! -e "$fq" ]; then
        echo "No FASTQ files found in the folder."
        break
    fi

    # extract base filename (e.g. BC16_FILTERED)
    base=$(basename "$fq" .fastq.gz)

    # convert fastq → fasta using awk
    gunzip -c "$fq" | awk 'NR%4==1 {printf(">%s\n", substr($0,2)); next} NR%4==2 {print}' > fasta_files/${base}.fasta

    # print confirmation for each file
    echo "Converted ${base}.fastq.gz → fasta_files/${base}.fasta"
done

echo "All FASTQ files have been successfully converted to FASTA in ./fasta_files/"

