#!/bin/bash

# ==============================
# Remote BLAST per FASTA (resumable & throttle-friendly)
# ==============================

# Output folder
mkdir -p blast_results

# Loop over all FASTA files
for fasta in fasta_files/*.fasta
do
    # Skip if no files match
    [ -e "$fasta" ] || { echo "No FASTA files found in fasta_files/"; break; }

    base=$(basename "$fasta" .fasta)
    output_file="blast_results/${base}_nt.out"

    # Skip files that already have results
    if [ -f "$output_file" ]; then
        echo "Skipping ${base}.fasta — results already exist."
        continue
    fi

    echo "Running remote BLAST for ${base}.fasta ..."

    # Run remote blastn for all sequences in this FASTA
    blastn -query "$fasta" -db nt -remote -out "$output_file" \
        -max_target_seqs 5 -evalue 500 -perc_identity 97 -outfmt '6 qseqid sseqid evalue pident bitscore sacc staxids sscinames scomnames stitle qlen slen'

    echo "Finished ${base}.fasta → $output_file"

    # Pause 5 seconds between files to avoid overloading NCBI
    sleep 5
done

echo "All remote BLAST jobs completed."

