
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


	g2_li = zeros(M_alpha2*n,r,2);
    g2_li1 = [];
    g2_li2 = [];
	for i = 1:M_alpha2
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

    [li2,check] = randomsamle(n,al);
    if check
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
        xx6 = motif(x(g2_li(:,:,1)),type); xx6 = xx6 - mean(xx6)-(al_weight(g2_li(:,(r-1),1))-mu_hat)-(al_weight(g2_li(:,r,1))-mu_hat);
        xx7 = motif(x(g2_li(:,:,2)),type); xx7 = xx7 - mean(xx7)-(al_weight(g2_li(:,1,2))-mu_hat)-(al_weight(g2_li(:,2,2))-mu_hat);
        g2 = mean(xx6.*xx7) ;
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
    else
		cover2(k,m) = NaN;
        coverlg2(k,m) = NaN;
        timeCI2(k,m) = NaN;
    end


end
end


save(sprintf('./result/all_comparison2_%d_al_%d_%s_new3',n,al*100,type),"timeCI1","timeCI2","cover1","cover2","coverlg1","coverlg2")
