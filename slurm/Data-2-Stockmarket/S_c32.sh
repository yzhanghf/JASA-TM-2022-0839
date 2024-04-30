#!/bin/bash
#SBATCH --job-name=data_stock2.sh
#SBATCH --output=/home/zhang.7824/U-Statistic-Reduction/output/stock.txt
#SBATCH --error=/home/zhang.7824/U-Statistic-Reduction/output/stock.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=5 --mem=5gb
#SBATCH --partition=stat
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com
cd /home/zhang.7824/U-Statistic-Reduction/data/stock_market
module load matlab
matlab -nodesktop -r "al=2; data_analysis2"