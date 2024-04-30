#include "test/TestWeightedLowRank.h"

using namespace ROPTLIB;

void testWeightedLowRank(void)
{
	//	FILE *ttt = nullptr;
	//	freopen_s(&ttt, "./log.txt", "w", stdout);
	integer m = 10, n = 8, r = 3;
	//integer m = 100, n = 15, r = 5;
	LowRank Domain(m, n, r);
	Domain.SetHasHHR(true);
	LowRankVariable InitialX(m, n, r);
	InitialX.RandInManifold();
	//Domain.CheckParams();
	//Domain.CheckIntrExtr(&InitialX);
	//Domain.CheckRetraction(&InitialX);
	//Domain.CheckcoTangentVector(&InitialX);
	//Domain.CheckDiffRetraction(&InitialX, false);
	//Domain.CheckIsometryofVectorTransport(&InitialX);

	//Domain.CheckLockingCondition(&InitialX);
	//Domain.CheckIsometryofInvVectorTransport(&InitialX);
	//Domain.CheckVecTranComposeInverseVecTran(&InitialX);
	//Domain.CheckTranHInvTran(&InitialX);
	//return;

	//InitialX.Print("initialX:");

	// Generate the matrices in the Low rank approximation problem.
	integer mn = m * n, mr = m * r, nr = n * r;
	double *A = new double[mn];
	double *A_U = new double[mr];
	double *A_V = new double[nr];
	for (integer i = 0; i < m * r; i++)
	{
		A_U[i] = genrandnormal();
	}
	for (integer i = 0; i < n * r; i++)
	{
		A_V[i] = genrandnormal();
	}
	char *transn = const_cast<char *> ("n");
	char *transt = const_cast<char *> ("t");
	double one = 1, zero = 0;
	// A <- A_U * A_V^T, details: http://www.netlib.org/lapack/explore-html/d7/d2b/dgemm_8f.html
	dgemm_(transn, transt, &m, &n, &r, &one, A_U, &m, A_V, &n, &zero, A, &m);
	delete[]A_U;
	delete[]A_V;

	double *W_temp = new double[mn * mn];
	double *W = new double[mn * mn];
	for (integer i = 0; i < mn; i++)
	{
		for (integer j = 0; j < mn; j++)
		{
			W_temp[i + j * mn] = genrandnormal();
			//if (i == j)
			//{
			//	W_temp[i + i * mn] = 1;
			//}
			//else
			//{
			//	W_temp[i + j * mn] = 0;
			//}
		}
	}

	// W <- W_temp * W_temp^T, details: http://www.netlib.org/lapack/explore-html/d7/d2b/dgemm_8f.html
	dgemm_(transn, transt, &mn, &mn, &mn, &one, W_temp, &mn, W_temp, &mn, &zero, W, &mn);
	delete[]W_temp;

	Stiefel mani1(m, r);
	Euclidean mani2(r, r);
	Stiefel mani3(n, r);
	WeightedLowRank Prob(A, W, m, n, r);
	Prob.SetDomain(&Domain);

	//Prob.CheckGradHessian(&InitialX);

	LRBFGS *RSDsolver = new LRBFGS(&Prob, &InitialX);
	//->LineSearch_LS = ARMIJO;
	//RSDsolver->LS_beta = 0.01;
	//RSDsolver->RCGmethod = DAI_YUAN;
	RSDsolver->Debug = FINALRESULT;
	RSDsolver->OutputGap = 100;
	RSDsolver->Max_Iteration = 70;
	//RSDsolver->CheckParams();
	//RSDsolver->Accuracy = 1e-6;
	RSDsolver->Tolerance = 1e-6;
	RSDsolver->Run();
	if (RSDsolver->Getnormgfgf0() < 1e-6)
		printf("SUCCESS!\n");
	else
		printf("FAIL!\n");
	//Prob.CheckGradHessian(&InitialX);//--
	//Prob.CheckGradHessian(RSDsolver->GetXopt());//--
	//RSDsolver->GetXopt()->Print("Xopt");
	delete RSDsolver;

	delete[]A;
	delete[]W;
};

#ifdef MATLAB_MEX_FILE

std::map<integer *, integer> *CheckMemoryDeleted;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	genrandseed(0);
	
	CheckMemoryDeleted = new std::map<integer *, integer>;
	testWeightedLowRank();
	std::map<integer *, integer>::iterator iter = CheckMemoryDeleted->begin();
	for (iter = CheckMemoryDeleted->begin(); iter != CheckMemoryDeleted->end(); iter++)
	{
		if (iter->second != 1)
			printf("Global address: %p, sharedtimes: %d\n", iter->first, iter->second);
	}
	delete CheckMemoryDeleted;
	return;
}

#endif
