#!/bin/bash
#SBATCH --job-name=st_in_cp2.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/data_cluster2_comp.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/data_cluster1_comp.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=5gb
#SBATCH --partition=stat
#SBATCH --qos=normal


cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake
module load matlab
matlab -nodesktop -r "cluster=2; confi_starlight_complete"