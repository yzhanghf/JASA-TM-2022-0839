function [mu_true] = complete_u3(m,n, data1, data2,type)
    switch type 
    case "starlight"
        sigma = 100;
    case "earthquake_MMD"
        sigma = 5000;
    end
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
    mu_true = 2*mu_true3;                        
end