function [u_stat, CI] = Our_method_reduced_ustat_CI_random(motif, type, x, r, al, percent)
    % Usage:  Our_method_deterministic(@motif, OTHER-INPUTS)
    % Input list:
    % motif(n*r-matrix, kernel-function-name): outputs n*1 evaluations of the kernel function evaluated at each row of the matrix input
    % type: a string specifying which motif to be evaluated
    % x: data, i.e., X variables in a classical U-statistic
    % r: degree of the U-stat, should be consistent with motif type
    % al: the "alpha" parameter in the paper, controls the level of U-statistic reduction, between 1 and 2
    % percent: (1-percent) is the desired confidence level
    % Output list:
    % u_stat: point estimator of E[U_J]
    % CI: confidence interval for E[U_J] at the level of (1-percent)

    M_alpha = min(floor(n^(al-1)),floor((n-1)/(2^(r-1)-1)));
    M_alpha2 = min(floor(n^(al-1)),floor((n-1)/(r-1)));

    % Computing the members of J_{n,\alpha}
    li_hat = [];
    for i = 1:M_alpha2
            item = zeros(n,r);
            item(:,1) = 1:n;
            for c = 1:r-1
                item(:,c+1) = item(:,1)+i*c;
            end
            item = mod(item-1,n)+1;
            li_hat = [li_hat;item];
    end

    g2_li = zeros(M_alpha2*n,r,2);
    g2_li1 = [];
    g2_li2 = [];
    for i = 1:M_alpha2
            item = zeros(n,r);
            item(:,1) = 1:n;
            for c = 0:r-1
                item(:,c+1) = item(:,1)+i*c;
            end
            g2_li1 = [g2_li1;item];
            item2 = zeros(n,r);
            for c = 0:r-1
                item2(:,c+1) = item(:,end)+i*(c-1);
            end
            g2_li2 = [g2_li2;item2];
    end
    g2_li(:,:,1) = g2_li1;
    g2_li(:,:,2) = g2_li2;
    g2_li = mod(g2_li-1,n)+1;

    li2 = randomsamle(n,al);


    % Computing reduced U-statistic, variance estimation and summary statistics needed by the Edgeworth expansion
    mu_hat_esti = mean(motif(x(li_hat),type));
    mu_2 = mu_hat_esti^2;
    sigma_h2 = mean(motif(x(li_hat),type).^2)-mu_2;
    h_vec = motif(x(li2),type)';
    mu_hat = mean(h_vec);
    [al_value,al_number] = h_redu(li2, h_vec, n);
    al_weight = al_value./al_number;
    ksei2 = mean(( al_weight - mu_hat).^2);
    ksei = sqrt(ksei2);
    g_qub = mean(( al_weight - mu_hat).^3);
    intera = 1/size(li2,1)*sum((motif(x(li2),type)-mu_hat-(al_weight(li2(:,1))-mu_hat)-(al_weight(li2(:,r))-mu_hat)).*(al_weight(li2(:,1))-mu_hat).*(al_weight(li2(:,r))-mu_hat));    
    xx6 = motif(x(g2_li(:,:,1)),type); xx6 = xx6 - mean(xx6)-(al_weight(g2_li(:,(r-1),1))-mu_hat)-(al_weight(g2_li(:,r,1))-mu_hat);
    xx7 = motif(x(g2_li(:,:,2)),type); xx7 = xx7 - mean(xx7)-(al_weight(g2_li(:,1,2))-mu_hat)-(al_weight(g2_li(:,2,2))-mu_hat);
    g2 = mean(xx6.*xx7) ;
    M_alpha_new = n^(al-1)*(1+1/(r*n^(al-1)))/(1+n^(al-2)*g2*r*(r-1)/(sigma_h2-r*ksei^2));
    var_all = sum(al_number.^2)/(floor(n^al)^2)*ksei2;

    % Computing confidence interval
    [gj_l, gj_u] = confidence_level(percent,ksei, 1,1,sigma_h2, b2,b1, al, g_qub, intera, M_alpha_new,n,1);
    q_h = mu_hat - sqrt(var_all)*(gj_u);
    q_l = mu_hat - sqrt(var_all)*(gj_l);


    u_stat = mu_hat;
    CI = [q_l, q_h];

end

