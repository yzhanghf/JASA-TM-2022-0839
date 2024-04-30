#!/bin/bash
#SBATCH --job-name=cp_dt_complete4.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/cp_dt_complete4.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/cp_dt_complete4.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=20gb
#SBATCH --partition=stat
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/Magpie/U-Statistic-Reduction
module load matlab
matlab -nodesktop -r "n=200; al = 1.5; coverage_prob_both_complete"