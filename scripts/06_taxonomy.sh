#!/usr/bin/env bash
# ============================================================================
# Step 6 — Taxonomic classification and composition bar plots
# ============================================================================
# Uses a pre-trained Naive Bayes classifier (Greengenes 13_8, trimmed to the
# V4 region / 515F-806R primers) provided by the QIIME 2 team.
# ============================================================================
set -e

DATA_DIR="data"
CLASSIFIER="${DATA_DIR}/gg-13-8-99-515-806-nb-classifier.qza"

echo ">>> Downloading pre-trained Greengenes 16S classifier (this file is large, ~100MB)..."
wget -O "${CLASSIFIER}" \
  "https://data.qiime2.org/classifiers/sklearn-1.4.2/greengenes/gg-13-8-99-515-806-nb-classifier.qza"

echo ">>> Classifying representative sequences..."
qiime feature-classifier classify-sklearn \
  --i-classifier "${CLASSIFIER}" \
  --i-reads "${DATA_DIR}/rep-seqs.qza" \
  --o-classification "${DATA_DIR}/taxonomy.qza"

qiime metadata tabulate \
  --m-input-file "${DATA_DIR}/taxonomy.qza" \
  --o-visualization "${DATA_DIR}/taxonomy.qzv"

echo ">>> Generating interactive taxa bar plots..."
qiime taxa barplot \
  --i-table "${DATA_DIR}/table.qza" \
  --i-taxonomy "${DATA_DIR}/taxonomy.qza" \
  --m-metadata-file "${DATA_DIR}/sample-metadata.tsv" \
  --o-visualization "${DATA_DIR}/taxa-bar-plots.qzv"

echo ">>> Done. See ${DATA_DIR}/taxonomy.qzv and ${DATA_DIR}/taxa-bar-plots.qzv"
