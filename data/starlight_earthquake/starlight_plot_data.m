
addpath('subroutines');

setup
% seednumber = 1
% cluster = 1
tic;
clc;
percent = 0.1;
al = 1.5;
randomness = 1;
r= 2;
type = "starlight";
curve_train = readmatrix('data/StarLightCurves_TRAIN.tsv', 'Delimiter','\t', 'FileType','text');
curve_test  = readmatrix('data/StarLightCurves_TEST.tsv',  'Delimiter','\t', 'FileType','text');

all_curves = [curve_train;curve_test];
all_types  = round(all_curves(:,1));
all_curves(:,1) = [];
fit_index = 1:16:1024;
all_curves = all_curves(:,fit_index);

rng(seednumber);

type_all_curves = {};
for i = 1:3
    type_all_curves{i} = all_curves(all_types==i,:);
end

MC_times = 20;
CI_all =  zeros(MC_times,2);
timecost =  zeros(MC_times,1);
for k = 1:MC_times
    tic;
    [q_l,q_u] = CI_ustat_new(percent,type_all_curves{cluster}, al, randomness,type,r);
    CI_all(k,1) = q_l;
    CI_all(k,2) = q_u;
    timecost(k,1) = toc;
 end
save(strcat('./result/all_innerdistance',string(MC_times),string(cluster),'_',string(al*10)),"CI_all","timecost");
