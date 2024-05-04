# Reproducing the results in JASA-TM-2022-0839

This document maps to the Round 1 revision of this paper.

## Hardware requirement:  computing cluster, such as Unity
* Most, if not all, experiments in this code are likely infeasible to run on personal computers.  Therefore, all reproducibility details are written for running on high-performance computing (HPC) clusters, such as Unity.  In this document, we will use Unity as an example.
* In this work, we use the word "Magpie" as the anonymized name.

## Steps to reproduce simulation and data example results

0. [Preparation] Upload all contents of this repository to a unity folder, under the path:
   ```
   /home/Magpie/U-Statistic-Reduction/
   ```
   where recall that "Magpie" is the anonymized name.
   Please notice that the Unity server that you use to reproduce this code may have a different folder structure -- in which case, please also revise the Slurm scripts under the "slurm" subfolder accordingly.

1. [Preparation] Replace "Magpie" by your (reviewer's) own username.

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
   sh plot_deter_random.sh
   sh plot_and_benchmarks_CDF-1.sh
   sh plot_and_benchmarks_CDF-2.sh
   ```

   Then all simulation plots will be outputted to the "plot" subfolder.

5. Run data example codes on Unity.

   1. Starlight and earthquake data
        Before run the code, we need to run the following lines to compile the C++ code into MEX file in the right folder:
         ```
         cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake/package
         module load matlab
         matlab -nodesktop -nodisplay
         mex h_g1g1g2_4.cpp -I"/home/Magpie/Armadillo/usr/include"
         mex g112_function.cpp -I"/home/Magpie/Armadillo/usr/include"
         mex h_redu.c
         ```

      To reproduce those plots that illustrate the data (but no method yet):
      ```
      cd /home/Magpie/U-Statistic-Reduction/data/starlight_earthquake/package/
      module load matlab
      matlab -r "confi_starlight_plot"
      matlab -r "earthquake_plot"
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
      Resulting plots will be located at: /home/Magpie/U-statistic-reduction/data/starlight_earthquake/package/data/starlight_earthquake/plot
   
   3. Stock market data
      Before run the code, we still need to run the following lines to compile the C++ code into MEX file in the right folder:
         ```
         cd /home/Magpie/U-Statistic-Reduction/data/stock_market
         module load matlab
         matlab -nodesktop -nodisplay
         mex h_g1g1g2_4.cpp -I"/home/Magpie/Armadillo/usr/include"
         mex g112_function.cpp -I"/home/Magpie/Armadillo/usr/include"
         mex h_redu.c
         ```
      To run our method, run the following code:
      ```
      cd /home/Magpie/U-Statistic-Reduction/slurm/Data-2-Stockmarket
      sh S_c31.sh
      sh S_c32.sh
      sh S_c33.sh
      sh stock_comp.sh
      sh stock_comp2.sh
      ```
      After these jobs finish running, submit the following job:
      ```
      sh stock_run_last_two_plot_commands.sh
      ```
      Resulting plots will be located at: /home/Magpie/U-statistic-reduction/data/stock_market/data/stock_market


   







