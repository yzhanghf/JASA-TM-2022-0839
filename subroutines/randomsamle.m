function [Ir_list,output_check_OK] = randomsamle(n,alpha)
    N = floor(n^alpha);
    output_check_OK = false;

    Ir_list = [];
    while ~output_check_OK
        raw_x = rand(floor(1.5*N),1);
        raw_x = floor(raw_x*n^3);
        i1_list = floor(raw_x/n^2);
        raw_y = raw_x - i1_list*n^2;
        i2_list = floor(raw_y/n);
        raw_z = raw_y - i2_list*n;
        i3_list = floor(raw_z);
        keep_elem = ones(size(i1_list));
        keep_elem(i1_list==i2_list) = 0;
        keep_elem(i1_list==i3_list) = 0;
        keep_elem(i2_list==i3_list) = 0;
        keep_elem(i1_list==0) = 0;
        keep_elem(i2_list==0) = 0;
        keep_elem(i3_list==0) = 0;
        Ir_list1 = [i1_list, i2_list, i3_list];
        Ir_list1 = Ir_list1(keep_elem>0.5,:);
        Ir_list = [Ir_list; Ir_list1];
        
        if(size(Ir_list,1)>=N)
            output_check_OK = true;
            Ir_list = Ir_list(1:N,:)+1;
        end 
    end

end

