
function [lowercf,uppercf] = confidence_level(percent,ksei, g2,g3,sigma_h2, b2,b1, al, g_qub, intera, M_alpha,n,randomness)
	% This function computes the Cornish-Fisher expansion
	% depends on: g_tuda_esti.m, which computes each individual term in Cornish-Fisher expansion
	% Input list:
	% percent: percentage
	% ksei: estimated \xi_1
	% g2,g3: obsolete, but kept for now for stability of program, can fill in arbitrary values
	% sigma_h2: estimated \sigma_h^2
	% b2, b1: only needed by deterministic design, same as b_2 and b_1 in paper
	% al: alpha
	% g_qub:  estimated E[g_1^3(X_1)]
	% intera: estimated E[g_1(X_1)g_1(X_2)g_2(X_1,X_2)]
	% M_alpha: M_\alpha in paper
	% n: sample size of X
	% randomness: =0: deterministic design; =1: random design (J1)
	% Output: CI lower and upper bounds

	z_l = norminv(1-percent/2);
	z_u = norminv(percent/2);

	% Computing lower bound
	u = z_l;
    r = 3;
	g0 = (2*u^2+1)/(6*ksei^3)*g_qub +(r-1)*(u^2+1)/(2*ksei^3)*intera;
	l_upper = floor((al/2)/(al-1));
	g_hat = zeros(l_upper,1);
	for l = 1: l_upper
		g_hat(l,1) =  g_tuda_esti(u, ksei, g2,g3, sigma_h2,b2,b1,l,randomness)/M_alpha^l ;
    end
	lowercf = u - g0/sqrt(n) + sum(g_hat);

	% Computing upper bound
	u = z_u;
	g0 = (2*u^2+1)/(6*ksei^3)*g_qub +(r-1)*(u^2+1)/(2*ksei^3)*intera;
	g_hat = zeros(l_upper,1);
	for l = 1: l_upper
		g_hat(l,1) =  g_tuda_esti(u, ksei, g2,g3,sigma_h2, b2,b1,l,randomness)/M_alpha^l; 
    end
	uppercf = u - g0/sqrt(n) + sum(g_hat);

	end

