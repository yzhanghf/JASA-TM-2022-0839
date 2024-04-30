#!/bin/bash
#SBATCH --job-name=st_bt_tr1.sh
#SBATCH --output=/home/zhang.7824/U-Statistic-Reduction/output/data_bt_true1.txt
#SBATCH --error=/home/zhang.7824/U-Statistic-Reduction/output/data_bt_true1.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=5gb
#SBATCH --partition=batch8
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/zhang.7824/U-Statistic-Reduction/data/starlight_earthquake/package
module load matlab
matlab -nodesktop -r "cluster1=1; cluster2=2; complete_MMD_starlight"