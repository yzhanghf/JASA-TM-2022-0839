#!/bin/bash
#SBATCH --job-name=CDF_dt_1.sh
#SBATCH --output=/home/zhang.7824/U-Statistic-Reduction/output/CDF_dt_1.txt
#SBATCH --error=/home/zhang.7824/U-Statistic-Reduction/output/CDF_dt_1.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=1 --mem=10gb
#SBATCH --partition=stat
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/zhang.7824/U-Statistic-Reduction
module load matlab
matlab -nodesktop -r "n=10; al = 1.5; type='Sine'; nondegenerate_MC2"