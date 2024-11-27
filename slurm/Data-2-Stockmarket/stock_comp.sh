#!/bin/bash
#SBATCH --job-name=stock_c1.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/stock_comp.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/stock_comp.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=5 --mem=5gb
#SBATCH --partition=stat
#SBATCH --qos=normal


cd /home/Magpie/U-Statistic-Reduction/data/stock_market
module load matlab
matlab -nodesktop -r "data_analysis_comp"