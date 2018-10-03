#!/bin/bash
curl https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh > Anaconda3-5.3.0-Linux-x86_64.sh
chmod +x Anaconda3-5.3.0-Linux-x86_64.sh
./Anaconda3-5.3.0-Linux-x86_64.sh -b
export PATH=${PATH}:/root/anaconda3/bin
conda create --yes -n doc-build anaconda
source activate doc-build
conda install --yes sphinx_rtd_theme
pip install --upgrade pip
pip install sphinxcontrib.bibtex
