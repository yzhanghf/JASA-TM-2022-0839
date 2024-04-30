setup


train = tsvread("Earthquakes_TRAIN.tsv");
test = tsvread("Earthquakes_TEST.tsv");
all_data = [train;test];
class_y = all_data(:,1);
data1 = all_data(class_y==1,2:end);
data0 = all_data(class_y==0,2:end);
percent = 0.1;
al = 1.5;
r = 2;
randomness = 1;
[sample_n, time_n] = size(data1);
data_ave1 = zeros(size(data1));
data_ave0 = zeros(size(data1));
select_num = size(data1,1);
seednumber = 10;
rng(seednumber);

MC_times = 20;
CI_all = zeros(MC_times,2,1);
timecost = zeros(MC_times,1);
mu_hat_all = zeros(MC_times,1);



for k = 1:MC_times
    data_ave1 = zeros(sample_n, time_n);
    data_ave0 = zeros(sample_n, time_n);
    tic;
    data0 = data0(datasample(1:size(data0,1),select_num,'Replace',false),:);
    type = 'earthquake_MMD';
    for i = 1:sample_n
        data_ave1(i,:) = movmean(data1(i,:),length_date);
    end
    fit_index = 1:4:512;
    data_ave1 = data_ave1(:,fit_index);
    for i = 1:sample_n
        data_ave0(i,:) = movmean(data0(i,:),length_date);
    end
    data_ave0 = data_ave0(:,fit_index);
    [q_l,q_u,mu_hat] = CI_ustat_group(percent,data_ave1,data_ave0, al, randomness,type,r);
    CI_all(k,1,1) = q_l;
    CI_all(k,2,1) = q_u;
    mu_hat_all(k,1)= mu_hat;
    timecost(k,1) = toc;
end

save(strcat("./data/starlight_earthquake/result/result_earthquake_new",string(length_date),string(MC_times),string(seednumber)),"CI_all","timecost","mu_hat_all")

