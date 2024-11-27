
addpath('subroutines');

setup


train = tsvread("data/Earthquakes_TRAIN.tsv");
test = tsvread("data/Earthquakes_TEST.tsv");
all_data = [train;test];
class_y = all_data(:,1);
all_data = all_data(:,2:end);

type_all_curves = {};
for i = 1:2
    type_all_curves{i} = all_data(class_y==(i-1),:);
end


percent = 0.1;
al = 1.5;
r = 2;
randomness = 1;
length_date_all = [5,6,7,8];
fit_index = 1:4:512;

rng(seednumber);

MC_times = 20;
CI_all = zeros(MC_times,2,size(length_date_all,2));
timecost = zeros(MC_times,size(length_date_all,2));
mu_hat_all = zeros(MC_times,size(length_date_all,2));

data1 = type_all_curves{cluster};

for l = 1:size(length_date_all,2)
    for k = 1:MC_times
        data_ave1 = zeros(size(data1));
        tic;
        length_date = length_date_all(l);
        type = 'starlight';
        for i = 1:size(data1,1)
            data_ave1(i,:) = movmean(data1(i,:),length_date);
        end
        data_ave1 = data_ave1(:,fit_index);
        [q_l,q_u] = CI_ustat_new(percent,data_ave1, al, randomness,type,r);
        CI_all(k,1,l) = q_l;
        CI_all(k,2,l) = q_u;
        timecost(k,l) = toc;
    end
end
save(strcat("./result/result_earthquake_inner",string(cluster),string(MC_times),string(seednumber)),"CI_all","timecost")

