#!/bin/bash
#SBATCH --job-name=cp_dt_resample10.sh
#SBATCH --output=/home/Magpie/U-Statistic-Reduction/output/cp_dt_resample10.txt
#SBATCH --error=/home/Magpie/U-Statistic-Reduction/output/cp_dt_resample10.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=2gb
#SBATCH --partition=stat
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/Magpie/U-Statistic-Reduction
module load matlab
matlab -nodesktop -r "n=400; al = 1.7; coverage_prob_deter_resample"