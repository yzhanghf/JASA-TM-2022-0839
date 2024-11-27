
addpath('subroutine');

r = 3;
percent = 0.1;
itern = 500;
iterc = 100;
boot = 200;

type = "Sine";

timeCI5 = zeros(itern,iterc);
cover5 = zeros(itern,iterc);
coverlg5 = zeros(itern,iterc);


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
		    cover5(k,m) = NaN;
            coverlg5(k,m) = NaN;	
        else
		    mu_true = get_mean(type);
            var_all = sum(al_number.^2)/(floor(n^al)^2)*ksei2;
            t_mc_other = zeros(boot,1);
            nboot = ceil(sqrt(n));
            for i= 1:boot
                indexn = datasample(1:n, nboot, 'Replace', false);
                x_new = x(indexn);
                [li2,checkin] = randomsamle_inner(nboot,al);
                if checkin
                    h_vec = motif(x_new(li2),type)';
                    mu_hat_new = mean(h_vec);
                    [al_value,al_number] = h_redu(li2, h_vec, nboot);
                    al_weight = al_value./al_number;
                    ksei2_new = mean(( al_weight - mu_hat_new).^2);
                    var_all_new = sum(al_number.^2)/(floor(nboot^al)^2)*ksei2_new;
                    t_mc_other(i,1) = (mu_hat_new - mu_hat)/sqrt(var_all_new);
                else
                    t_mc_other(i,1) = NaN;
                end
            end
            gj_u = quantile(t_mc_other,percent/2);
            gj_l = quantile(t_mc_other,1-percent/2);
            q_h = mu_hat - sqrt(var_all)*(gj_u);
            q_l = mu_hat - sqrt(var_all)*(gj_l);
		    if mu_true> q_l && mu_true < q_h
                cover5(k,m) = 1;
            else
                cover5(k,m) = 0;
            end
            coverlg5(k,m) = q_h - q_l;
        end
        timeCI5(k,m) = toc;
    else
	    cover5(k,m) = NaN;
        coverlg5(k,m) = NaN;
    	timeCI5(k,m) = NaN;
    end


end


end



save(sprintf('./result/all_comparison2_%d_al_%d_%s_subsample',n,al*100,type),"timeCI5","cover5","coverlg5")