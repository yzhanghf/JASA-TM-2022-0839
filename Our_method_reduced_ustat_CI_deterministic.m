function [u_stat, CI] = Our_method_reduced_ustat_CI_deterministic(type, x, r, al, percent, b1, b2)
    % Usage:  Our_method_deterministic(@motif, OTHER-INPUTS)
    % Input list:
    % type: a string specifying which motif to be evaluated
    % x: data, i.e., X variables in a classical U-statistic
    % r: degree of the U-stat, should be consistent with motif type
    % al: the "alpha" parameter in the paper, controls the level of U-statistic reduction, between 1 and 2
    % percent: (1-percent) is the desired confidence level
    % b1, b2: the constant parameters in the paper
    % Output list:
    % u_stat: point estimator of E[U_J]
    % CI: confidence interval for E[U_J] at the level of (1-percent)

    n = length(x);
    M_alpha = min(floor(n^(al-1)),floor((n-1)/(2^(r-1)-1)));
    b2 = 1;
    b1 = (2^(r-1)-1)/2^(r-1);
    M_alpha2 = min(floor(n^(al-1)),floor((n-1)/(r-1)));

    % Computing the members of J_{n,\alpha}
    li2 = [];
    for i = (floor(b1*M_alpha)+1):M_alpha
            item = zeros(n,r);
            item(:,1) = 1:n;
            for c = 1:(r-1)
                item(:,c+1) =item(:,1)+(2^c-1)*i;
            end
            item = mod(item-1,n)+1;
            li2 = [li2;item];
    end 

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

    % Computing reduced U-statistic, variance estimation and summary statistics needed by the Edgeworth expansion
    mu_hat_esti = mean(motif(x(li_hat),type));
    mu_2 = mu_hat_esti^2;
    sigma_h2 = mean(motif(x(li_hat),type).^2)-mu_2;
    h_vec = motif(x(li_hat),type)';
    h_vec2 = motif(x(li2),type)';
    mu_hat = mean(h_vec2);
    [al_value,al_number] = h_redu(li_hat, h_vec, n);
    al_weight = al_value./al_number;
    ksei2 = mean(( al_weight - mu_hat_esti).^2);
    g_qub = mean(( al_weight - mu_hat_esti).^3);
    intera = 1/size(li_hat,1)*sum((h_vec'-mu_hat_esti-(al_weight(li_hat(:,1))-mu_hat_esti)-(al_weight(li_hat(:,r))-mu_hat_esti)).*(al_weight(li_hat(:,1))-mu_hat_esti).*(al_weight(li_hat(:,r))-mu_hat_esti));
    var_all = (ksei2*r^2)/n;
    ksei = sqrt(ksei2);

    % Computing confidence interval
    [gj_l, gj_u] = confidence_level(percent,ksei, 1,1,sigma_h2, b2,b1, al, g_qub, intera, M_alpha,n,0);
    q_h = mu_hat - sqrt(var_all)*(gj_u);
    q_l = mu_hat - sqrt(var_all)*(gj_l);
    timeCI1(k,m) = toc;

    u_stat = mu_hat;
    CI = [q_l, q_h];

end

