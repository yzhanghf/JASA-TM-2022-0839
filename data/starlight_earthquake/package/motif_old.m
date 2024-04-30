function [result_f]= motif(data,type,list1)
    for i = 1:size(list1,1)
        xxx = data(list1(i,1),:);
        yyy = data(list1(i,2),:);
        timeline = linspace(0,1,length(yyy));
        xxx = xxx(:);
        yyy = yyy(:);
        timeline = timeline(:);
        switch type
            case 'starlight'
            yyy_align =  pairwise_align(xxx,yyy,timeline);
            q_x = f_to_srvf(xxx,timeline);
            q_y = f_to_srvf(yyy_align,timeline);
            f = norm(q_x-q_y,'fro');
        end
        result_f(i,1) = f;
    end
end
