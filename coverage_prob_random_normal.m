
r = 3;
percent = 0.1;
itern = 3000;
iterc = 100;

type = "Sine";


timeCI1 = zeros(itern,iterc);
timeCI2 = zeros(itern,iterc);
cover1 = zeros(itern,iterc);
cover2 = zeros(itern,iterc);
coverlg1 = zeros(itern,iterc);
coverlg2 = zeros(itern,iterc);


for m = 1:iterc
for k = 1:itern
    x = sampling(n,type);



    tic;

    [li2,check] = randomsamle(n,al);
    if check
        h_vec = motif(x(li2),type)';
        mu_hat = mean(h_vec);
        [al_value,al_number] = h_redu(li2, h_vec, n);
        al_weight = al_value./al_number;
        ksei2 = mean(( al_weight - mu_hat).^2);
    	ksei = sqrt(ksei2);
        if ksei2 <= 0
    		cover2(k,m) = NaN;
            coverlg2(k,m) = NaN;
            q_h = NaN;
            q_l = NaN;	
        else
    		mu_true = get_mean(type);
            var_all = sum(al_number.^2)/(floor(n^al)^2)*ksei2;
            z_l = norminv(1-percent/2);
            z_u = norminv(percent/2);
            q_h = mu_hat - sqrt(var_all)*z_u;
            q_l = mu_hat - sqrt(var_all)*z_l;
    		if mu_true>q_l && mu_true < q_h
                cover2(k,m) = 1;
            else
                cover2(k,m) = 0;
            end
            coverlg2(k,m) = q_h - q_l;
        end
        timeCI2(k,m) = toc;
    else
		cover2(k,m) = NaN;
        coverlg2(k,m) = NaN;
        timeCI2(k,m) = NaN;
    end


end
end


save(sprintf('./result/all_comparison2_%d_al_%d_%s_random_normal',n,al*100,type),"timeCI2","cover2","coverlg2")
