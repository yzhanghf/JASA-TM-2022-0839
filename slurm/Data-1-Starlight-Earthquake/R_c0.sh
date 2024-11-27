#!/bin/bash
#SBATCH --job-name=st_start
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/data_st_start.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/data_st_start.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=10 --mem=5gb
#SBATCH --partition=batch8
#SBATCH --qos=normal


cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake
module load matlab
matlab -nodesktop -r "earthquake_plot;  confi_starlight_plot"
