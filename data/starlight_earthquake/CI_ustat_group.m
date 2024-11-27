function [q_l, q_h,mu_hat] = CI_ustat_group(percent,x1,x2, al, randomness,type,r)
    n = size(x1,1);
    M_alpha = min(floor(n^(al-1)),floor((n-1)/(2^(r-1)-1)));
    b2 = 1;
    b1 = (2^(r-1)-1)/2^(r-1);
    M_alpha2 = min(floor(n^(al-1)),floor((n-1)/(r-1)));
        
    

    switch randomness
        case 0
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
            h_vec = motif_group(x1,x2,type,li_hat)';
            h_vec2 = motif_group(x1,x2,type,li2)';
            mu_hat = mean(h_vec2);
            mu_hat_esti = mean(h_vec);
            mu_2 = mu_hat_esti^2;
            sigma_h2 = mean(h_vec.^2)-mu_2;
            [al_value,al_number] = h_redu(li_hat, h_vec, n);
            al_weight = al_value./al_number;
            ksei2 = mean(( al_weight - mu_hat_esti).^2);
            g_qub = mean(( al_weight - mu_hat_esti).^3);
            intera = 1/size(li_hat,1)*sum((h_vec'-mu_hat_esti-(al_weight(li_hat(:,1))-mu_hat_esti)-(al_weight(li_hat(:,r))-mu_hat_esti)).*(al_weight(li_hat(:,1))-mu_hat_esti).*(al_weight(li_hat(:,r))-mu_hat_esti));
            var_all = (ksei2*r^2)/n;
            ksei = sqrt(ksei2);
            [gj_l, gj_u] = confidence_level(percent,ksei, 1,1,sigma_h2, b2,b1, al, g_qub, intera, M_alpha,n,randomness,r);
            q_h = mu_hat - sqrt(var_all)*(gj_u);
            q_l = mu_hat - sqrt(var_all)*(gj_l);
        case 1
            
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
            li2 = randsample_new2(n,al,r);
            h_vec = motif_group(x1,x2,type,li2)';
            h_vec2 = motif_group(x1,x2,type,li_hat)';
            mu_hat_esti = mean(h_vec2);
            mu_2 = mu_hat_esti^2;
            sigma_h2 = mean(h_vec2.^2)-mu_2;
            mu_hat = mean(h_vec);
            [al_value,al_number] = h_redu(li2, h_vec, n);
            al_weight = al_value./al_number;
            ksei2 = mean(( al_weight - mu_hat).^2);
        	ksei = sqrt(ksei2);
            g_qub = mean(( al_weight - mu_hat).^3);
            var_all = sum(al_number.^2)/(floor(n^al)^2)*ksei2;
            intera = 1/size(li2,1)*sum((h_vec'-mu_hat-(al_weight(li2(:,1))-mu_hat)-(al_weight(li2(:,r))-mu_hat)).*(al_weight(li2(:,1))-mu_hat).*(al_weight(li2(:,r))-mu_hat));    
            M_alpha_new = n^(al-1)*(1+1/(r*n^(al-1)))/(1+n^(al-2)*r*(r-1));
            [gj_l, gj_u] = confidence_level(percent,ksei, 1,1,sigma_h2, 1,1, al, g_qub, intera, M_alpha_new,n,randomness,r);
            q_h = mu_hat - sqrt(var_all)*(gj_u);
            q_l = mu_hat - sqrt(var_all)*(gj_l);
    end

	end
