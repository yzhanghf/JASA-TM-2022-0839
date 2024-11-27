#!/bin/bash
#SBATCH --job-name=stock_c1.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/stock_plot_output.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/stock_plot_error.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=10 --mem=5gb
#SBATCH --partition=batch8
#SBATCH --qos=normal


cd /home/Magpie/U-Statistic-Reduction/data/stock_market
module load matlab
matlab -nodesktop -r "plot_heatmap4;  plot_heatmap_comp"