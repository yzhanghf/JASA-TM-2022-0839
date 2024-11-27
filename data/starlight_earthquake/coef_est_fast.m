function [U_J,xi_hat, Eg1_cub, Eg1g1g2, sigma_h] = coef_est_fast(i_list, j_list, hij_list,n)
    
    % first sort i<j
    i_list = i_list(:);  j_list = j_list(:);  hij_list = hij_list(:);
    k_list = i_list+j_list; l_list = abs(i_list-j_list);  j_list_new = (l_list+k_list)/2;  i_list_new = k_list-j_list_new;  j_list = j_list_new;  i_list = i_list_new;
%     i_list2 = [i_list;j_list];
%     j_list2 = [j_list;i_list];
%     hij_list2 = [hij_list;hij_list];
%     construct sparse matrices
%     SM_value = sparse(i_list2, j_list2, hij_list2,n,n);
%     SM_index = sparse(i_list2, j_list2, ones(length(i_list2),1),n,n);
    SM_value = sparse(i_list, j_list, hij_list,n,n);
    SM_index = sparse(i_list, j_list, ones(length(i_list),1),n,n);
    SM_value = SM_value'+SM_value;
    SM_index = SM_index'+SM_index;
    
    % g1_hat_list and estimators
    U_J = mean(hij_list);
    sigma_h = std(hij_list);
    g1_hat_list = sum(SM_value,1)./sum(SM_value~=0,1) - U_J;  g1_hat_list = g1_hat_list(:);
    xi_hat = nanstd(g1_hat_list);
%     xi_hat2 = mean(g1_hat_list.^2);
%     xi_hat = sqrt(xi_hat2);
    Eg1_cub = nanmean( g1_hat_list.^3 );
%     g1_hat_new = g1_hat_list;
%     g1_hat_new(isnan(g1_hat_new)) = 0;
%     Eg1g1g2 = g1_hat_new' * SM_value * g1_hat_new / (length(hij_list));
    Eg1g1g2 = (g1_hat_list' * SM_value * g1_hat_list - U_J*g1_hat_list'* g1_hat_list -g1_hat_list'*(g1_hat_list*ones(size(g1_hat_list))')* g1_hat_list -g1_hat_list'*(g1_hat_list'*ones(size(g1_hat_list)))* g1_hat_list ) / (nnz(SM_value));

%     % compute ank1
%     ank_1 = sum(SM_index);  ank_1 = ank_1(:);
% 
%     % compute ank112 (\sum_{1<=i<j<=n}\ank1(i)\ank1(j)\ank2(\{i,j\}))
%     ank_112 = ank_1' * SM_index * ank_1;    
    
    % Some comments (for double checking): 
    % 
    % 1. there is no "n" or "alpha" in
    % this program, because "n" is implicitly the dimension of the
    % SM_value/SM_index matrix (max member of i_list/j_list) and n^alpha,
    % by definition, equals length(hij_list)

end

