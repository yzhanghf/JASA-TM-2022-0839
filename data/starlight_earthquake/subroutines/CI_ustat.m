
function [q_l, q_h] = CI_ustat(percent,x, al, randomness,type)
    n = size(x,1);
    r = 2;
    M_alpha = floor(n^(al-1));
    if M_alpha*(2^(r-1)-1) >= n
        if n/(2^(r-1)-1) == floor(n/(2^(r-1)-1))
            M_alpha = floor(n/(2^(r-1)-1))-1;
        else
            M_alpha = floor(n/(2^(r-1)-1));
        end
    end
    
    b2 = 1;
    b1 = (2^(r-1)-1)/2^(r-1);
    
    li_hat = zeros(M_alpha*n,r);
    for i = 1:M_alpha
        for j=1:n
            item = zeros(1,r);
            for c = 0:r-1
                itemt = j+i*c;
                item(1,c+1) = itemt-1;
            end
            li_hat((i-1)*n+j,:,1) = mod(item,n)+1;
        end 
    end
    
    var_li = zeros(M_alpha*n,r,2);
    for i = 1:M_alpha
        for j=1:n
            item = zeros(1,r);
            for c = 0:r-1
                itemt = j+i*c;
                item(1,c+1) = itemt-1;
            end
            item2 = zeros(1,r);
            for c = 0:r-1
                itemt = item(end)+i*c;
                item2(1,c+1) = itemt;
            end
            var_li((i-1)*n+j,:,1) = mod(item,n)+1;
            var_li((i-1)*n+j,:,2) = mod(item2,n)+1;
        end
    end
    

    
    %%%%%%%%%%%% estimate some expectation %%%%%%%%%%%%%%%%%%%%%%%
    % accurate = floor(n/(r-1))/M_alpha;
    accurate = 1;

    g_qub_li = zeros(accurate*M_alpha*n,r,3);
    for i = 1:accurate*M_alpha
        for j=1:n
            item = zeros(1,r);
            for c = 0:r-1
                itemt = j+i*c;
                item(1,c+1) = itemt-1;
            end
            item2 = zeros(1,r);
            item2(1,1) = item(1,1) ;
            for c = 1:r-1
                itemt = item(end)+i*c;
                item2(1,c+1) = itemt;
            end
            item3 = zeros(1,r);
            item3(1,1) = item(1,1) ;
            for c = 1:r-1
                itemt = item2(end)+i*c;
                item3(1,c+1) = itemt;
            end
            
            g_qub_li((i-1)*n+j,:,1) = mod(item,n)+1;
            g_qub_li((i-1)*n+j,:,2) = mod(item2,n)+1;
            g_qub_li((i-1)*n+j,:,3) = mod(item3,n)+1;
        end
    end
    
    
    
    g2_li = zeros(accurate*M_alpha*n,r,2);
    for i = 1:accurate*M_alpha
        for j=1:n
            item = zeros(1,r);
            for c = 0:r-1
                itemt = j+i*c;
                item(1,c+1) = itemt-1;
            end
            item2 = zeros(1,r);
            for c = 0:r-1
                itemt = item(end)+i*(c-1);
                item2(1,c+1) = itemt;
            end
            
            g2_li((i-1)*n+j,:,1) = mod(item,n)+1;
            g2_li((i-1)*n+j,:,2) = mod(item2,n)+1;
        end
    end
    
    
    inter_li = zeros(accurate*M_alpha*n,r,3);
    for i = 1:accurate*M_alpha
        for j=1:n
            item = zeros(1,r);
            for c = 0:r-1
                itemt = j+i*c;
                item(1,c+1) = itemt-1;
            end
            item2 = zeros(1,r);
            for c = 0:r-1
                itemt = item(end)+i*c;
                item2(1,c+1) = itemt;
            end
            item3 = zeros(1,r);
            for c = 0:r-1
                itemt = item2(end)+i*c;
                item3(1,c+1) = itemt;
            end
            inter_li ((i-1)*n+j,:,1) = mod(item,n)+1;
            inter_li((i-1)*n+j,:,2) = mod(item2,n)+1;
            inter_li ((i-1)*n+j,:,3) = mod(item3,n)+1;
        end
    end
    switch randomness
        case 0
            li2 = zeros((M_alpha-floor(b1*M_alpha)),r);
            for i = (floor(b1*M_alpha)+1):M_alpha
                for j = 1:n
                    item = zeros(1,r);
                    for c = 0:(r-1)
                        itemt = j+(2^c-1)*i;
                        item(1,c+1) = itemt -1;
                    end
                    li2((i-floor(b1*M_alpha)-1)*n+j,:) = mod(item,n)+1;
                end 
            end
            mu_hat = mean(motif(x,type,li2));
            mu_hat_esti = mean(motif(x,type,li_hat));
            mu_2 = mu_hat_esti^2;
            xx1 = motif(x,type,var_li(:,:,1)); xx1 = xx1 - mean(xx1);
            xx2 = motif(x,type,var_li(:,:,2)); xx2 = xx2 - mean(xx2);
            ksei2 = mean(xx1.*xx2);
            xx3 = motif(x,type,g_qub_li(:,:,1)); xx3 = xx3 - mean(xx3);
            xx4 = motif(x,type,g_qub_li(:,:,2)); xx4 = xx4 - mean(xx4);
            xx5 = motif(x,type,g_qub_li(:,:,3)); xx5 = xx5 - mean(xx5);
            xx6 = motif(x,type,g2_li(:,:,1)); xx6 = xx6 - mean(xx6);
            xx7 = motif(x,type,g2_li(:,:,2)); xx7 = xx7 - mean(xx7);
            xx8 = motif(x,type,inter_li(:,:,1)); xx8 = xx8 - mean(xx8);
            xx9 = motif(x,type,inter_li(:,:,2)); xx9 = xx9 - mean(xx9);
            xx10 = motif(x,type,inter_li(:,:,3)); xx10 = xx10 - mean(xx10);
            g_qub = mean(xx3.*xx4.*xx5);
            intera = mean(xx8.*xx9.*xx10);
            sigma_h2 = mean(motif(x,type,li_hat).^2)-mu_2;
            ksei = sqrt(ksei2);
            var_all = (ksei2*r^2)/n;
            [gj_l, gj_u] = confidence_level(percent,ksei, 1,1,sigma_h2, b2,b1, al, g_qub, intera, M_alpha,n,randomness);
            q_h = mu_hat - sqrt(var_all)*(gj_u);
            q_l = mu_hat - sqrt(var_all)*(gj_l);
        case 1
            li2 = randomsamle(n,al);
            li2_long = reshape(li2,floor(n^al)*r,1 );
            al_number = zeros(n,1);
            for l = 1:n
                al_number(l,1) = sum(li2_long == l);
            end
            mu_hat = mean(motif(x,type,li2));
            mu_hat_esti = mean(motif(x,type,li_hat));
            mu_2 = mu_hat_esti^2;
            xx1 = motif(x,type,var_li(:,:,1)); xx1 = xx1 - mean(xx1);
            xx2 = motif(x,type,var_li(:,:,2)); xx2 = xx2 - mean(xx2);
            ksei2 = mean(xx1.*xx2);
            xx3 = motif(x,type,g_qub_li(:,:,1)); xx3 = xx3 - mean(xx3);
            xx4 = motif(x,type,g_qub_li(:,:,2)); xx4 = xx4 - mean(xx4);
            xx5 = motif(x,type,g_qub_li(:,:,3)); xx5 = xx5 - mean(xx5);
            xx6 = motif(x,type,g2_li(:,:,1)); xx6 = xx6 - mean(xx6);
            xx7 = motif(x,type,g2_li(:,:,2)); xx7 = xx7 - mean(xx7);
            xx8 = motif(x,type,inter_li(:,:,1)); xx8 = xx8 - mean(xx8);
            xx9 = motif(x,type,inter_li(:,:,2)); xx9 = xx9 - mean(xx9);
            xx10 = motif(x,type,inter_li(:,:,3)); xx10 = xx10 - mean(xx10);
            g_qub = mean(xx3.*xx4.*xx5);
            g2 = mean(xx6.*xx7)-2*ksei2;
            intera = mean(xx8.*xx9.*xx10);
            sigma_h2 = mean(motif(x,type,li_hat).^2)-mu_2;
            ksei = sqrt(ksei2);
            var_all = sum(al_number.^2)/(floor(n^al)^2)*ksei2;
            M_alpha_new = n^(al-1)*(1+1/(r*n^(al-1)))/(1+n^(al-2)*g2*r*(r-1)/(sigma_h2-r*ksei^2));
            [gj_l, gj_u] = confidence_level(percent,ksei, 1,1,sigma_h2, 1,1, al, g_qub, intera, M_alpha_new,n,randomness);
            q_h = mu_hat - sqrt(var_all)*(gj_u);
            q_l = mu_hat - sqrt(var_all)*(gj_l);
    end

	end

