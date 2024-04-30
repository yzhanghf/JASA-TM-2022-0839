#!/bin/bash
#SBATCH --job-name=st_bt140_13.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/data_bt_13_output.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/data_bt_23_error.txt
#SBATCH --time=4-00:00
#SBATCH --nodes=1 --ntasks-per-node=40 --mem=10gb
#SBATCH --partition=batch8
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake/package
module load matlab
matlab -nodesktop -r "cluster1=1; cluster2=3; seednumber=40; confi_starlight_group"