#!/bin/bash
#SBATCH --job-name=st_in150.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/data_cluster1.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/data_cluster1.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=40 --mem=10gb
#SBATCH --partition=stat
#SBATCH --qos=normal


cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake
module load matlab
matlab -nodesktop -r "cluster=1; seednumber=50; confi_starlight"