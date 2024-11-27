#!/bin/bash
#SBATCH --job-name=CDF_rm_1.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/CDF_rm_1.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/CDF_rm_1.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=2gb
#SBATCH --partition=stat
#SBATCH --qos=normal


cd /home/Magpie/U-Statistic-Reduction
module load matlab
matlab -nodesktop -r "n=10; al = 1.5; type='Sine'; nondegenerate_MC_random2"