#!/bin/bash
#SBATCH --job-name=cdf-1-plot
#SBATCH --output=/home/zhang.7824/U-Statistic-Reduction/output/cdf-1-plot-output.txt
#SBATCH --error=/home/zhang.7824/U-Statistic-Reduction/output/cdf-1-plot-error.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=1 --mem=10gb
#SBATCH --partition=stat
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/zhang.7824/U-Statistic-Reduction
module load matlab
matlab -nodesktop -r "plot_CDF_approximation_error_deter"