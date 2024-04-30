function [Ir_list, output_check_OK] = randsample_new2(n,alpha,r)
    
    N = floor(n^alpha);
    output_check_OK = false;
    while ~output_check_OK
       Ir_list = zeros(floor(5*N),r);
        xxx = rand(floor(5*N),1);
        
        for(ell = 1:r)
            
            digit_ell = floor(xxx*n);
            xxx = xxx - digit_ell/n;
            xxx = xxx*n;
            Ir_list(:,ell) = digit_ell+1;
        
        end
    
        % check repeats
        for(r1 = 1:(r-1))
            for(r2 = (r1+1):r)
                keep_elem = Ir_list(:,r1) == Ir_list(:,r2);
                Ir_list = Ir_list(~keep_elem,:);
            end
        end
        
    
        if(size(Ir_list,1)>=N)
            output_check_OK = true;
            Ir_list = Ir_list(1:N,:);
        end 
    end
end
