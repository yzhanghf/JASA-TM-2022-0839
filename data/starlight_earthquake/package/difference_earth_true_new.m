setup


train = tsvread("Earthquakes_TRAIN.tsv");
test = tsvread("Earthquakes_TEST.tsv");
all_data = [train;test];
class_y = all_data(:,1);
data1 = all_data(class_y==1,2:end);
data0 = all_data(class_y==0,2:end);
[sample_n, time_n] = size(data1);
[sample_m, time_n] = size(data0);



CI_all = zeros(2,1);
timecost = zeros(1,1);
mu_true = zeros(1,1);

type = 'earthquake_MMD';
data_ave1 = zeros(size(data1));
data_ave0 = zeros(size(data0));
tic;
for i = 1:sample_n
    data_ave1(i,:) = movmean(data1(i,:),length_date);
end
fit_index = 1:4:512;
data_ave1 = data_ave1(:,fit_index);
for i = 1:sample_m
    data_ave0(i,:) = movmean(data0(i,:),length_date);
end
data_ave0 = data_ave0(:,fit_index);
mu_true(1,1) = complete_u3(sample_n,sample_m, data_ave1, data_ave0,type);
timecost(1,1) = toc;

save(strcat("./data/starlight_earthquake/result/result_earthquake_true_term3",string(length_date)),"mu_true","timecost")

