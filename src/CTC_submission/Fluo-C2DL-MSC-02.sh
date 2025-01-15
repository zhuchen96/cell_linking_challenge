#!/bin/bash
set -e 
# deactivate virtualenv if already active 
if command -v conda deactivate > /dev/null; then conda deactivate; fi 

if conda info --envs | grep -q "^samcetra "; then 
    echo "Virtual environment 'samcetra' already exists, skipping creation."
    conda activate samcetra
else
    echo "Creating virtual environment 'samcetra'..."
    conda create -n samcetra python=3.10  
    # Activate the new environment
    conda activate samcetra
    echo "Installing dependencies..."
    if [ -f requirements.txt ]; then
        pip install -r requirements.txt
    else
        echo "requirements.txt not found, skipping dependency installation."
    fi
fi
echo "Environment activated: $CONDA_PREFIX"

# Run the linking algorithm samcetra with eight input parameters:
# input_sequence mask_sequence output_sequence 2d_or_3d window_size dis_threshold neighbor_dist pretrained_model-required_by_3d_mask_generation_mode 
./samcetra.sh "../Fluo-C2DL-MSC/02" "../Fluo-C2DL-MSC/02_ERR_SEG" "../Fluo-C2DL-MSC/02_RES" "2d" 512 120 50 ""

set +e

