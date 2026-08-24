#!/usr/bin/env bash
# ============================================================================
# Step 2 — Import raw reads into a QIIME 2 artifact, then demultiplex
# ============================================================================
set -e

DATA_DIR="data"

echo ">>> Importing multiplexed EMP single-end sequences..."
qiime tools import \
  --type EMPSingleEndSequences \
  --input-path "${DATA_DIR}/emp-single-end-sequences" \
  --output-path "${DATA_DIR}/emp-single-end-sequences.qza"

echo ">>> Sanity check: peek at the imported artifact"
qiime tools peek "${DATA_DIR}/emp-single-end-sequences.qza"

echo ">>> Demultiplexing sequences by sample (using barcode-sequence column)..."
qiime demux emp-single \
  --i-seqs "${DATA_DIR}/emp-single-end-sequences.qza" \
  --m-barcodes-file "${DATA_DIR}/sample-metadata.tsv" \
  --m-barcodes-column barcode-sequence \
  --o-per-sample-sequences "${DATA_DIR}/demux.qza" \
  --o-error-correction-details "${DATA_DIR}/demux-details.qza"

echo ">>> Generating demultiplexing summary visualization..."
qiime demux summarize \
  --i-data "${DATA_DIR}/demux.qza" \
  --o-visualization "${DATA_DIR}/demux.qzv"

echo ">>> Done. Inspect ${DATA_DIR}/demux.qzv (see README > Viewing Results) before choosing"
echo "    truncation/trim parameters for the next step (DADA2)."
