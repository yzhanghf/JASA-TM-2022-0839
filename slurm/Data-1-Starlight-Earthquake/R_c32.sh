#!/bin/bash
#SBATCH --job-name=st_in250.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/data_cluster2.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/data_cluster2.txt
#SBATCH --time=5-00:00
#SBATCH --nodes=1 --ntasks-per-node=40 --mem=30gb
#SBATCH --partition=stat
#SBATCH --qos=normal


cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake
module load matlab
matlab -nodesktop -r "cluster=2; seednumber=50; confi_starlight"