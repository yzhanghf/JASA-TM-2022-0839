
addpath('subroutine');

rng(1)
r = 3;
itern = 10^6;
b2 = 1;
b1 = (2^(r-1)-1)/2^(r-1);
type = 'Sine';

M_alpha = min(floor(n^(al-1)),floor((n-1)/(2^(r-1)-1)));
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

tstat = zeros(itern,1);

for i = 1:itern
    x = sampling(n,type);
    mu_hat_esti = mean(motif(x(li_hat),type));
    h_vec = motif(x(li_hat),type)';
    h_vec2 = motif(x(li2),type)';
    mu_hat = mean(h_vec2);
    [al_value,al_number] = h_redu(li_hat, h_vec, n);
    al_weight = al_value./al_number;
    ksei2 = mean(( al_weight - mu_hat_esti).^2);
   if ksei2 <= 0
        tstat(i,1) = NaN;
    else
        mu_true = get_mean(type);
        var_all = (ksei2*r^2)/n;
        tstat(i,1) = (mu_hat - mu_true)/sqrt(var_all);
    end
end

writematrix(tstat,strcat("./result/nondegenerate_MC3",string(n),"_", string(al*100),type,".csv"));


