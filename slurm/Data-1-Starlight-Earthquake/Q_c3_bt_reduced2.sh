#!/bin/bash
#SBATCH --job-name=earth6.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/data_eq_bt_redu6.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/data_eq_bt_redu6.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=40 --mem=10gb
#SBATCH --partition=stat
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake/package
module load matlab
matlab -nodesktop -r "length_date=6; difference_earth"