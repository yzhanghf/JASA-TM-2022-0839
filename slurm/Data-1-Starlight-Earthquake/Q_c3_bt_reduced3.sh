#!/bin/bash
#SBATCH --job-name=earth7.sh
#SBATCH --output=/home/zhang.7824/U-Statistic-Reduction/output/data_eq_bt_redu7.txt
#SBATCH --error=/home/zhang.7824/U-Statistic-Reduction/output/data_eq_bt_redu7.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=40 --mem=10gb
#SBATCH --partition=stat
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/zhang.7824/U-Statistic-Reduction/data/starlight_earthquake/package
module load matlab
matlab -nodesktop -r "length_date=7; difference_earth"