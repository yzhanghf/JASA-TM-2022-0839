#!/bin/bash
#SBATCH --job-name=CDF_rm_8.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/CDF_rm_8.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/CDF_rm_8.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=2gb
#SBATCH --partition=stat
#SBATCH --qos=normal


cd /home/Magpie/U-Statistic-Reduction
module load matlab
matlab -nodesktop -r "n=80; al = 1.7; type='Sine'; nondegenerate_MC_random2"