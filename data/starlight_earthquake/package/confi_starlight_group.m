setup
% seednumber = 1
% cluster1 = 1
% cluster2 = 2
clc;
percent = 0.1;
al = 1.5;
randomness = 1;
r= 2;
type = "starlight";
curve_train = readmatrix('StarLightCurves_TRAIN.tsv', 'Delimiter','\t', 'FileType','text');
curve_test  = readmatrix('StarLightCurves_TEST.tsv',  'Delimiter','\t', 'FileType','text');

all_curves = [curve_train;curve_test];
all_types  = round(all_curves(:,1));
all_curves(:,1) = [];
fit_index = 1:16:1024;
all_curves = all_curves(:,fit_index);


type_all_curves = {};
for i = 1:3
    type_all_curves{i} = all_curves(all_types==i,:);
end


rng(seednumber);

MC_times = 20;
CI_all =  zeros(MC_times,2);
timecost =  zeros(MC_times,1);
mu_hat_all =  zeros(MC_times,1);
for k = 1:MC_times
    tic;
    n2 = size(type_all_curves{cluster2},1);
    n1 = size(type_all_curves{cluster1},1);
    type_curvesnew = type_all_curves{cluster2}(datasample(1:n2,n1,'Replace',false),:);
    [q_l,q_u,mu_hat] = CI_ustat_group(percent,type_all_curves{cluster1},type_curvesnew, al, randomness,type,r);
    CI_all(k,1) = q_l;
    CI_all(k,2) = q_u;
    mu_hat_all(k,1) = mu_hat;
    timecost(k,1) = toc;
 end
save(strcat('./data/starlight_earthquake/result/all_dist_bt_',string(MC_times),'_',string(cluster1),'_',string(cluster2),'_',string(al*10)),"CI_all","timecost","mu_hat_all");