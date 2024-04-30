#!/bin/bash
#SBATCH --job-name=cp_rd_subsample4.sh
#SBATCH --output=/home/zhang.7824/U-Statistic-Reduction/output/cp_rd_subsample4.txt
#SBATCH --error=/home/zhang.7824/U-Statistic-Reduction/output/cp_rd_subsample4.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=5gb
#SBATCH --partition=stat
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/zhang.7824/U-Statistic-Reduction
module load matlab
matlab -nodesktop -r "n=200; al = 1.5; coverage_prob_random_subsample"