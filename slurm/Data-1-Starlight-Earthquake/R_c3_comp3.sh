#!/bin/bash
#SBATCH --job-name=st_in_cp3.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/data_cluster3_comp.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/data_cluster3_comp.txt
#SBATCH --time=4-00:00
#SBATCH --nodes=1 --ntasks-per-node=40 --mem=30gb
#SBATCH --partition=batch8
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake/package
module load matlab
matlab -nodesktop -r "cluster=3; confi_starlight_complete"