
addpath('subroutines');
addpath('package');

tic;
train = tsvread("./data/Earthquakes_TRAIN.tsv");
test = tsvread("./data/Earthquakes_TEST.tsv");
all_data = [train;test];
class_y = all_data(:,1);
data1 = all_data(class_y==1,2:end);
data0 = all_data(class_y==0,2:end);
data_ori = {};
data_ori{1} = data1;
data_ori{2} = data0;
length_date_all = [5,6,7,8];
% length_date_all = [5];
xlabelall = [128,256,384,512];
% for i = 1:sample_n
%     data_ave(i,:) = movmean(data1(i,:),length_date);
% end
linewidth1 = 2;
ylabelsize = 16;
typeall = [1,0];
legendtype = ["Major earthquake","Non-major earthquake"];
for k = 1:length(length_date_all)
    length_date = length_date_all(k);
    for i = 1:2
    %     subplot(3,1,i)
        fig = figure('Position', [10, 10, 600, 600]);
        tlo = tiledlayout(3,1,'InnerPosition',[0.085,0.2,0.5,0.5],'Position',[0.12,0.14,0.82,0.7]);        
        h = gobjects(1,3);
        X = 1:size(data_ori{i},2);
        X = 1/size(data_ori{i},2)*X;
    
        fit = 1/size(data_ori{i},2):4/size(data_ori{i},2):1;
        fit_whole = 1/size(data_ori{i},2):1/size(data_ori{i},2):1;
        fitindex = 1:4:size(data_ori{i},2);
        for t = 1:3
            % Create plots.
            ax = nexttile;
            data_ave = movmean(data_ori{i}(t,:),length_date);
             if t== 1
                h(t) =plot(fit_whole, data_ori{i}(t,:),'color','b','LineWidth',linewidth1);
                hold on;
                h(t) =plot(fit, data_ave(fitindex),'color','r','LineWidth',linewidth1);
                ylabel('','FontSize', ylabelsize) 
                set(gca,'Xticklabel',[])
                set(gca,'FontSize',ylabelsize);
                legend("Raw","Smoothed",'Location','north','FontSize', 18,'Orientation','horizontal')
                ylim([0 5])
                yticks([1,3,5]);  yticklabels([1,3,5]);
%                 pbaspect([5 1 1])
             elseif t~= 3
                h(t) =plot(fit_whole, data_ori{i}(t,:),'color','b','LineWidth',linewidth1);
                hold on;
                h(t) =plot(fit, data_ave(fitindex),'color','r','LineWidth',linewidth1);
                ylabel('','FontSize',  ylabelsize) 
                set(gca,'FontSize',ylabelsize);
                set(gca,'Xticklabel',[])
                ylim([0 5])
                yticks([1,3,5]);  yticklabels([1,3,5]);
%                 pbaspect([5 1 1])
            else
                h(t) =plot(fit_whole, data_ori{i}(t,:),'color','b','LineWidth',linewidth1);
                hold on;
                h(t) =plot(fit, data_ave(fitindex),'color','r','LineWidth',linewidth1);
                ylabel('','FontSize',  ylabelsize) 
                set(gca,'FontSize',ylabelsize);
                ylim([0 5])
                xticks(1/512.*xlabelall);  xticklabels(xlabelall);yticks([1,3,5]);  yticklabels([1,3,5]);
 
            end
        end
        % Add shared title and axis labels
        title(tlo,strcat(legendtype(i),', $\ell$ = ',string(length_date)),'FontSize', 28,'interpreter','latex')
        xlabel(tlo,'Time','FontSize', 25)
        ylabel(tlo,'Reading','FontSize', 25)

        % Move plots closer together
        % xticklabels(ax,{})
        tlo.TileSpacing = 'compact';
        saveas(h(t),strcat("./plot/earthquake_type",string(typeall(i)),"_",string(length_date),".png"))
    end
end


for k = 1:length(length_date_all)
    length_date = length_date_all(k);
    for i = 1:2
    %     subplot(3,1,i)
        fig = figure('Position', [10, 10, 600, 600]);
        tlo = tiledlayout(3,1,'InnerPosition',[0.085,0.2,0.5,0.5],'Position',[0.12,0.14,0.82,0.7]);        
        h = gobjects(1,3);
        X = 1:size(data_ori{i},2);
        X = 1/size(data_ori{i},2)*X;
    
        fit = 1/size(data_ori{i},2):4/size(data_ori{i},2):1;
        fit_whole = 1/size(data_ori{i},2):1/size(data_ori{i},2):1;
        fitindex = 1:4:size(data_ori{i},2);
        for t = 1:3
            % Create plots.
            ax = nexttile;
            data_ave = movmean(data_ori{i}(t,:),length_date);
             if t== 1
                h(t) =plot(fit_whole, data_ori{i}(t,:),'color','b','LineWidth',linewidth1);
                hold on;
                h(t) =plot(fit, data_ave(fitindex),'color','r','LineWidth',linewidth1);
                ylabel('','FontSize', ylabelsize) 
                set(gca,'Xticklabel',[])
                set(gca,'FontSize',ylabelsize);
%                 legend("Raw","Smoothed",'Location','north','FontSize', 18,'Orientation','horizontal')
                ylim([0 5])
                yticks([1,3,5]);  yticklabels([1,3,5]);
%                 pbaspect([5 1 1])
             elseif t~= 3
                h(t) =plot(fit_whole, data_ori{i}(t,:),'color','b','LineWidth',linewidth1);
                hold on;
                h(t) =plot(fit, data_ave(fitindex),'color','r','LineWidth',linewidth1);
                ylabel('','FontSize',  ylabelsize) 
                set(gca,'FontSize',ylabelsize);
                set(gca,'Xticklabel',[])
                ylim([0 5])
                yticks([1,3,5]);  yticklabels([1,3,5]);
%                 pbaspect([5 1 1])
            else
                h(t) =plot(fit_whole, data_ori{i}(t,:),'color','b','LineWidth',linewidth1);
                hold on;
                h(t) =plot(fit, data_ave(fitindex),'color','r','LineWidth',linewidth1);
                ylabel('','FontSize',  ylabelsize) 
                set(gca,'FontSize',ylabelsize);
                ylim([0 5])
                xticks(1/512.*xlabelall);  xticklabels(xlabelall);yticks([1,3,5]);  yticklabels([1,3,5]);
 
            end
        end
        % Add shared title and axis labels
        title(tlo,strcat(legendtype(i),', $\ell$ = ',string(length_date)),'FontSize', 28,'interpreter','latex')
        xlabel(tlo,'Time','FontSize', 25)
        ylabel(tlo,'Reading','FontSize', 25)

        % Move plots closer together
        % xticklabels(ax,{})
        tlo.TileSpacing = 'compact';
        saveas(h(t),strcat("./plot/earthquake_type",string(typeall(i)),"_",string(length_date),"nonlegend.png"))
    end
end

timecost = toc;
save(strcat("./result/earthquake_type"), "timecost")
