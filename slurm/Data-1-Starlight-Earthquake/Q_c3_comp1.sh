#!/bin/bash
#SBATCH --job-name=etin_cp1.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/data_eq_comp_cluster1.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/data_eq_comp_cluster1.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=5gb
#SBATCH --partition=stat
#SBATCH --qos=normal


cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake
module load matlab
matlab -nodesktop -r "cluster=1; difference_earth_inner_comp"