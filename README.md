# Reproducing the results in JASA-TM-2022-0839

This document serves to the Round 1 and Round 2 revisions of this paper.

# Contents

## Contents of subfolders
* data: contains data examples
* output: for recording screen outputs on HPC for tracking job progress and debugging
* plot: contains outputs of simulations
* slurm: contains all Unity jobs, written for Slurm job queueing system
* subroutines: contains subroutines

## Subroutines implementing our method

Our method is implemented for the deterministic design and random design (J1):
* Deterministic design:  Our_method_reduced_ustat_CI_deterministic.m
* Random design (J1):  Our_method_reduced_ustat_CI_random.m
   Run
   ```
   help Our_method_reduced_ustat_CI_deterministic
   help Our_method_reduced_ustat_CI_random
   ```
   To display documentation.

## List of other important subroutines
* subroutines/motif.m: computes the kernel function
* subroutines/confidence_interval.m: computes the confidence interval using Cornish-Fisher expansion
* subroutines/randomsamle.m: generate the reduced index set J_{n,alpha}

## List of auxiliary subroutines/functions
* subroutines/h_g1g1g2.cpp and subroutines/g112_function.cpp: these functions, run consecutively, compute an estimation for E[g_1(X_1)g_1(X_2)g_2(X_1,X_2)]; they are only needed by the benchmark method based on complete U-statistic, not our method
* nondegenerate_MC2.m: simulating the true distribution to evaluate all methods, for deterministic design
* nondegenerate_MC_random2.m: simulating the true distribution to evaluate all methods, for random design J1
* plot*.m: plotting functions

## List of files implementing benchmark methods
* coverage_prob_both_complete.m: complete U-statistic, for both deterministic and random designs
* Deterministic design:
   + coverage_prob_deter_normal.m: normal approximation
   + coverage_prob_deter_resample.m: resample bootstrap
   + coverage_prob_deter_subsample.m: subsample bootstrap
* Random design (J1):
   + coverage_prob_random_normal.m: normal approximation
   + coverage_prob_random_resample.m: resample bootstrap
   + coverage_prob_random_subsample.m: subsample bootstrap

## Imported functions/packages from other authors
* shadedErrorBar: https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar
* fdasrvf: https://www.mathworks.com/matlabcentral/fileexchange/66494-fdasrvf

# Hardware requirement:
* Computing cluster, such as Unity
* Most, if not all, experiments in this code are likely infeasible to run on personal computers.  Therefore, all reproducibility details are written for running on high-performance computing (HPC) clusters, such as Unity.  In this document, we will use Unity as an example.

# Steps to reproduce simulation and data example results

0. [Preparation] Upload all contents of this repository to a unity folder, under the path:
   ```
   /home/Magpie/U-Statistic-Reduction/
   ```
   where recall that "Magpie" is the anonymized name.
   Please notice that the Unity server that you use to reproduce this code may have a different folder structure -- in which case, please also revise the Slurm scripts under the "slurm" subfolder accordingly.

1. [Preparation] In this work, we use the word "Magpie" as the anonymized name.
   To run our code, you need to replace "Magpie" by your own username.

   First, edit "folderlist.txt", replace "Magpie" there by your own username.
   Then in Unity commandline, run
   ```
   sh changename.sh Magpie YOUR-OWN-USERNAME
   ```

   For the remaining steps, whenever we need to describe folder paths, we will still use "Magpie" as the anonymized username.

2. [Preparation] (Perform this step only when you need to manually re-compile the MEX files.  We provide the compiled MEX files in this repository, so you may skip this step, unless an error with these functions pops up.)

   Run the following commands on Unity.  Replace "Magpie" in the following command by your own username.

   Download and compile your local copy of Armadillo:
   ```
   module load cmake
   cd ~
   mkdir Armadillo
   cd Armadillo
   wget https://cytranet.dl.sourceforge.net/project/arma/armadillo-12.8.2.tar.xz
   tar -xf armadillo-12.8.2.tar.xz
   cd armadillo-12.8.2
   ./configure --prefix=/home/Magpie/Armadillo
   make
   make DESTDIR=/home/Magpie/Armadillo install
   ```

   Then open Matlab:
   ```
   module load matlab
   matlab -nodesktop -nodisplay
   ```

   Run the following lines to compile the C++ code into MEX files:
   ```
   mex h_g1g1g2.cpp -I"/home/Magpie/Armadillo/usr/include"
   mex g112_function.cpp -I"/home/Magpie/Armadillo/usr/include"
   mex h_redu.c
   ```


3. [Preparation]
   Download package "fdasrvf" from
   https://www.mathworks.com/matlabcentral/fileexchange/66494-fdasrvf
   and unzip its contents to subfolder "/home/Magpie/U-Statistic-Reduction/data/starlight_earthquake/package"

---
In all the steps that follow, if you encounter the error that folder doesn't exist, please manually mkdir.  This is unfortunately due to GitHub's feature of automatically deleting empty subfolders.
---

4. Run simulation codes on Unity.  Replace "Magpie" in the following command by your own username.

   To produce the simulated data for plotting, run the following on Unity:
   ```
   cd /home/Magpie/U-Statistic-Reduction/slurm/
   cd 1-Deterministic-Design
   sh submit_all.sh
   cd ..
   cd 2-Random-Design
   sh submit_all.sh
   cd ..
   cd CDF-1-Deterministic-Design
   sh submit_all.sh
   cd ..
   cd CDF-2-Random-Design
   sh submit_all.sh
   ```

   After all these jobs finish running, submit the following jobs:
   ```
   cd /home/Magpie/U-Statistic-Reduction/slurm/
   sbatch plot_deter_random.sh
   sbatch plot_and_benchmarks_CDF-1.sh
   sbatch plot_and_benchmarks_CDF-2.sh
   ```
   where the job plot_and_benchmarks_CDF-1.sh reproduces Figure 2 and plot_and_benchmarks_CDF-2.sh reproduces Figure 3.

   Then all simulation plots will be outputted to the "plot" subfolder.

5. Run data example codes on Unity.

   1. Starlight and earthquake data
      
      Before running the code, the user might need to run the following lines to compile the C++ code into MEX file in the right folder:
      ```
      cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake/subroutines
      module load cmake
      module load matlab
      matlab -nodesktop -nodisplay
      mex h_g1g1g2_4.cpp -I"/home/Magpie/Armadillo/usr/include"
      mex g112_function.cpp -I"/home/Magpie/Armadillo/usr/include"
      mex h_redu.c
      ```

      To reproduce those plots that illustrate the data (but no method yet):
      ```
      cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake/
      module load matlab
      matlab -r "starlight_plot_data"
      matlab -r "earthquake_plot_data"
      ```

      To run our method and reproduce related plots, first run:
      ```
      cd /home/Magpie/U-Statistic-Reduction/slurm/Data-1-Starlight-Earthquake
      sh submit_all.sh
      ```
      After all these jobs finish running, run the following commands in Unity:
      ```
      cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake
      module load gnu
      module load R
      R
      ```
      Then in R, run the following lines:
      ```
      source("starlight_CI_plot.R");
      source("earthquake_CI_plot.R");
      ```
      Resulting plots will be located at: /home/Magpie/U-statistic-reduction/data/starlight_earthquake/plot, these results form Figure 4.
   
   2. Stock market data
      
      Before run the code, we still need to run the following lines to compile the C++ code into MEX file in the right folder:
         ```
         cd /home/Magpie/U-Statistic-Reduction/data/stock_market/subroutines
         module load cmake
         module load matlab
         matlab -nodesktop -nodisplay
         mex h_g1g1g2_4.cpp -I"/home/Magpie/Armadillo/usr/include"
         mex g112_function.cpp -I"/home/Magpie/Armadillo/usr/include"
         mex h_redu.c
         ```
      To run our method, run the following code:
      ```
      cd /home/Magpie/U-Statistic-Reduction/slurm/Data-2-Stockmarket
      sbatch S_c31.sh
      sbatch S_c32.sh
      sbatch S_c33.sh
      sbatch stock_comp.sh
      sbatch stock_comp2.sh
      ```
      After these jobs finish running, submit the following job:
      ```
      sbatch stock_run_last_two_plot_commands.sh
      ```
      Resulting plots will be located at: /home/Magpie/U-statistic-reduction/data/stock_market/plot, these results form Figure 5.

   Table 5 is manually computed by summarizing the time cost files from all data examples.


   







