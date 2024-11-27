function [result_f]= motif_group(data1, data2 ,type,list1)
    switch type 
    case "starlight"
        sigma = 100;
    case "earthquake_MMD"
        sigma = 5000;
    end
    result_f = zeros(size(list1,1),1);
    for i = 1:size(list1,1)
        x1 = data1(list1(i,1),:);
        y1 = data2(list1(i,1),:);
        x2 = data1(list1(i,2),:);
        y2 = data2(list1(i,2),:);     
        timeline = linspace(0,1,length(x1));
        timeline = timeline(:);
        
        x_k = x1(:);
        x_l = x2(:);
        x_l_align =  pairwise_align(x_k,x_l,timeline);
        q_x = f_to_srvf(x_k,timeline);
        q_y = f_to_srvf(x_l_align,timeline);
        middlex1x2_1 = norm(q_x-q_y,'fro');
        
        x_k = x2(:);
        x_l = x1(:);
        x_l_align =  pairwise_align(x_k,x_l,timeline);
        q_x = f_to_srvf(x_k,timeline);
        q_y = f_to_srvf(x_l_align,timeline);
        middlex1x2_2 = norm(q_x-q_y,'fro');
        middlex1x2 = (middlex1x2_1+middlex1x2_2)/2;
        
        
        x_k = y1(:);
        x_l = y2(:);
        x_l_align =  pairwise_align(x_k,x_l,timeline);
        q_x = f_to_srvf(x_k,timeline);
        q_y = f_to_srvf(x_l_align,timeline);
        middley1y2_1 = norm(q_x-q_y,'fro');
        
        x_k = y2(:);
        x_l = y1(:);
        x_l_align =  pairwise_align(x_k,x_l,timeline);
        q_x = f_to_srvf(x_k,timeline);
        q_y = f_to_srvf(x_l_align,timeline);
        middley1y2_2 = norm(q_x-q_y,'fro');
        middley1y2 = (middley1y2_1+middley1y2_2)/2;
        
        x_k = x1(:);
        x_l = y2(:);
        x_l_align =  pairwise_align(x_k,x_l,timeline);
        q_x = f_to_srvf(x_k,timeline);
        q_y = f_to_srvf(x_l_align,timeline);
        middlex1y2_1 = norm(q_x-q_y,'fro');
        
        x_k = y2(:);
        x_l = x1(:);
        x_l_align =  pairwise_align(x_k,x_l,timeline);
        q_x = f_to_srvf(x_k,timeline);
        q_y = f_to_srvf(x_l_align,timeline);
        middlex1y2_2 = norm(q_x-q_y,'fro');
        middlex1y2 = (middlex1y2_1+middlex1y2_2)/2;
        
        
        x_k = x2(:);
        x_l = y1(:);
        x_l_align =  pairwise_align(x_k,x_l,timeline);
        q_x = f_to_srvf(x_k,timeline);
        q_y = f_to_srvf(x_l_align,timeline);
        middlex2y1_1 = norm(q_x-q_y,'fro');
        
        x_k = y1(:);
        x_l = x2(:);
        x_l_align =  pairwise_align(x_k,x_l,timeline);
        q_x = f_to_srvf(x_k,timeline);
        q_y = f_to_srvf(x_l_align,timeline);
        middlex2y1_2 = norm(q_x-q_y,'fro');
        middlex2y1 = (middlex2y1_1+middlex2y1_2)/2;
        
        f = exp(-middlex1x2^2/sigma)+exp(-middley1y2^2/sigma)-exp(-middlex1y2^2/sigma)-exp(-middlex2y1^2/sigma);
        result_f(i,1) = f;
    end
end
