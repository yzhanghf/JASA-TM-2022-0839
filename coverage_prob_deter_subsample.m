
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
    M_alpha = min(floor(n^(al-1)),floor((n-1)/(2^(r-1)-1)));
    b2 = 1;
    b1 = (2^(r-1)-1)/2^(r-1);
    M_alpha2 = min(floor(n^(al-1)),floor((n-1)/(r-1)));
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
	h_vec = motif(x(li_hat),type)';
	mu_hat_esti = mean(h_vec);
    h_vec2 = motif(x(li2),type)';
    mu_hat = mean(h_vec2);
	[al_value,al_number] = h_redu(li_hat, h_vec, n);
    al_weight = al_value./al_number;
    ksei2 = mean(( al_weight - mu_hat_esti).^2);
	mu_true = get_mean(type);
	var_all = (ksei2*r^2)/n;

	t_mc_other = zeros(boot,1);
	nboot = ceil(sqrt(n));

	M_alpha = min(floor(nboot^(al-1)),floor((nboot-1)/(2^(r-1)-1)));
    b2 = 1;
    b1 = (2^(r-1)-1)/2^(r-1);
    M_alpha2 = min(floor(nboot^(al-1)),floor((nboot-1)/(r-1)));
    li2 = [];
    for i = (floor(b1*M_alpha)+1):M_alpha
            item = zeros(nboot,r);
            item(:,1) = 1:nboot;
            for c = 1:(r-1)
                item(:,c+1) =item(:,1)+(2^c-1)*i;
            end
            item = mod(item-1,nboot)+1;
            li2 = [li2;item];
    end 
    li_hat = [];
    for i = 1:M_alpha2
            item = zeros(nboot,r);
            item(:,1) = 1:nboot;
            for c = 1:r-1
                item(:,c+1) = item(:,1)+i*c;
            end
            item = mod(item-1,nboot)+1;
            li_hat = [li_hat;item];
    end
	for i= 1:boot
		indexn = datasample(1:n, nboot, 'Replace', true);
		x_new = x(indexn);
		h_vec = motif(x_new(li_hat),type)';
		h_vec2 = motif(x_new(li2),type)';
		mu_hat_new = mean(h_vec2);
		mu_hat_esti = mean(h_vec);
		[al_value,al_number] = h_redu(li_hat, h_vec, nboot);
		al_weight = al_value./al_number;
		ksei2 = mean(( al_weight - mu_hat_esti).^2);
		var_all_new = (ksei2*r^2)/nboot;
		t_mc_other(i,1) = (mu_hat_new - mu_hat)/sqrt(var_all_new);
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
	timeCI5(k,m) = toc;



end


end




save(sprintf('./result/all_comparison2_%d_al_%d_%s_deter_subsample',n,al*100,type),"timeCI5","cover5","coverlg5")