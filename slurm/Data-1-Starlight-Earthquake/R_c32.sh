#!/bin/bash
#SBATCH --job-name=st_in250.sh
#SBATCH --output=/home/zhang.7824/U-Statistic-Reduction/output/data_cluster2.txt
#SBATCH --error=/home/zhang.7824/U-Statistic-Reduction/output/data_cluster2.txt
#SBATCH --time=5-00:00
#SBATCH --nodes=1 --ntasks-per-node=40 --mem=30gb
#SBATCH --partition=stat
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/zhang.7824/U-Statistic-Reduction/data/starlight_earthquake/package
module load matlab
matlab -nodesktop -r "cluster=2; seednumber=50; confi_starlight"