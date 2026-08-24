#!/usr/bin/env bash
# ============================================================================
# Step 4 — Build a phylogenetic tree for phylogenetic diversity metrics
# ============================================================================
# Pipeline: MAFFT multiple sequence alignment -> mask highly variable
# positions -> FastTree -> midpoint rooting.
# ============================================================================
set -e

DATA_DIR="data"

echo ">>> Building phylogenetic tree (align-to-tree-mafft-fasttree)..."
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences "${DATA_DIR}/rep-seqs.qza" \
  --o-alignment "${DATA_DIR}/aligned-rep-seqs.qza" \
  --o-masked-alignment "${DATA_DIR}/masked-aligned-rep-seqs.qza" \
  --o-tree "${DATA_DIR}/unrooted-tree.qza" \
  --o-rooted-tree "${DATA_DIR}/rooted-tree.qza"

echo ">>> Done. Rooted tree available at ${DATA_DIR}/rooted-tree.qza"
