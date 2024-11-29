
addpath('subroutines');
addpath('package');

setup

tic;
train = tsvread("data/Earthquakes_TRAIN.tsv");
test = tsvread("data/Earthquakes_TEST.tsv");
all_data = [train;test];
class_y = all_data(:,1);
data1 = all_data(class_y==1,2:end);
data0 = all_data(class_y==0,2:end);
percent = 0.1;
r = 2;
[sample_n, time_n] = size(data1);
length_date_all = [7];
data_ave1 = zeros(size(data1));
data_ave0 = zeros(size(data1));
select_num = size(data1,1);


MC_times = 1;
CI_all = zeros(2,size(length_date_all,2));
for l = 1:size(length_date_all,2)
    length_date = length_date_all(l);
    data0 = data0(datasample(1:size(data0,1),select_num,'Replace',false),:);
    type = 'earthquake_MMD';
    for i = 1:sample_n
        data_ave1(i,:) = movmean(data1(i,:),length_date);
    end
    for i = 1:sample_n
        data_ave0(i,:) = movmean(data0(i,:),length_date);
    end
    
    [q_l,q_u,mu_hat] = CI_ustat_group_complete(percent,data_ave0,data_ave1, type,r,select_num);
    CI_all(1,l) = q_l;
    CI_all(2,l) = q_u;
end
timeend = toc;
save("./result/result_earthquake_complete_new","CI_all","timeend","mu_hat")


