#!/usr/bin/env bash
# ============================================================================
# Step 7 — Differential abundance testing with ANCOM-BC (gut samples only)
# ============================================================================
set -e

DATA_DIR="data"

echo ">>> Filtering feature table to gut samples only..."
qiime feature-table filter-samples \
  --i-table "${DATA_DIR}/table.qza" \
  --m-metadata-file "${DATA_DIR}/sample-metadata.tsv" \
  --p-where "[body-site]='gut'" \
  --o-filtered-table "${DATA_DIR}/gut-table.qza"

echo ">>> Running ANCOM-BC at the feature (ASV) level, testing 'subject'..."
qiime composition ancombc \
  --i-table "${DATA_DIR}/gut-table.qza" \
  --m-metadata-file "${DATA_DIR}/sample-metadata.tsv" \
  --p-formula 'subject' \
  --o-differentials "${DATA_DIR}/ancombc-subject.qza"

qiime composition da-barplot \
  --i-data "${DATA_DIR}/ancombc-subject.qza" \
  --p-significance-threshold 0.001 \
  --o-visualization "${DATA_DIR}/da-barplot-subject.qzv"

echo ">>> Collapsing table at genus level (level 6) and re-running ANCOM-BC..."
qiime taxa collapse \
  --i-table "${DATA_DIR}/gut-table.qza" \
  --i-taxonomy "${DATA_DIR}/taxonomy.qza" \
  --p-level 6 \
  --o-collapsed-table "${DATA_DIR}/gut-table-l6.qza"

qiime composition ancombc \
  --i-table "${DATA_DIR}/gut-table-l6.qza" \
  --m-metadata-file "${DATA_DIR}/sample-metadata.tsv" \
  --p-formula 'subject' \
  --o-differentials "${DATA_DIR}/l6-ancombc-subject.qza"

qiime composition da-barplot \
  --i-data "${DATA_DIR}/l6-ancombc-subject.qza" \
  --p-significance-threshold 0.001 \
  --p-level-delimiter ';' \
  --o-visualization "${DATA_DIR}/l6-da-barplot-subject.qzv"

echo ">>> Done. See da-barplot-subject.qzv (ASV level) and l6-da-barplot-subject.qzv (genus level)."
