function [result_f]= motif(data,type,list1)
    for i = 1:size(list1,1)
        xxx = data(list1(i,1),:);
        yyy = data(list1(i,2),:);
        timeline = linspace(0,1,length(yyy));
        xxx = xxx(:);
        yyy = yyy(:);
        timeline = timeline(:);
        yyy_align =  pairwise_align(xxx,yyy,timeline);
        q_x = f_to_srvf(xxx,timeline);
        q_y = f_to_srvf(yyy_align,timeline);
        f1 = norm(q_x-q_y,'fro');
        
        xxx = data(list1(i,2),:);
        yyy = data(list1(i,1),:);
        timeline = linspace(0,1,length(yyy));
        xxx = xxx(:);
        yyy = yyy(:);
        timeline = timeline(:);
        yyy_align =  pairwise_align(xxx,yyy,timeline);
        q_x = f_to_srvf(xxx,timeline);
        q_y = f_to_srvf(yyy_align,timeline);
        f2 = norm(q_x-q_y,'fro');
        f = (f1+f2)/2;    
            
        result_f(i,1) = f;
    end
end
