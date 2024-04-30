#!/bin/bash
#SBATCH --job-name=st_start
#SBATCH --output=/home/zhang.7824/U-Statistic-Reduction/output/data_st_start.txt
#SBATCH --error=/home/zhang.7824/U-Statistic-Reduction/output/data_st_start.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=10 --mem=5gb
#SBATCH --partition=batch8
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/zhang.7824/U-Statistic-Reduction/data/starlight_earthquake/package
module load matlab
matlab -nodesktop -r "earthquake_plot;  confi_starlight_plot"
