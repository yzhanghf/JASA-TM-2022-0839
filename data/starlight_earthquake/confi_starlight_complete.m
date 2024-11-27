
addpath('subroutines');

setup

tic;
clc;
percent = 0.1;
randomness = 0;
r= 2;
type = "starlight";
curve_train = readmatrix('data/StarLightCurves_TRAIN.tsv', 'Delimiter','\t', 'FileType','text');
curve_test  = readmatrix('data/StarLightCurves_TEST.tsv',  'Delimiter','\t', 'FileType','text');

all_curves = [curve_train;curve_test];
all_types  = round(all_curves(:,1));
all_curves(:,1) = [];
fit_index = 1:16:1024;
all_curves = all_curves(:,fit_index);


type_all_curves = {};
for i = 1:3
    type_all_curves{i} = all_curves(all_types==i,:);
end


[q_l,q_u,mu_hat] = CI_ustat_complete(percent,type_all_curves{cluster}, type,r,size(type_all_curves{cluster},1));
[q_l,q_u]
timecost = toc;
save(strcat('./result/cluster',string(cluster),'CIless_comp'),"q_l","q_u","timecost","mu_hat");