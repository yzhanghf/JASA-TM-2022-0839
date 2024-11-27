#!/bin/bash
#SBATCH --job-name=earth5.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/data_eq_bt_redu5.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/data_eq_bt_redu5.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=40 --mem=10gb
#SBATCH --partition=stat
#SBATCH --qos=normal


cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake
module load matlab
matlab -nodesktop -r "length_date=5; difference_earth"