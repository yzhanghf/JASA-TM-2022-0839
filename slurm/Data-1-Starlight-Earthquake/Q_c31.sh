#!/bin/bash
#SBATCH --job-name=eth_in130.sh
#SBATCH --output=/home/zhang.7824/U-Statistic-Reduction/output/data_eq_cluster1.txt
#SBATCH --error=/home/zhang.7824/U-Statistic-Reduction/output/data_eq_cluster1.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=30 --mem=10gb
#SBATCH --partition=stat
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/zhang.7824/U-Statistic-Reduction/data/starlight_earthquake/package
module load matlab
matlab -nodesktop -r "cluster=1; seednumber=30; difference_earth_inner"