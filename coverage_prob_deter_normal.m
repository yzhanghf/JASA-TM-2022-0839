
addpath('subroutine');

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
    M_alpha = min(floor(n^(al-1)),floor((n-1)/(2^(r-1)-1)));
    b2 = 1;
    b1 = (2^(r-1)-1)/2^(r-1);

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
    M_alpha2 = min(floor(n^(al-1)),floor((n-1)/(r-1)));
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


    h_vec2 = motif(x(li2),type)';
    h_vec = motif(x(li_hat),type)';
    mu_hat_esti = mean(h_vec);
    mu_hat = mean(h_vec2);
    [al_value,al_number] = h_redu(li_hat, h_vec, n);
    al_weight = al_value./al_number;
    ksei2 = mean(( al_weight - mu_hat_esti).^2);
    if ksei2 <= 0
		cover1(k,m) = NaN;
        coverlg1(k,m) = NaN;
        q_h = NaN;
        q_l = NaN;
    else
			mu_true = get_mean(type);
			var_all = (ksei2*r^2)/n;
			ksei = sqrt(ksei2);
            z_l = norminv(1-percent/2);
            z_u = norminv(percent/2);
            q_h = mu_hat - sqrt(var_all)*z_u;
            q_l = mu_hat - sqrt(var_all)*z_l;
            if mu_true>q_l && mu_true < q_h
                cover1(k,m) = 1;
            else
                cover1(k,m) = 0;
            end
			coverlg1(k,m) = q_h - q_l;
    end
    timeCI1(k,m) = toc;



end
end


save(sprintf('./result/all_comparison2_%d_al_%d_%s_deter_normal',n,al*100,type),"timeCI1","cover1","coverlg1")
