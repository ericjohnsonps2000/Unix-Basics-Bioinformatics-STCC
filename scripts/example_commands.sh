#!/bin/bash
# Unix commands executed on bioinformatics datasets

# Count sequences in FASTA
grep -c ">" fasta_files/tb1.fasta > outputs/fasta_count.txt

# Extract sequences containing ATG in protein FASTA
grep "ATG" fasta_files/tb1-protein.fasta > outputs/sequences_with_ATG.txt

# Extract columns from GTF
grep -v "^#" unix_data_tools/Mus_musculus.GRCm39.115.chr.gtf | cut -f1,3 > outputs/gtf_columns.txt

# List files in FASTA folder
ls -l fasta_files > outputs/file_list.txt


