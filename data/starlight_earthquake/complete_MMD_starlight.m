
addpath('subroutines');
addpath('package');

setup

tic;
clc;

r= 2;
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

type = "starlight";
n1 = size(type_all_curves{cluster1},1);
n2 = size(type_all_curves{cluster2},1);

tic;
mu_true = complete_u(n1,n2, type_all_curves{cluster1}, type_all_curves{cluster2},type);
timecost = toc;
save(strcat('./result/bt_cluster',string(cluster1),'_',string(cluster2),'true'),"mu_true","timecost");