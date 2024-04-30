#!/bin/bash
#SBATCH --job-name=earth_true2.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/earth_bt_comp.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/earth_bt_comp.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=5gb
#SBATCH --partition=stat
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake/package
module load matlab
matlab -nodesktop -r "length_date=6; difference_earth_true"