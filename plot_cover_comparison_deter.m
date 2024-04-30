clear
N = [25,50, 100,200,400];
alpha = [1.5,1.7];
iterc = 100;
iterc2 = 20;
type = "Sine";
cover1all = zeros(length(N),length(alpha),iterc);
cover2all = zeros(length(N),length(alpha),iterc);
cover3all = zeros(length(N),length(alpha),iterc2);
coverlg1all = zeros(length(N),length(alpha),iterc);
coverlg2all = zeros(length(N),length(alpha),iterc);
coverlg3all = zeros(length(N),length(alpha),iterc2);
time1all = zeros(length(N),length(alpha),iterc);
time2all = zeros(length(N),length(alpha),iterc);
time3all = zeros(length(N),length(alpha),iterc2);
cover4all = zeros(length(N),length(alpha),iterc);
coverlg4all = zeros(length(N),length(alpha),iterc);
time4all = zeros(length(N),length(alpha),iterc);
cover5all = zeros(length(N),length(alpha),iterc);
coverlg5all = zeros(length(N),length(alpha),iterc);
time5all = zeros(length(N),length(alpha),iterc);
cover6all = zeros(length(N),length(alpha),iterc);
coverlg6all = zeros(length(N),length(alpha),iterc);
time6all = zeros(length(N),length(alpha),iterc);
cover7all = zeros(length(N),length(alpha),iterc);
coverlg7all = zeros(length(N),length(alpha),iterc);
time7all = zeros(length(N),length(alpha),iterc);

for k = 1:length(N)
    for mf = 1:length(alpha)
        n = N(k);
        al = alpha(mf);
        load(strcat("./result/all_comparison2_",string(n),"_al_",string(al*100),"_",type,"_new3.mat"))
        cover1all(k,mf,:) = nanmean(cover1,1);

        coverlg1all(k,mf,:) = nanmean(coverlg1,1);

        time1all(k,mf,:) = log(nanmean(timeCI1,1));

        load(strcat("./result/all_comparison2_",string(n),"_al_",string(al*100),"_new.mat"))
        coverlg3all(k,mf,:) = nanmean(coverlg3,1);
        cover3all(k,mf,:) = nanmean(cover3,1);
        time3all(k,mf,:) = log(nanmean(timeCI3,1));
        load(strcat("./result/all_comparison2_",string(n),"_al_",string(al*100),"_Sine_deter_normal.mat"))
        coverlg4all(k,mf,:) = nanmean(coverlg1,1);
        cover4all(k,mf,:) = nanmean(cover1,1);
        time4all(k,mf,:) = log(nanmean(timeCI1,1));

        load(strcat("./result/all_comparison2_",string(n),"_al_",string(al*100),"_Sine_deter_resample.mat"))
        coverlg6all(k,mf,:) = nanmean(coverlg4,1);
        cover6all(k,mf,:) = nanmean(cover4,1);
        time6all(k,mf,:) = log(nanmean(timeCI4,1));
        load(strcat("./result/all_comparison2_",string(n),"_al_",string(al*100),"_Sine_deter_subsample.mat"))
        coverlg7all(k,mf,:) = nanmean(coverlg5,1);
        cover7all(k,mf,:) = nanmean(cover5,1);
        time7all(k,mf,:) = log(nanmean(timeCI5,1));
    end
end

%% generate CDF approximation error comparison plot 
linewidth1 = 2;
MarkerSize = 12;
legendsize = 24;
titlemulti = 1.8;
gcafontsize = 20;

for mf = 1:length(alpha)
    fig = figure('visible','on');
    box on
    al = alpha(mf);
    probcover1 = cover1all(:,mf,:);
    probcover1 = reshape(probcover1,[length(N),iterc]);
    probcover3 = cover3all(:,mf,:);
    probcover3 = reshape(probcover3,[length(N),iterc2]);
    probcover4 = cover4all(:,mf,:);
    probcover4 = reshape(probcover4,[length(N),iterc]);
    probcover6 = cover6all(:,mf,:);
    probcover6 = reshape(probcover6,[length(N),iterc]);
    probcover7 = cover7all(:,mf,:);
    probcover7 = reshape(probcover7,[length(N),iterc]);
    plot1 = shadedErrorBar(log(N),nanmean(probcover1,2),nanstd(probcover1,0,2),{'r-o','color',[0, 0.5, 0],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot4 = shadedErrorBar(log(N),nanmean(probcover4,2),nanstd(probcover4,0,2),{'r-o','color','black','linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot6 = shadedErrorBar(log(N),nanmean(probcover6,2),nanstd(probcover6,0,2),{'r-o','color',[0.4940, 0.1840, 0.5560],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot7 = shadedErrorBar(log(N),nanmean(probcover7,2),nanstd(probcover7,0,2),{'r-o','color',	[0.8500, 0.3250, 0.0980],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot3 = shadedErrorBar(log(N),nanmean(probcover3,2),nanstd(probcover3,0,2),{'r-o','color','b','linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold off
    xq = yline(0.9,'b:','LineStyle','--','linewidth',2,'FontSize', 20,'FontWeight','bold');
    xticks(log(N));  xticklabels(N);  xlabel('# of nodes');  ylabel('Coverage probability');	
    title(strcat('CI cover. prob., $\alpha$ = '+string(al)),'interpreter','latex');
    legend("Our method","N(0,1)","Resample","Subsample","Complete",'FontSize', legendsize,'Location','southeast')
	% ann = annotation('textbox',[0.49,0.78,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
    ann = annotation('textbox',[0.38,0.76,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
    ann.VerticalAlignment = 'middle';
    ann.HorizontalAlignment = 'center';
    xlim([log(N(1))-0.1,log(N(end))+0.1]);
    ylim([0.7,1]);
    yaxisname = 0.6:0.1:1;
    xticks(log(N));  xticklabels(N);  xlabel('# of nodes'); yticks(yaxisname);  yticklabels(yaxisname);  ylabel('Coverage probability');	
    set(gca, 'FontSize', gcafontsize)
    ax = gca;
    ax.TitleFontSizeMultiplier = titlemulti;
    pbaspect([1.2 1 1])
    % set(gca,'units','centimeters')
    % set(gcf,'units','centimeters')
    % pos = get(gca,'Position');
    % ti = get(gca,'TightInset');
    % set(gca, 'Position',[1.1 2 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.3 5.8], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])
         
    exportgraphics(fig,strcat('./plot/coverage prob comparison deter, '+string(al*100),type,'small.png'))


     fig = figure('visible','on');
    box on
    al = alpha(mf);
    probcover1 = cover1all(:,mf,:);
    probcover1 = reshape(probcover1,[length(N),iterc]);
    probcover3 = cover3all(:,mf,:);
    probcover3 = reshape(probcover3,[length(N),iterc2]);
    probcover4 = cover4all(:,mf,:);
    probcover4 = reshape(probcover4,[length(N),iterc]);
    probcover6 = cover6all(:,mf,:);
    probcover6 = reshape(probcover6,[length(N),iterc]);
    probcover7 = cover7all(:,mf,:);
    probcover7 = reshape(probcover7,[length(N),iterc]);
    plot1 = shadedErrorBar(log(N),nanmean(probcover1,2),nanstd(probcover1,0,2),{'r-o','color',[0, 0.5, 0],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;

    plot4 = shadedErrorBar(log(N),nanmean(probcover4,2),nanstd(probcover4,0,2),{'r-o','color','black','linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot6 = shadedErrorBar(log(N),nanmean(probcover6,2),nanstd(probcover6,0,2),{'r-o','color',[0.4940, 0.1840, 0.5560],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot7 = shadedErrorBar(log(N),nanmean(probcover7,2),nanstd(probcover7,0,2),{'r-o','color',	[0.8500, 0.3250, 0.0980],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot3 = shadedErrorBar(log(N),nanmean(probcover3,2),nanstd(probcover3,0,2),{'r-o','color','b','linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold off
    xq = yline(0.9,'b:','LineStyle','--','linewidth',2,'FontSize', 20,'FontWeight','bold');
    xticks(log(N));  xticklabels(N);  xlabel('# of nodes');  ylabel('Coverage probability');	
    title(strcat('CI cover. prob., $\alpha$ = '+string(al)),'interpreter','latex');
%     legend("Our method","N(0,1)","Resample","Subsample","Complete",'FontSize', legendsize,'Location','southeast')
	% ann = annotation('textbox',[0.49,0.78,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
    ann = annotation('textbox',[0.38,0.76,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
    ann.VerticalAlignment = 'middle';
    ann.HorizontalAlignment = 'center';
    xlim([log(N(1))-0.1,log(N(end))+0.1]);
    ylim([0.7,1]);
    yaxisname = 0.6:0.1:1;
    xticks(log(N));  xticklabels(N);  xlabel('# of nodes'); yticks(yaxisname);  yticklabels(yaxisname);  ylabel('Coverage probability');	
    set(gca, 'FontSize', gcafontsize)
    ax = gca;
    ax.TitleFontSizeMultiplier = titlemulti;
    pbaspect([1.2 1 1])
    % set(gca,'units','centimeters')
    % set(gcf,'units','centimeters')
    % pos = get(gca,'Position');
    % ti = get(gca,'TightInset');
    % set(gca, 'Position',[1.1 2 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.3 5.8], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])
    
         
    exportgraphics(fig,strcat('./plot/coverage prob comparison deter, '+string(al*100),type,'smallnolegend.png'))


end




for mf = 1:length(alpha)
    fig = figure('visible','on');
    box on
    al = alpha(mf);
    probcover1 = coverlg1all(:,mf,:);
    probcover1 = reshape(probcover1,[length(N),iterc]);
    probcover3 = coverlg3all(:,mf,:);
    probcover3 = reshape(probcover3,[length(N),iterc2]);
    probcover4 = coverlg4all(:,mf,:);
    probcover4 = reshape(probcover4,[length(N),iterc]);
    probcover6 = coverlg6all(:,mf,:);
    probcover6 = reshape(probcover6,[length(N),iterc]);
    probcover7 = coverlg7all(:,mf,:);
    probcover7 = reshape(probcover7,[length(N),iterc]);
    plot1 = shadedErrorBar(log(N),nanmean(probcover1,2),nanstd(probcover1,0,2),{'r-o','color',[0, 0.5, 0],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot4 = shadedErrorBar(log(N),nanmean(probcover4,2),nanstd(probcover4,0,2),{'r-o','color','black','linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot6 = shadedErrorBar(log(N),nanmean(probcover6,2),nanstd(probcover6,0,2),{'r-o','color',[0.4940, 0.1840, 0.5560],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot7 = shadedErrorBar(log(N),nanmean(probcover7,2),nanstd(probcover7,0,2),{'r-o','color',	[0.8500, 0.3250, 0.0980],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot3 = shadedErrorBar(log(N),nanmean(probcover3,2),nanstd(probcover3,0,2),{'r-o','color','b','linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold off;
    xticks(log(N));  xticklabels(N);  xlabel('# of nodes');  ylabel('Length');	
    title(strcat('CI length, $\alpha$ = '+string(al)),'interpreter','latex');
    legend("Our method","N(0,1)","Resample","Subsample","Complete",'FontSize', legendsize,'Location','southeast')
    % ann = annotation('textbox',[0.47,0.78,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
    ann = annotation('textbox',[0.38,0.76,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
    ann.VerticalAlignment = 'middle';
    ann.HorizontalAlignment = 'center';
    xlim([log(N(1))-0.1,log(N(end))+0.1]);
    ylim([0,4]);
    yaxisname = 0:1:4;
    yticks(yaxisname);  yticklabels(yaxisname);	
    set(gca, 'FontSize', gcafontsize)
    ax = gca;
    ax.TitleFontSizeMultiplier = titlemulti;
    pbaspect([1.2 1 1])
    % set(gca,'units','centimeters')
    % set(gcf,'units','centimeters')
    % pos = get(gca,'Position');
    % ti = get(gca,'TightInset');
    % set(gca, 'Position',[1.1 2 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.3 5.8], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])
            
    exportgraphics(fig,strcat('./plot/coverage length comparison deter, '+string(al*100),type,'small.png'))

    fig = figure('visible','on');
    box on
    al = alpha(mf);
    probcover1 = coverlg1all(:,mf,:);
    probcover1 = reshape(probcover1,[length(N),iterc]);
    probcover3 = coverlg3all(:,mf,:);
    probcover3 = reshape(probcover3,[length(N),iterc2]);
    probcover4 = coverlg4all(:,mf,:);
    probcover4 = reshape(probcover4,[length(N),iterc]);
    probcover6 = coverlg6all(:,mf,:);
    probcover6 = reshape(probcover6,[length(N),iterc]);
    probcover7 = coverlg7all(:,mf,:);
    probcover7 = reshape(probcover7,[length(N),iterc]);
    plot1 = shadedErrorBar(log(N),nanmean(probcover1,2),nanstd(probcover1,0,2),{'r-o','color',[0, 0.5, 0],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot4 = shadedErrorBar(log(N),nanmean(probcover4,2),nanstd(probcover4,0,2),{'r-o','color','black','linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot6 = shadedErrorBar(log(N),nanmean(probcover6,2),nanstd(probcover6,0,2),{'r-o','color',[0.4940, 0.1840, 0.5560],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot7 = shadedErrorBar(log(N),nanmean(probcover7,2),nanstd(probcover7,0,2),{'r-o','color',	[0.8500, 0.3250, 0.0980],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot3 = shadedErrorBar(log(N),nanmean(probcover3,2),nanstd(probcover3,0,2),{'r-o','color','b','linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold off;
    xticks(log(N));  xticklabels(N);  xlabel('# of nodes');  ylabel('Length');	
    title(strcat('CI length, $\alpha$ = '+string(al)),'interpreter','latex');
%     legend("Our method","N(0,1)","Resample","Subsample","Complete",'FontSize', legendsize,'Location','southeast')
    % ann = annotation('textbox',[0.47,0.78,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
    ann = annotation('textbox',[0.38,0.76,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
    ann.VerticalAlignment = 'middle';
    ann.HorizontalAlignment = 'center';
    xlim([log(N(1))-0.1,log(N(end))+0.1]);
    ylim([0,4]);
    yaxisname = 0:1:4;
    yticks(yaxisname);  yticklabels(yaxisname);	
    set(gca, 'FontSize', gcafontsize)
    ax = gca;
    ax.TitleFontSizeMultiplier = titlemulti;
    pbaspect([1.2 1 1])
    % set(gca,'units','centimeters')
    % set(gcf,'units','centimeters')
    % pos = get(gca,'Position');
    % ti = get(gca,'TightInset');
    % set(gca, 'Position',[1.1 2 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.3 5.8], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])
            
            
    exportgraphics(fig,strcat('./plot/coverage length comparison deter, '+string(al*100),type,'smallnolegend.png'))

end




for mf = 1:length(alpha)
    fig = figure('visible','on');
    box on
    al = alpha(mf);
    probcover1 = time1all(:,mf,:);
    probcover1 = reshape(probcover1,[length(N),iterc]);
    probcover3 = time3all(:,mf,:);
    probcover3 = reshape(probcover3,[length(N),iterc2]);
    probcover4 = time4all(:,mf,:);
    probcover4 = reshape(probcover4,[length(N),iterc]);
    probcover6 = time6all(:,mf,:);
    probcover6 = reshape(probcover6,[length(N),iterc]);
    probcover7 = time7all(:,mf,:);
    probcover7 = reshape(probcover7,[length(N),iterc]);
    plot1 = shadedErrorBar(log(N),nanmean(probcover1,2),nanstd(probcover1,0,2),{'r-o','color',[0, 0.5, 0],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot4 = shadedErrorBar(log(N),nanmean(probcover4,2),nanstd(probcover4,0,2),{'r-o','color','black','linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot6 = shadedErrorBar(log(N),nanmean(probcover6,2),nanstd(probcover6,0,2),{'r-o','color',[0.4940, 0.1840, 0.5560],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot7 = shadedErrorBar(log(N),nanmean(probcover7,2),nanstd(probcover7,0,2),{'r-o','color',	[0.8500, 0.3250, 0.0980],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot3 = shadedErrorBar(log(N),nanmean(probcover3,2),nanstd(probcover3,0,2),{'r-o','color','b','linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold off;

    xticks(log(N));  xticklabels(N);  xlabel('# of nodes');  ylabel('Log(time)');	
    title(strcat('CI time cost, $\alpha$ = '+string(al)),'interpreter','latex');
    legend("Our method","N(0,1)","Resample","Subsample","Complete",'FontSize', legendsize,'Location','southeast')
	ann = annotation('textbox',[0.14,0.78,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
    ann.VerticalAlignment = 'middle';
    ann.HorizontalAlignment = 'center';
    xlim([log(N(1))-0.1,log(N(end))+0.1]);
    set(gca, 'FontSize', gcafontsize)
    ax = gca;
    ax.TitleFontSizeMultiplier = titlemulti;
    pbaspect([1.2 1 1])
    % set(gca,'units','centimeters')
    % set(gcf,'units','centimeters')
    % pos = get(gca,'Position');
    % ti = get(gca,'TightInset');
    % % set(gcf, 'PaperPositionMode', 'manual');
    % set(gca, 'Position',[1.1 2 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.3 5.8], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])
           
    exportgraphics(fig,strcat('./plot/coverage time comparison deter, '+string(al*100),type,'small.png'))


     fig = figure('visible','on');
    box on
    al = alpha(mf);
    probcover1 = time1all(:,mf,:);
    probcover1 = reshape(probcover1,[length(N),iterc]);
    probcover3 = time3all(:,mf,:);
    probcover3 = reshape(probcover3,[length(N),iterc2]);
    probcover4 = time4all(:,mf,:);
    probcover4 = reshape(probcover4,[length(N),iterc]);
    probcover6 = time6all(:,mf,:);
    probcover6 = reshape(probcover6,[length(N),iterc]);
    probcover7 = time7all(:,mf,:);
    probcover7 = reshape(probcover7,[length(N),iterc]);
    plot1 = shadedErrorBar(log(N),nanmean(probcover1,2),nanstd(probcover1,0,2),{'r-o','color',[0, 0.5, 0],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot4 = shadedErrorBar(log(N),nanmean(probcover4,2),nanstd(probcover4,0,2),{'r-o','color','black','linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot6 = shadedErrorBar(log(N),nanmean(probcover6,2),nanstd(probcover6,0,2),{'r-o','color',[0.4940, 0.1840, 0.5560],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot7 = shadedErrorBar(log(N),nanmean(probcover7,2),nanstd(probcover7,0,2),{'r-o','color',	[0.8500, 0.3250, 0.0980],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot3 = shadedErrorBar(log(N),nanmean(probcover3,2),nanstd(probcover3,0,2),{'r-o','color','b','linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold off;

    xticks(log(N));  xticklabels(N);  xlabel('# of nodes');  ylabel('Log(time)');	
    title(strcat('CI time cost, $\alpha$ = '+string(al)),'interpreter','latex');
%     legend("Our method","N(0,1)","Resample","Subsample","Complete",'FontSize', legendsize,'Location','southeast')
	ann = annotation('textbox',[0.14,0.78,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
    ann.VerticalAlignment = 'middle';
    ann.HorizontalAlignment = 'center';
    xlim([log(N(1))-0.1,log(N(end))+0.1]);
    set(gca, 'FontSize', gcafontsize)
    ax = gca;
    ax.TitleFontSizeMultiplier = titlemulti;
    pbaspect([1.2 1 1])
    % set(gca,'units','centimeters')
    % set(gcf,'units','centimeters')
    % pos = get(gca,'Position');
    % ti = get(gca,'TightInset');
    % set(gca, 'Position',[1.1 2 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.3 5.8], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])
        
           
    exportgraphics(fig,strcat('./plot/coverage time comparison deter, '+string(al*100),type,'smallnolegend.png'))


end
