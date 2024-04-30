#!/bin/bash
#SBATCH --job-name=stock_c2.sh
#SBATCH --output=/home/Magpie/reduced_u_mat/dataexample/output/stock_comp2.txt
#SBATCH --error=/home/Magpie/reduced_u_mat/dataexample/output/stock_comp2.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=5 --mem=5gb
#SBATCH --partition=stat
#SBATCH --qos=normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meijiashao666@gmail.com
cd /home/Magpie/reduced_u_mat/dataexample
module load matlab
matlab -nodesktop -r "data_analysis_comp2"