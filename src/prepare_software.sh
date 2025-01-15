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