


function [lowercf,uppercf] = confidence_level_complete(percent,ksei,  g_qub, intera, n,r)
	z_l = norminv(1-percent/2);
	z_u = norminv(percent/2);
	u = z_l;
	g0 = (2*u^2+1)/(6*ksei^3)*g_qub +(r-1)*(u^2+1)/(2*ksei^3)*intera;
	lowercf = u - g0/sqrt(n);
	u = z_u;
	g0 = (2*u^2+1)/(6*ksei^3)*g_qub +(r-1)*(u^2+1)/(2*ksei^3)*intera;
	uppercf = u - g0/sqrt(n);

	end

