#!/usr/bin/env bash
# ============================================================================
# Step 1 — Download sample metadata and raw multiplexed sequencing reads
# ============================================================================
# Make sure your qiime2 conda environment is active before running this:
#   conda activate qiime2-amplicon-2024.10
# ============================================================================

set -e  # exit immediately if any command fails

DATA_DIR="data"
mkdir -p "${DATA_DIR}/emp-single-end-sequences"

echo ">>> Downloading sample metadata..."
wget -O "${DATA_DIR}/sample-metadata.tsv" \
  "https://data.qiime2.org/2024.10/tutorials/moving-pictures/sample_metadata.tsv"

echo ">>> Downloading barcodes.fastq.gz..."
wget -O "${DATA_DIR}/emp-single-end-sequences/barcodes.fastq.gz" \
  "https://data.qiime2.org/2024.10/tutorials/moving-pictures/emp-single-end-sequences/barcodes.fastq.gz"

echo ">>> Downloading sequences.fastq.gz..."
wget -O "${DATA_DIR}/emp-single-end-sequences/sequences.fastq.gz" \
  "https://data.qiime2.org/2024.10/tutorials/moving-pictures/emp-single-end-sequences/sequences.fastq.gz"

echo ">>> Done. Raw data is in ${DATA_DIR}/"
