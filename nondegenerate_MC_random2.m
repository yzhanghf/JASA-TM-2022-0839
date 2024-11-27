
addpath('subroutine');

rng(1)
r = 3;
itern = 10^6;



type = 'Sine';

tstat = zeros(itern,1);

for i = 1:itern
    x = sampling(n,type);
    li2 = randomsamle(n,al);
    h_vec = motif(x(li2),type)';
    mu_hat = mean(h_vec);
    [al_value,al_number] = h_redu(li2, h_vec, n);
    al_weight = al_value./(al_number+1e-10);
    ksei2 = mean(( al_weight - mu_hat).^2);
    if ksei2 <= 0
        tstat(i,1) = NaN;
    else
        mu_true = get_mean(type);
        var_all = sum(al_number.^2)/(floor(n^al)^2)*ksei2;
        tstat(i,1) = (mu_hat - mu_true)/sqrt(var_all);
    end
end


writematrix(tstat,strcat("./result/nondegenerate_MC_random2",string(n),"_", string(al*100),type,".csv"));
