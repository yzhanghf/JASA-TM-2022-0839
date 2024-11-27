#!/bin/bash
#SBATCH --job-name=cp_rd_resample2.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/cp_rd_resample2.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/cp_rd_resample2.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=5gb
#SBATCH --partition=stat
#SBATCH --qos=normal


cd /home/Magpie/U-Statistic-Reduction
module load matlab
matlab -nodesktop -r "n=50; al = 1.5; coverage_prob_random_resample"