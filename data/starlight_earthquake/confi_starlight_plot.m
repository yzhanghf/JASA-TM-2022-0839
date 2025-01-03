
addpath('subroutines');
addpath('package');



percent = 0.1;
al = 1.5;
randomness = 0;
type = "starlight";
curve_train = readmatrix('data/StarLightCurves_TRAIN.tsv', 'Delimiter','\t', 'FileType','text');
curve_test  = readmatrix('data/StarLightCurves_TEST.tsv',  'Delimiter','\t', 'FileType','text');

all_curves = [curve_train;curve_test];
all_types  = round(all_curves(:,1));
all_curves(:,1) = [];

type_1_curves = all_curves(all_types==1,:);
type_2_curves = all_curves(all_types==2,:);
type_3_curves = all_curves(all_types==3,:);

type_all_curves = {};
for i = 1:3
    type_all_curves{i} = all_curves(all_types==i,:);
end
linewidth1 = 2;
ylabelsize = 16;
xlabelall = [256,512,768,1024];

for i = 1:3
%     subplot(3,1,i)
    fig = figure('Position', [10, 10, 600, 600]);
    tlo = tiledlayout(3,1,'InnerPosition',[0.085,0.2,0.5,0.5],'Position',[0.12,0.14,0.82,0.7]);
    h = gobjects(1,3);
    X = 1:size(type_all_curves{i},2);
    X = 1/size(type_all_curves{i},2)*X;
    fit = 1/size(type_all_curves{i},2):8/size(type_all_curves{i},2):1;
    fit_whole = 1/size(type_all_curves{i},2):1/size(type_all_curves{i},2):1;
    fitindex = 1:8:size(type_all_curves{i},2);
    for t = 1:3
        % Create plots.
        ax = nexttile;

    %     f = fit(X,type_1_curves(1,:),"smoothingspline");
%         f = spline(X, type_all_curves{i}(t,:),fit);
%         h(t) =plot(fit,f,'linewidth',2,'color','b');
%         hold on;
        if t== 1
            h(t) =plot(fit_whole, type_all_curves{i}(t,:),'color','b','LineWidth',linewidth1);
%             hold on;
%             h(t) =plot(fit, type_all_curves{i}(t,fitindex),'color','r','LineStyle',':','LineWidth',linewidth1);
            ylabel('','FontSize', 17) 
            set(gca,'Xticklabel',[]) 
                            set(gca,'FontSize',ylabelsize);
            legend("Raw",'Location','northeast','FontSize', 18,'Orientation','horizontal')
        elseif t~= 3
            h(t) =plot(fit_whole, type_all_curves{i}(t,:),'color','b','LineWidth',linewidth1);
%             hold on;
%             h(t) =plot(fit, type_all_curves{i}(t,fitindex),'color','r','LineStyle',':','LineWidth',linewidth1);
            ylabel('','FontSize', 17) 
                            set(gca,'FontSize',ylabelsize);
            set(gca,'Xticklabel',[]) 
        else
            h(t) =plot(fit_whole, type_all_curves{i}(t,:),'color','b','LineWidth',linewidth1);
%             hold on;
%             h(t) =plot(fit, type_all_curves{i}(t,fitindex),'color','r','LineStyle',':','LineWidth',linewidth1);
            ylabel('','FontSize', 17)  
                            set(gca,'FontSize',ylabelsize);
                            xticks(1/1024.*xlabelall);  xticklabels(xlabelall);
        end
    end
    % Add shared title and axis labels
    title(tlo,sprintf('Type %d star',i),'FontSize', 28,'interpreter','latex')
    xlabel(tlo,'Time','FontSize', 25)
    ylabel(tlo,'Brightness','FontSize', 25)
%     legend("Original","Reduced",'Location','southoutside','FontSize', 18,'Orientation','horizontal')
    
    
    % Move plots closer together
    % xticklabels(ax,{})
    tlo.TileSpacing = 'compact';
    saveas(h(t),strcat("./plot/starlight_type",string(i),".png"))
end

% 
for i = 1:3
%     subplot(3,1,i)
    fig = figure('Position', [10, 10, 600, 600]);
    tlo = tiledlayout(3,1,'InnerPosition',[0.085,0.2,0.5,0.5],'Position',[0.12,0.14,0.82,0.7]);
    
    h = gobjects(1,3);
    X = 1:size(type_all_curves{i},2);
    X = 1/size(type_all_curves{i},2)*X;
    fit = 1/size(type_all_curves{i},2):8/size(type_all_curves{i},2):1;
    fit_whole = 1/size(type_all_curves{i},2):1/size(type_all_curves{i},2):1;
    fitindex = 1:8:size(type_all_curves{i},2);
    for t = 1:3
        % Create plots.
        ax = nexttile;

    %     f = fit(X,type_1_curves(1,:),"smoothingspline");
%         f = spline(X, type_all_curves{i}(t,:),fit);
%         h(t) =plot(fit,f,'linewidth',2,'color','b');
%         hold on;
        if t== 1
            h(t) =plot(fit_whole, type_all_curves{i}(t,:),'color','b','LineWidth',linewidth1);
%             hold on;
%             h(t) =plot(fit, type_all_curves{i}(t,fitindex),'color','r','LineStyle',':','LineWidth',linewidth1);
            ylabel('','FontSize', 15) 
            set(gca,'Xticklabel',[]) 
                            set(gca,'FontSize',ylabelsize);
%             legend("Raw",'Location','northeast','FontSize', 18,'Orientation','horizontal')
        elseif t~= 3
            h(t) =plot(fit_whole, type_all_curves{i}(t,:),'color','b','LineWidth',linewidth1);
%             hold on;
%             h(t) =plot(fit, type_all_curves{i}(t,fitindex),'color','r','LineStyle',':','LineWidth',linewidth1);
            ylabel('','FontSize', 15) 
                            set(gca,'FontSize',ylabelsize);
            set(gca,'Xticklabel',[]) 
        else
            h(t) =plot(fit_whole, type_all_curves{i}(t,:),'color','b','LineWidth',linewidth1);
%             hold on;
%             h(t) =plot(fit, type_all_curves{i}(t,fitindex),'color','r','LineStyle',':','LineWidth',linewidth1);
            ylabel('','FontSize', 15)  
                            set(gca,'FontSize',ylabelsize);
                            xticks(1/1024.*xlabelall);  xticklabels(xlabelall);
        end
    end
    % Add shared title and axis labels
    title(tlo,sprintf('Type %d star',i),'FontSize', 28,'interpreter','latex')
    xlabel(tlo,'Time','FontSize', 25)
    ylabel(tlo,'Brightness','FontSize', 25)
%     legend("Original","Reduced",'Location','southoutside','FontSize', 18,'Orientation','horizontal')
    
    
    % Move plots closer together
    % xticklabels(ax,{})
    tlo.TileSpacing = 'compact';
    saveas(h(t),strcat("./plot/starlight_type",string(i),"nolegend.png"))
end
