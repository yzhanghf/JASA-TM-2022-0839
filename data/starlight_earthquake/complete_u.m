function [mu_true] = complete_u(m,n, data1, data2,type)
    switch type 
    case "starlight"
        sigma = 100;
    case "earthquake_MMD"
        sigma = 5000;
    end
    mu_all1 = zeros(m,m);
    for i = 1:m
        for j = i:m
            if i~= j
                x1 = data1(i,:);
                x2 = data1(j,:);
                timeline = linspace(0,1,length(x1));
                timeline = timeline(:);
                
                x_k = x1(:);
                x_l = x2(:);
                x_l_align =  pairwise_align(x_k,x_l,timeline);
                q_x = f_to_srvf(x_k,timeline);
                q_y = f_to_srvf(x_l_align,timeline);
                distance1 = norm(q_x-q_y,'fro');
                
                x1 = data1(j,:);
                x2 = data1(i,:);
                timeline = linspace(0,1,length(x1));
                timeline = timeline(:);
                
                x_k = x1(:);
                x_l = x2(:);
                x_l_align =  pairwise_align(x_k,x_l,timeline);
                q_x = f_to_srvf(x_k,timeline);
                q_y = f_to_srvf(x_l_align,timeline);
                distance2 = norm(q_x-q_y,'fro');
                
                distance = (distance1+distance2)/2;
                 mu_all1(i,j) = exp(-distance^2/sigma);
            end
        end
    end
    mu_true1 = 2*sum(sum(mu_all1))/m/(m-1);
    
     mu_all2 = zeros(n,n);
    for i = 1:n
        for j = i:n
            if i~= j
                x1 = data2(i,:);
                x2 = data2(j,:);
                timeline = linspace(0,1,length(x1));
                timeline = timeline(:);
                
                x_k = x1(:);
                x_l = x2(:);
                x_l_align =  pairwise_align(x_k,x_l,timeline);
                q_x = f_to_srvf(x_k,timeline);
                q_y = f_to_srvf(x_l_align,timeline);
                distance1 = norm(q_x-q_y,'fro');
                
                
                x1 = data2(j,:);
                x2 = data2(i,:);
                timeline = linspace(0,1,length(x1));
                timeline = timeline(:);
                
                x_k = x1(:);
                x_l = x2(:);
                x_l_align =  pairwise_align(x_k,x_l,timeline);
                q_x = f_to_srvf(x_k,timeline);
                q_y = f_to_srvf(x_l_align,timeline);
                distance2 = norm(q_x-q_y,'fro');
                distance = (distance1+distance2)/2;
                
                 mu_all2(i,j) = exp(-distance^2/sigma);
            end
        end
    end
    mu_true2 = 2*sum(sum(mu_all2))/n/(n-1);
     mu_all3 = zeros(m,n);
    for i = 1:m
        for j = 1:n
            x1 = data1(i,:);
            x2 = data2(j,:);
            timeline = linspace(0,1,length(x1));
            timeline = timeline(:);
            
            x_k = x1(:);
            x_l = x2(:);
            x_l_align =  pairwise_align(x_k,x_l,timeline);
            q_x = f_to_srvf(x_k,timeline);
            q_y = f_to_srvf(x_l_align,timeline);
            distance1 = norm(q_x-q_y,'fro');
            
            
            x_k = x2(:);
            x_l = x1(:);
            x_l_align =  pairwise_align(x_k,x_l,timeline);
            q_x = f_to_srvf(x_k,timeline);
            q_y = f_to_srvf(x_l_align,timeline);
            distance2 = norm(q_x-q_y,'fro');
            distance = (distance1+distance2)/2;
            
            
             mu_all3(i,j) = exp(-distance^2/sigma);
        end
    end
    mu_true3 = sum(sum(mu_all3))/m/n;
    mu_true = mu_true1 +mu_true2 - 2*mu_true3;                        
end