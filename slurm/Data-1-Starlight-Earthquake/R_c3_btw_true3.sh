#!/bin/bash
#SBATCH --job-name=st_bt_tr3.sh
#SBATCH --output=/home/zhang.7824/U-Statistic-Reduction/output/data_bt_true3.txt
#SBATCH --error=/home/zhang.7824/U-Statistic-Reduction/output/data_bt_true3.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=5gb
#SBATCH --partition=batch8
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/zhang.7824/U-Statistic-Reduction/data/starlight_earthquake/package
module load matlab
matlab -nodesktop -r "cluster1=2; cluster2=3; complete_MMD_starlight"