
function [q_l, q_h,h_vec] = CI_ustat_complete(percent,x, type,r,n)
    li2 = nchoosek(1:n,r);
    h_vec = motif(x,type,li2)';
    mu_hat = mean(h_vec);
    [al_value,al_number] = h_redu(li2, h_vec, n);
    al_weight = al_value./al_number;
    ksei2 = mean(( al_weight - mu_hat).^2);
    g_qub = mean(( al_weight - mu_hat).^3);
    switch r
            case 2
                [g2,weight] = h_g1g1g2_2(li2,h_vec,n);
            case 3
            
                [g2,weight] = h_g1g1g2(li2,h_vec,n);
            case 4
               [g2,weight] = h_g1g1g2_4(li2,h_vec,n);
    end
    g2_up = g2./weight;
    g2_up(isnan(g2_up)) = 0;
    intera = g112_function(al_weight,al_number,g2_up,weight,mu_hat);
    var_all = n*nchoosek(n-1,r-1)^2/(nchoosek(n,r)^2)*ksei2;
    ksei = sqrt(ksei2);
    [gj_l, gj_u] = confidence_level_complete(percent,ksei,  g_qub, intera, n,r);
    q_h = mu_hat - sqrt(var_all)*(gj_u);
    q_l = mu_hat - sqrt(var_all)*(gj_l);


	end

