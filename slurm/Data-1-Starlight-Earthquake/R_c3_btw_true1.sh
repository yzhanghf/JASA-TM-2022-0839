#!/bin/bash
#SBATCH --job-name=st_bt_tr1.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/data_bt_true1.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/data_bt_true1.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=5gb
#SBATCH --partition=batch8
#SBATCH --qos=normal


cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake
module load matlab
matlab -nodesktop -r "cluster1=1; cluster2=2; complete_MMD_starlight"