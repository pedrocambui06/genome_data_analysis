#!/usr/bin/env bash
# ============================================================================
# Step 5 — Alpha & beta diversity analysis
# ============================================================================
# NOTE: --p-sampling-depth 1103 is the value used in the official tutorial
# for THIS dataset, chosen by inspecting the "Interactive Sample Detail" tab
# in table.qzv (it keeps as many samples as possible while rarefying to an
# even depth). If you're running this on your own data, re-check table.qzv
# and choose an appropriate value for your samples.
# ============================================================================
set -e

DATA_DIR="data"
SAMPLING_DEPTH=1103

echo ">>> Computing core diversity metrics (alpha + beta + PCoA)..."
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny "${DATA_DIR}/rooted-tree.qza" \
  --i-table "${DATA_DIR}/table.qza" \
  --p-sampling-depth ${SAMPLING_DEPTH} \
  --m-metadata-file "${DATA_DIR}/sample-metadata.tsv" \
  --output-dir "${DATA_DIR}/core-metrics-results"

echo ">>> Testing alpha diversity group significance (Faith's PD & evenness)..."
qiime diversity alpha-group-significance \
  --i-alpha-diversity "${DATA_DIR}/core-metrics-results/faith_pd_vector.qza" \
  --m-metadata-file "${DATA_DIR}/sample-metadata.tsv" \
  --o-visualization "${DATA_DIR}/core-metrics-results/faith-pd-group-significance.qzv"

qiime diversity alpha-group-significance \
  --i-alpha-diversity "${DATA_DIR}/core-metrics-results/evenness_vector.qza" \
  --m-metadata-file "${DATA_DIR}/sample-metadata.tsv" \
  --o-visualization "${DATA_DIR}/core-metrics-results/evenness-group-significance.qzv"

echo ">>> Testing beta diversity group significance (PERMANOVA, unweighted UniFrac)..."
qiime diversity beta-group-significance \
  --i-distance-matrix "${DATA_DIR}/core-metrics-results/unweighted_unifrac_distance_matrix.qza" \
  --m-metadata-file "${DATA_DIR}/sample-metadata.tsv" \
  --m-metadata-column body-site \
  --o-visualization "${DATA_DIR}/core-metrics-results/unweighted-unifrac-body-site-significance.qzv" \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix "${DATA_DIR}/core-metrics-results/unweighted_unifrac_distance_matrix.qza" \
  --m-metadata-file "${DATA_DIR}/sample-metadata.tsv" \
  --m-metadata-column subject \
  --o-visualization "${DATA_DIR}/core-metrics-results/unweighted-unifrac-subject-group-significance.qzv" \
  --p-pairwise

echo ">>> Generating Emperor PCoA plots with a custom time axis..."
qiime emperor plot \
  --i-pcoa "${DATA_DIR}/core-metrics-results/unweighted_unifrac_pcoa_results.qza" \
  --m-metadata-file "${DATA_DIR}/sample-metadata.tsv" \
  --p-custom-axes days-since-experiment-start \
  --o-visualization "${DATA_DIR}/core-metrics-results/unweighted-unifrac-emperor-days-since-experiment-start.qzv"

qiime emperor plot \
  --i-pcoa "${DATA_DIR}/core-metrics-results/bray_curtis_pcoa_results.qza" \
  --m-metadata-file "${DATA_DIR}/sample-metadata.tsv" \
  --p-custom-axes days-since-experiment-start \
  --o-visualization "${DATA_DIR}/core-metrics-results/bray-curtis-emperor-days-since-experiment-start.qzv"

echo ">>> Generating alpha rarefaction curves..."
qiime diversity alpha-rarefaction \
  --i-table "${DATA_DIR}/table.qza" \
  --i-phylogeny "${DATA_DIR}/rooted-tree.qza" \
  --p-max-depth 4000 \
  --m-metadata-file "${DATA_DIR}/sample-metadata.tsv" \
  --o-visualization "${DATA_DIR}/alpha-rarefaction.qzv"

echo ">>> Done. Results in ${DATA_DIR}/core-metrics-results/ and ${DATA_DIR}/alpha-rarefaction.qzv"
