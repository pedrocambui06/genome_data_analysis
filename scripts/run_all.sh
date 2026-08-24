#!/usr/bin/env bash
# ============================================================================
# Runs the entire pipeline end to end, in order.
# Make sure your conda environment is active first:
#   conda activate qiime2-amplicon-2024.10
# ============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "${SCRIPT_DIR}/01_download_data.sh"
bash "${SCRIPT_DIR}/02_import_and_demux.sh"
bash "${SCRIPT_DIR}/03_denoise_dada2.sh"
bash "${SCRIPT_DIR}/04_phylogeny.sh"
bash "${SCRIPT_DIR}/05_diversity_analysis.sh"
bash "${SCRIPT_DIR}/06_taxonomy.sh"
bash "${SCRIPT_DIR}/07_differential_abundance.sh"

echo ""
echo "=================================================================="
echo " Pipeline complete! All outputs are in the data/ directory."
echo " Open .qzv files at https://view.qiime2.org or with 'qiime tools view'"
echo "=================================================================="
