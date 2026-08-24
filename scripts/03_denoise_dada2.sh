#!/usr/bin/env bash
# ============================================================================
# Step 3 — Quality control & denoising with DADA2
# ============================================================================
# NOTE: --p-trim-left and --p-trunc-len below (0 and 120) match the values
# used in the official tutorial, chosen by inspecting the interactive quality
# plot in demux.qzv. If you're running this on your OWN data, re-check that
# visualization first and adjust these two parameters accordingly.
#
# This is the slowest step in the pipeline — it can take several minutes.
# ============================================================================
set -e

DATA_DIR="data"

echo ">>> Running DADA2 denoise-single (this may take a while)..."
qiime dada2 denoise-single \
  --i-demultiplexed-seqs "${DATA_DIR}/demux.qza" \
  --p-trim-left 0 \
  --p-trunc-len 120 \
  --o-representative-sequences "${DATA_DIR}/rep-seqs.qza" \
  --o-table "${DATA_DIR}/table.qza" \
  --o-denoising-stats "${DATA_DIR}/stats-dada2.qza"

echo ">>> Tabulating denoising stats..."
qiime metadata tabulate \
  --m-input-file "${DATA_DIR}/stats-dada2.qza" \
  --o-visualization "${DATA_DIR}/stats-dada2.qzv"

echo ">>> Summarizing feature table and representative sequences..."
qiime feature-table summarize \
  --i-table "${DATA_DIR}/table.qza" \
  --o-visualization "${DATA_DIR}/table.qzv" \
  --m-sample-metadata-file "${DATA_DIR}/sample-metadata.tsv"

qiime feature-table tabulate-seqs \
  --i-data "${DATA_DIR}/rep-seqs.qza" \
  --o-visualization "${DATA_DIR}/rep-seqs.qzv"

echo ">>> Done. Outputs: table.qza / rep-seqs.qza (+ .qzv summaries)."
