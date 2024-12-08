#!/bin/bash
#SBATCH --job-name=plot_deter_random.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/plot_deter_random.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/plot_deter_random.txt
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=10 --mem=2gb
#SBATCH --partition=batch8
#SBATCH --qos=normal


cd /home/Magpie/U-Statistic-Reduction
module load matlab
matlab -nodesktop -r "plot_cover_comparison_deter;  plot_cover_comparison_random"