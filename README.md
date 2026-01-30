# STCC - Unix Basics for Bioinformatics

**Course Documentation by Eric Johnson**

This repository documents Unix command-line concepts and tools learned during the Short-Term Course on Unix (STCC). It focuses on file system navigation, command chaining, and practical use-cases relevant to bioinformatics workflows.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Lecture 1: Reproducible and Robust Research](#lecture-1-reproducible-and-robust-research)
3. [Lecture 2: File Management and Streaming](#lecture-2-file-management-and-streaming)
4. [Lecture 3: Text Processing and Analysis](#lecture-3-text-processing-and-analysis)
5. [Lecture 4: Version Control with Git](#lecture-4-version-control-with-git)
6. [Practical Examples with Course Data](#practical-examples-with-course-data)
7. [Key Takeaways](#key-takeaways)

---

## Introduction

Unix is a foundational skill for bioinformaticians. This course covered essential command-line operations, data streaming, text processing, and version control - all critical for biological data analysis pipelines.

**Learning Objectives:**
- Navigate Unix file systems confidently
- Execute and chain commands relevant to biological data analysis
- Understand how Unix fits into bioinformatics pipelines
- Use GitHub as a professional learning and collaboration space

---

## Lecture 1: Reproducible and Robust Research

### Why Reproducibility and Robustness Matter

In genomic data analysis, ensuring that research can be reproduced and withstands scrutiny is crucial for scientific validity.

### Reproducible Research Principles

**Key Components:**
- **Share code and data**: Make your analysis pipeline accessible
- **Document everything**: Software versions, data versions, metadata
- **Proper project planning**: Decide software tools, pipeline runners, workflows upfront
- **Detailed documentation**: Every step should be traceable

### Robust Research Practices

**Code Quality Standards:**
- **Commenting**: Explain why code does what it does
- **Readability**: Use clear variable names and formatting
- **Modularity**: Break code into reusable functions
- **Automation**: Define functions for repetitive tasks
- **Consistent naming**: Use standardized file naming conventions
- **Unit testing**: "Let the code test the code"

### Best Practices

```bash
# Example: Consistent file naming convention
sample_01_raw.fastq
sample_01_trimmed.fastq
sample_01_aligned.bam
sample_01_sorted.bam
```

**Golden Rules:**
1. Treat data as read-only (never modify original files directly)
2. Develop frequently used scripts as reusable tools
3. Use code as documentation (README = wet-lab manual)
4. Test rigorously to ensure quality and prevent bugs

---

## Lecture 2: File Management and Streaming

### Creating Multiple Files at Once

Unix allows efficient batch file creation using brace expansion:

```bash
# Create multiple files at once
touch file_{1..5}.txt
# Creates: file_1.txt, file_2.txt, file_3.txt, file_4.txt, file_5.txt

# Create files with different extensions
touch sample_{A,B,C}.{fasta,fastq}
# Creates: sample_A.fasta, sample_A.fastq, sample_B.fasta, etc.
```

### File Subsetting with Wildcards

```bash
# List all FASTA files
ls *.fasta

# List files matching specific pattern
ls tb1*.fasta

# Use brackets for character ranges
ls file_[1-3].txt
```

### Streaming

**What is Streaming?**

A stream is a flow of data (sequence of bytes) from a source to a destination, providing a universal interface for input/output operations.

**Why Streaming Matters in Bioinformatics:**

Bioinformatics files are often massive (GB to TB). Streaming allows viewing file contents without loading everything into memory.

```bash
# View FASTA file contents without loading into memory
cat fasta_files/tb1.fasta

# View protein sequences
cat fasta_files/tb1-protein.fasta
cat fasta_files/tga1-protein.fasta

# Stream large FASTQ files
cat unix_data_tools/SRR7695235-001.fastq | head -20
```

### Redirection

Redirection controls where command inputs and outputs go.

**Common Redirection Operators:**

| Operator | Function |
|----------|----------|
| `>` | Redirects output (overwrites file) |
| `>>` | Redirects and appends output |
| `2>` | Redirects error messages |
| `&>` | Redirects both output and errors |

```bash
# Save output to file (overwrite)
cat fasta_files/tb1.fasta > output.txt

# Append to existing file
echo "Additional sequence" >> output.txt

# Redirect errors to file
command_that_fails 2> errors.log

# Redirect both output and errors
command &> all_output.log
```

### Pipes

A pipe (`|`) takes the output of one command as input to another, displaying only the final output.

```bash
# Example with protein sequences
cat fasta_files/tga1-protein.fasta | grep ">" | wc -l
# This counts the number of sequences (headers) in the FASTA file

# Remove headers and search for specific amino acids
cat fasta_files/tga1-protein.fasta | grep -v "^>" | grep --color "[^GPSTVEF]"
# Highlights amino acids NOT in the set G,P,S,T,V,E,F
```

**Practical Bioinformatics Example:**

```bash
# Count reads in FASTQ file (every 4th line)
cat unix_data_tools/SRR7695235-001.fastq | wc -l | awk '{print $1/4}'

# Extract quality scores
cat unix_data_tools/SRR7695235-001.fastq | sed -n '4~4p' | head
```

---

## Lecture 3: Text Processing and Analysis

### Word Count (wc)

The `wc` command provides line, word, and character counts.

```bash
# Basic word count
wc fasta_files/tb1.fasta
# Output: lines words characters filename

# Count only lines
wc -l fasta_files/tb1.fasta

# Count only words
wc -w fasta_files/tb1.fasta

# Count only characters
wc -c fasta_files/tb1.fasta
```

### Working with GTF Files

GTF (Gene Transfer Format) files contain genomic annotations.

```bash
# View GTF file structure
head unix_data_tools/Mus_musculus.GRCm39.115.chr.gtf

# Count entries for a specific gene
grep 'gene_id "ENSMUSG00000000001"' unix_data_tools/Mus_musculus.GRCm39.115.chr.gtf | wc -l

# Extract all gene IDs
grep -o 'gene_id "[^"]*"' unix_data_tools/Mus_musculus.GRCm39.115.chr.gtf | sort -u
```

### Advanced Text Processing

```bash
# Find all exon entries
grep 'exon' unix_data_tools/Mus_musculus.GRCm39.115.chr.gtf | head

# Count genes on chromosome 1
grep '^1\s' unix_data_tools/Mus_musculus.GRCm39.115.chr.gtf | grep 'gene' | wc -l

# Extract transcript IDs
grep -o 'transcript_id "[^"]*"' unix_data_tools/Mus_musculus.GRCm39.115.chr.gtf | sort -u | head
```

### Working with FASTA Files

```bash
# Count sequences in FASTA file
grep -c "^>" fasta_files/tb1.fasta

# Extract sequence IDs
grep "^>" fasta_files/tb1.fasta

# Get sequence lengths (excluding header)
grep -v "^>" fasta_files/tb1.fasta | awk '{count += length($0)} END {print count}'

# Extract specific sequence
grep -A 1 "sequence_id" fasta_files/tb1.fasta
```

### Working with FASTQ Files

```bash
# Count total reads
echo $(cat unix_data_tools/SRR7695235-001.fastq | wc -l) / 4 | bc

# Extract sequence IDs
sed -n '1~4p' unix_data_tools/SRR7695235-001.fastq | head

# Extract sequences only
sed -n '2~4p' unix_data_tools/SRR7695235-001.fastq | head

# Calculate average read length
sed -n '2~4p' unix_data_tools/SRR7695235-001.fastq | awk '{sum += length($0); count++} END {print sum/count}'
```

### Useful Commands for Bioinformatics

```bash
# Sort and find unique entries
cat fasta_files/tb1.fasta | grep "^>" | sort | uniq

# Case-insensitive search
grep -i "ATCG" fasta_files/tb1.fasta

# Count pattern occurrences
grep -o "ATG" fasta_files/tb1.fasta | wc -l

# Search multiple files
grep "gene" unix_data_tools/*.gtf

# Display with line numbers
cat -n fasta_files/tb1.fasta | head
```

---

## Lecture 4: Version Control with Git

### Why Git for Bioinformatics?

- Track changes in analysis scripts
- Collaborate with team members
- Maintain project history
- Backup and version control for pipelines

### Initial Git Setup

```bash
# Configure Git with your details
git config --global user.name "ericjohnsonps2000"
git config --global user.email "ericjohnsonps2000@gmail.com"

# Verify configuration
git config --list
```

### SSH Key Generation

```bash
# Generate SSH key for GitHub authentication
ssh-keygen -t rsa -b 4096 -C "ericjohnsonps2000@gmail.com"

# Press Enter to accept default location (~/.ssh/id_rsa)
# Press Enter twice for no passphrase (or add one for security)

# View your public key
cat ~/.ssh/id_rsa.pub
# Copy this key and add it to GitHub: Settings > SSH and GPG keys
```

**⚠️ Security Note:** Never share `id_rsa` (private key). Only share `id_rsa.pub` (public key).

### Basic Git Workflow

```bash
# Initialize repository
git init

# Check status
git status

# Stage files for commit
git add filename
git add .  # Add all files

# Commit changes with message
git commit -m "Initial commit: Add Unix course documentation"

# View commit history
git log

# View differences
git diff
```

### Working with Branches

```bash
# Create new branch
git branch analysis-pipeline

# Switch to branch
git checkout analysis-pipeline

# Create and switch in one command
git checkout -b new-feature

# List all branches
git branch

# Merge branch into main
git checkout main
git merge analysis-pipeline
```

### Undoing Changes

```bash
# Restore file to last committed version
git restore filename

# Unstage a file (keep changes)
git restore --staged filename

# Delete tracked file
git rm -f filename

# Rename file
git mv old_name.txt new_name.txt
```

### Using .gitignore

```bash
# Create .gitignore file
touch .gitignore

# Add files/patterns to ignore
echo "*.fastq" >> .gitignore
echo "large_data/" >> .gitignore
echo "*.bam" >> .gitignore
echo ".DS_Store" >> .gitignore

# Stage and commit .gitignore
git add .gitignore
git commit -m "Add .gitignore for large data files"
```

**Common Bioinformatics .gitignore patterns:**
```
# Large data files
*.fastq
*.fastq.gz
*.bam
*.sam
*.vcf.gz

# Temporary files
*.tmp
*.log
.DS_Store

# Reference databases
reference_genomes/
blast_db/
```

### Connecting to GitHub

```bash
# Add remote repository
git remote add origin https://github.com/ericjohnsonps2000/Unix-Basics-Bioinformatics-STCC.git

# Verify remote
git remote -v

# Push to GitHub (first time)
git branch -M main
git push -u origin main

# Push subsequent changes
git push origin main
```

### Pulling from GitHub

```bash
# Pull latest changes
git pull origin main

# Clone repository
git clone https://github.com/ericjohnsonps2000/Unix-Basics-Bioinformatics-STCC.git
```

### Collaborative Workflow

```bash
# Before starting work, pull latest changes
git pull origin main

# Create feature branch
git checkout -b add-quality-control

# Make changes and commit
git add .
git commit -m "Add quality control script"

# Push branch to GitHub
git push origin add-quality-control

# Create Pull Request on GitHub for review
```

---

## Practical Examples with Course Data

### Example 1: Analyzing FASTA Files

```bash
# Count sequences in each FASTA file
echo "tb1.fasta:"
grep -c "^>" fasta_files/tb1.fasta

echo "tb1-protein.fasta:"
grep -c "^>" fasta_files/tb1-protein.fasta

echo "tga1-protein.fasta:"
grep -c "^>" fasta_files/tga1-protein.fasta
```

### Example 2: Exploring GTF Annotations

```bash
# Extract feature types
cut -f3 unix_data_tools/Mus_musculus.GRCm39.115.chr.gtf | sort | uniq -c

# Find genes on specific chromosome
grep '^2\s' unix_data_tools/Mus_musculus.GRCm39.115.chr.gtf | grep 'gene' | wc -l

# Extract gene names
grep 'gene_name' unix_data_tools/Mus_musculus.GRCm39.115.chr.gtf | \
  grep -o 'gene_name "[^"]*"' | sort -u | head -20
```

### Example 3: FASTQ Quality Assessment

```bash
# Count reads
echo "Total reads:"
cat unix_data_tools/SRR7695235-001.fastq | wc -l | awk '{print $1/4}'

# Get average sequence length
echo "Average read length:"
sed -n '2~4p' unix_data_tools/SRR7695235-001.fastq | \
  awk '{sum += length($0); count++} END {print sum/count}'

# Check for adapter contamination (example)
grep -c "AGATCGGAAGAG" unix_data_tools/SRR7695235-001.fastq
```

### Example 4: Working with cDNA Sequences

```bash
# Count transcripts
grep -c "^>" unix_data_tools/Mus_musculus.GRCm39.cdna.all.fa

# Extract transcript IDs
grep "^>" unix_data_tools/Mus_musculus.GRCm39.cdna.all.fa | head

# Find specific gene transcripts
grep "Gapdh" unix_data_tools/Mus_musculus.GRCm39.cdna.all.fa
```

### Example 5: Combining Multiple Operations

```bash
# Create analysis summary
echo "=== Analysis Summary ===" > summary.txt
echo "Date: $(date)" >> summary.txt
echo "" >> summary.txt

echo "FASTA Files:" >> summary.txt
echo "  tb1.fasta sequences: $(grep -c '^>' fasta_files/tb1.fasta)" >> summary.txt
echo "  tb1-protein sequences: $(grep -c '^>' fasta_files/tb1-protein.fasta)" >> summary.txt
echo "  tga1-protein sequences: $(grep -c '^>' fasta_files/tga1-protein.fasta)" >> summary.txt
echo "" >> summary.txt

echo "GTF Annotations:" >> summary.txt
echo "  Total lines: $(wc -l < unix_data_tools/Mus_musculus.GRCm39.115.chr.gtf)" >> summary.txt
echo "" >> summary.txt

echo "FASTQ Data:" >> summary.txt
echo "  Total reads: $(cat unix_data_tools/SRR7695235-001.fastq | wc -l | awk '{print $1/4}')" >> summary.txt

cat summary.txt
```

---

## Key Takeaways

### Essential Unix Commands for Bioinformatics

| Command | Purpose | Example |
|---------|---------|---------|
| `cat` | View file contents | `cat tb1.fasta` |
| `grep` | Search patterns | `grep "^>" tb1.fasta` |
| `wc` | Count lines/words | `wc -l file.txt` |
| `head/tail` | View file start/end | `head -20 file.fastq` |
| `sed` | Stream editor | `sed -n '2~4p' file.fastq` |
| `awk` | Text processing | `awk '{print $1}' file.txt` |
| `sort` | Sort lines | `sort file.txt` |
| `uniq` | Remove duplicates | `sort file.txt \| uniq` |
| `cut` | Extract columns | `cut -f1,3 file.tsv` |
| `\|` (pipe) | Chain commands | `cat file \| grep pattern` |

### Git Commands for Version Control

| Command | Purpose |
|---------|---------|
| `git init` | Initialize repository |
| `git add` | Stage changes |
| `git commit` | Save changes |
| `git push` | Upload to GitHub |
| `git pull` | Download from GitHub |
| `git status` | Check repository state |
| `git log` | View commit history |
| `git diff` | Show changes |

### Best Practices Learned

1. **Always document your work** - Future you will thank present you
2. **Use version control** - Track every change, collaborate safely
3. **Write modular code** - Break complex tasks into functions
4. **Test your code** - Unit tests prevent bugs in production
5. **Treat data as read-only** - Never modify original data files
6. **Use meaningful names** - Files, variables, commits should be descriptive
7. **Comment your code** - Explain the "why", not just the "what"
8. **Automate repetitive tasks** - Write scripts for common workflows

### Unix in Bioinformatics Pipelines

Unix forms the backbone of bioinformatics workflows:

```bash
# Example: Simple RNA-seq QC pipeline
fastqc sample.fastq                          # Quality control
trim_galore sample.fastq                      # Adapter trimming
STAR --readFilesIn trimmed.fastq ...          # Alignment
featureCounts -a genes.gtf aligned.bam        # Quantification
```

Each step uses Unix commands, pipes, and redirection to create reproducible, automated pipelines.

---

## Conclusion

This course provided foundational Unix skills essential for bioinformatics:

- **File manipulation** - Navigate, create, modify files efficiently
- **Data streaming** - Handle large genomic files without memory constraints
- **Text processing** - Extract, filter, transform biological data
- **Version control** - Track changes and collaborate effectively

These skills are non-negotiable for modern bioinformatics work and form the basis for more advanced computational biology techniques.

---

## Repository Information

**Course:** Short-Term Course on Unix (STCC)  
**Institution:** Bversity School of Bioscience  
**Created by:** Eric Johnson  
**GitHub:** [@ericjohnsonps2000](https://github.com/ericjohnsonps2000)  
**Date:** January 2026

**Data Files Used:**
- `fasta_files/tb1.fasta` - DNA sequences
- `fasta_files/tb1-protein.fasta` - Protein sequences
- `fasta_files/tga1-protein.fasta` - Protein sequences
- `unix_data_tools/Mus_musculus.GRCm39.115.chr.gtf` - Mouse genome annotations
- `unix_data_tools/Mus_musculus.GRCm39.cdna.all.fa` - Mouse cDNA sequences
- `unix_data_tools/SRR7695235-001.fastq` - RNA-seq reads

---

**License:** This documentation is for educational purposes as part of the STCC Unix course.

**Acknowledgments:** Course instructors and reference materials from STCC Unix Basics for Bioinformatics.
