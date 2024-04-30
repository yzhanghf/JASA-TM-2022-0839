#include <iostream>
#include <armadillo>
#include <math.h>
#include "armaMex.hpp"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	int i,j;
	arma::mat Idx_mat = armaGetPr(prhs[0]);
	int N = Idx_mat.n_rows;
	int r = Idx_mat.n_cols;
	
	double *h_vec = mxGetPr(prhs[1]);
	int n = mxGetScalar(prhs[2]);
	
	mat a_vec = mat(n,n,fill::zeros);
	for(i=0; i<N; i++){
			int x = Idx_mat(i,0)-1;
			int y = Idx_mat(i,1)-1;		
			a_vec(x,y) += h_vec[i];
			a_vec(y,x) += h_vec[i];		
	}
	
	plhs[0] = mxCreateDoubleMatrix(a_vec.n_rows, a_vec.n_cols, mxREAL);
  
  // Return the cube C as plhs[0] in Matlab/Octave
    armaSetPr(plhs[0], a_vec);
	
	mat b_vec = mat(n,n,fill::zeros);
	for(i=0; i<N; i++){
			int x = Idx_mat(i,0)-1;
			int y = Idx_mat(i,1)-1;				
			b_vec(x,y) += 1;
			b_vec(y,x) += 1;			
	}
	
	plhs[1] = mxCreateDoubleMatrix(b_vec.n_rows, b_vec.n_cols, mxREAL);
  
  // Return the cube C as plhs[0] in Matlab/Octave
    armaSetPr(plhs[1], b_vec);
	


}