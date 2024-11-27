
addpath('subroutine');

r = 3;
percent = 0.1;
itern = 3000;
iterc = 20;

type = "Sine";


timeCI1 = zeros(itern,iterc);
timeCI2 = zeros(itern,iterc);
timeCI3 = zeros(itern,iterc);
cover1 = zeros(itern,iterc);
cover2 = zeros(itern,iterc);
cover3 = zeros(itern,iterc);
coverlg1 = zeros(itern,iterc);
coverlg2 = zeros(itern,iterc);
coverlg3 = zeros(itern,iterc);

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

    li_hat = [];
    for i = 1:M_alpha
            item = zeros(n,r);
            item(:,1) = 1:n;
            for c = 1:r-1
                item(:,c+1) = item(:,1)+i*c;
            end
            item = mod(item-1,n)+1;
            li_hat = [li_hat;item];
    end

    mu_hat_esti = mean(motif(x(li_hat),type));
    mu_2 = mu_hat_esti^2;
    sigma_h2 = mean(motif(x(li_hat),type).^2)-mu_2;
    h_vec = motif(x(li2),type)';
    mu_hat = mean(h_vec);
    [al_value,al_number] = h_redu(li2, h_vec, n);
    al_weight = al_value./al_number;
    ksei2 = mean(( al_weight - mu_hat).^2);
    g_qub = mean(( al_weight - mu_hat).^3);
    intera = 1/size(li2,1)*sum((motif(x(li2),type)-mu_hat-(al_weight(li2(:,1))-mu_hat)-(al_weight(li2(:,r))-mu_hat)).*(al_weight(li2(:,1))-mu_hat).*(al_weight(li2(:,r))-mu_hat));

    if ksei2 <= 0
		cover1(k,m) = NaN;
        coverlg1(k,m) = NaN;
        q_h = NaN;
        q_l = NaN;
    else
        if sigma_h2< 0 || sigma_h2-r*ksei2<0
            cover1(k,m) = NaN;
            coverlg1(k,m) = NaN;
        else
			mu_true = get_mean(type);
			var_all = (ksei2*r^2)/n;
			ksei = sqrt(ksei2);
			[gj_l, gj_u] = confidence_level(percent,ksei, 1,1,sigma_h2, b2,b1, al, g_qub, intera, M_alpha,n,0);
			q_h = mu_hat - sqrt(var_all)*(gj_u);
			q_l = mu_hat - sqrt(var_all)*(gj_l);
            if mu_true>q_l && mu_true < q_h
                cover1(k,m) = 1;
            else
                cover1(k,m) = 0;
            end
			coverlg1(k,m) = q_h - q_l;
		end
    end
    timeCI1(k,m) = toc;


    tic;
     li_hat = [];
    for i = 1:M_alpha
            item = zeros(n,r);
            item(:,1) = 1:n;
            for c = 1:r-1
                item(:,c+1) = item(:,1)+i*c;
            end
            item = mod(item-1,n)+1;
            li_hat = [li_hat;item];
    end


	g2_li = zeros(M_alpha*n,r,2);
    g2_li1 = [];
    g2_li2 = [];
	for i = 1:M_alpha
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
    xx6 = motif(x(g2_li(:,:,1)),type); xx6 = xx6 - mean(xx6);
    xx7 = motif(x(g2_li(:,:,2)),type); xx7 = xx7 - mean(xx7);
    g2 = mean(xx6.*xx7)-2*ksei2;
    M_alpha_new = n^(al-1)*(1+1/(r*n^(al-1)))/(1+n^(al-2)*g2*r*(r-1)/(sigma_h2-r*ksei^2));
    if ksei2 <= 0
		cover2(k,m) = NaN;
        coverlg2(k,m) = NaN;
        q_h = NaN;
        q_l = NaN;	
    else
		mu_true = get_mean(type);
        var_all = sum(al_number.^2)/(floor(n^al)^2)*ksei2;
        if sigma_h2< 0 || sigma_h2-r*ksei2<0
			cover2(k,m) = NaN;
			coverlg2(k,m) = NaN;
        else
            [gj_l, gj_u] = confidence_level(percent,ksei, 1,1,sigma_h2, b2,b1, al, g_qub, intera, M_alpha_new,n,1);
            q_h = mu_hat - sqrt(var_all)*(gj_u);
            q_l = mu_hat - sqrt(var_all)*(gj_l);
			if mu_true>q_l && mu_true < q_h
                cover2(k,m) = 1;
            else
                cover2(k,m) = 0;
            end
            coverlg2(k,m) = q_h - q_l;
        end
    end
    timeCI2(k,m) = toc;


    tic;
    li2 = nchoosek(1:n,r);
    h_vec = motif(x(li2),type)';
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
    if ksei2 <= 0
		cover3(k,m) = NaN;
        coverlg3(k,m) = NaN;
        q_h = NaN;
        q_l = NaN;
    else
        mu_true = get_mean(type);
        var_all = n*nchoosek(n-1,r-1)^2/(nchoosek(n,r)^2)*ksei2;
        ksei = sqrt(ksei2);
        [gj_l, gj_u] = confidence_level(percent,ksei, 1,1,1, 1,1, al, g_qub, intera, 1,n,2);
        q_h = mu_hat - sqrt(var_all)*(gj_u);
        q_l = mu_hat - sqrt(var_all)*(gj_l);
		if mu_true>q_l && mu_true < q_h
            cover3(k,m) = 1;
        else
            cover3(k,m) = 0;
        end
        coverlg3(k,m) = q_h - q_l;
    end
    timeCI3(k,m) = toc;

end
end


save(sprintf('./result/all_comparison2_%d_al_%d_new',n,al*100),"timeCI1","timeCI2","timeCI3","cover1","cover2","cover3","coverlg1","coverlg2","coverlg3")

