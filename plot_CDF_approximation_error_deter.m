clear
MarkerSize = 12;
rng(1);
N = [10,20,40,80];
alpha = [1.5,1.7];
r = 3;
iterc = 30;
boot = 200;
test_points = -2:0.1:2;   % Query points
%% generate standard normal distribution's CDF 
normcdf = cdf('Normal',test_points,0,1);
errorcdf1 = zeros(length(N),length(alpha),iterc);
errorcdf2 = zeros(length(N),length(alpha));
errorcdf3 = zeros(length(N),length(alpha));
errorcdf4 = zeros(length(N),length(alpha),iterc);
errorcdf5 = zeros(length(N),length(alpha),iterc);
b2 = 1;
b1 = (2^(r-1)-1)/2^(r-1);
type = "Sine";
cdelta  = 1;
for k = 1:length(N)
    for mf = 1:length(alpha)
        n = N(k);
        al = alpha(mf);

        data = readtable(strcat("./result/nondegenerate_MC3",string(n),"_", string(al*100),type,".csv"));
        d = table2array(data);
        d = round(d,5);
        d = rmmissing(d);
        [f,X] = ecdf(d);
        X = X(2:end);     
        f = f(2:end);     
        f_empri = interp1(X,f,test_points,'nearest'); % Nearest neighbor interpolation
        errorcdf2(k,mf) = max(abs(f_empri-normcdf));


            

      
        for i = 1:iterc
            % calculation the sup error
            x = sampling(n,type);

            M_alpha = floor(n^(al-1));
            M_alpha2 = min(floor(n^(al-1)),floor((n-1)/(r-1)));
            li2 = [];
            for t = (floor(b1*M_alpha)+1):M_alpha
                    item = zeros(n,r);
                    item(:,1) = 1:n;
                    for c = 1:(r-1)
                        item(:,c+1) =item(:,1)+(2^c-1)*t;
                    end
                    item = mod(item-1,n)+1;
                    li2 = [li2;item];
            end 
    
    
            %% list index for some estimates
            li_hat = [];
            for t = 1:M_alpha2
                    item = zeros(n,r);
                    item(:,1) = 1:n;
                    for c = 1:r-1
                        item(:,c+1) = item(:,1)+t*c;
                    end
                    item = mod(item-1,n)+1;
                    li_hat = [li_hat;item];
            end
            mu_hat_esti = mean(motif(x(li_hat),type));
            mu_2 = mu_hat_esti^2;
            sigma_h2 = mean(motif(x(li_hat),type).^2)-mu_2;
            h_vec = motif(x(li_hat),type)';
            [al_value,al_number] = h_redu(li_hat, h_vec, n);
            al_weight = al_value./al_number;
            ksei2 = mean(( al_weight - mu_hat_esti).^2);
            g_qub = mean(( al_weight - mu_hat_esti).^3);
            intera = 1/size(li_hat,1)*sum((h_vec'-mu_hat_esti-(al_weight(li_hat(:,1))-mu_hat_esti)-(al_weight(li_hat(:,r))-mu_hat_esti)).*(al_weight(li_hat(:,1))-mu_hat_esti).*(al_weight(li_hat(:,r))-mu_hat_esti));

            ksei = sqrt(ksei2);
            l_upper = floor((al/2)/(al-1));
            fixed = zeros(l_upper,length(test_points));
            for l= 1:l_upper
                fixed(l,:) = ((sigma_h2-r*ksei^2)/((b2-b1)*r^2*ksei^2)).^l.* hermite_function(l,test_points)./factorial(2*l)/M_alpha^l;
            end
            fixedall = sum(fixed,1);
            EdgeworthCDFValues = cdf('Normal',test_points,0,1) + pdf('Normal',test_points,0,1).*  ...
		            ((2*test_points.^2+1).*g_qub./6./ksei^3./sqrt(n)+(r-1)*(test_points.^2+1).*intera./2./ksei^3./sqrt(n)-fixedall);
            errorcdf1(k,mf,i) = max(abs(f_empri-EdgeworthCDFValues));
            h_vec2 = motif(x(li2),type)';
            mu_hat = mean(h_vec2);
	        t_mc_other = zeros(boot,1);
	        for l= 1:boot
		        indexn = datasample(1:n, n, 'Replace', true);
		        x_new = x(indexn);
		        h_vec = motif(x_new(li_hat),type)';
		        h_vec2 = motif(x_new(li2),type)';
		        mu_hat_new = mean(h_vec2);
		        mu_hat_esti = mean(h_vec);
		        [al_value,al_number] = h_redu(li_hat, h_vec, n);
		        al_weight = al_value./al_number;
		        ksei2 = mean(( al_weight - mu_hat_esti).^2);
		        var_all_new = (ksei2*r^2)/n;
		        t_mc_other(l,1) = (mu_hat_new - mu_hat)/sqrt(var_all_new);
            end
            t_mc_other = rmmissing(t_mc_other);
            [f,X] = ecdf(t_mc_other);
            X = X(2:end);     
            f = f(2:end);     
            boot_empri = interp1(X,f,test_points,'nearest'); % Nearest neighbor interpolation
            errorcdf4(k,mf,i) = max(abs(f_empri-boot_empri));

        	t_mc_other2 = zeros(boot,1);
	        nboot = ceil(sqrt(n));
        
	        M_alpha = min(floor(nboot^(al-1)),floor((nboot-1)/(2^(r-1)-1)));
            b2 = 1;
            b1 = (2^(r-1)-1)/2^(r-1);
            M_alpha2 = min(floor(nboot^(al-1)),floor((nboot-1)/(r-1)));
            li2 = [];
            for t = (floor(b1*M_alpha)+1):M_alpha
                    item = zeros(nboot,r);
                    item(:,1) = 1:nboot;
                    for c = 1:(r-1)
                        item(:,c+1) =item(:,1)+(2^c-1)*t;
                    end
                    item = mod(item-1,nboot)+1;
                    li2 = [li2;item];
            end 
            li_hat = [];
            for t = 1:M_alpha2
                    item = zeros(nboot,r);
                    item(:,1) = 1:nboot;
                    for c = 1:r-1
                        item(:,c+1) = item(:,1)+t*c;
                    end
                    item = mod(item-1,nboot)+1;
                    li_hat = [li_hat;item];
            end
	        for l= 1:boot
		        indexn = datasample(1:n, nboot, 'Replace', true);
		        x_new = x(indexn);
		        h_vec = motif(x_new(li_hat),type)';
		        h_vec2 = motif(x_new(li2),type)';
		        mu_hat_new = mean(h_vec2);
		        mu_hat_esti = mean(h_vec);
		        [al_value,al_number] = h_redu(li_hat, h_vec, nboot);
		        al_weight = al_value./al_number;
		        ksei2 = mean(( al_weight - mu_hat_esti).^2);
		        var_all_new = (ksei2*r^2)/nboot;
		        t_mc_other2(l,1) = (mu_hat_new - mu_hat)/sqrt(var_all_new);
	        end
            t_mc_other2 = t_mc_other2(t_mc_other2<10^5, :);
            t_mc_other2 = t_mc_other2(t_mc_other2>-10^5, :);
            [f,X] = ecdf(t_mc_other2);
            X = X(2:end);     
            f = f(2:end);     
            boot_empri2 = interp1(X,f,test_points,'nearest'); % Nearest neighbor interpolation
            errorcdf5(k,mf,i) = max(abs(f_empri-boot_empri2));

        end
%         g_qub = -0.0372207;
%         intera =  0.00506956;
%         ksei = 0.29012; 
%         g2 = 0.0384485;
%         g3 = 0.304641;
        g_qub = -0.0372207;
        intera =  0.00953116;
        ksei = 0.29012; 
        g2 = 0.0188575;
        g3 = 0.00459752;
        fixed = zeros(l_upper,length(test_points));
        for l= 1:l_upper
            fixed(l,:) = ((3*g2+g3)/((b2-b1)*r^2*ksei^2))^l.* hermite_function(l,test_points)./factorial(2*l)./M_alpha^l;
        end
        fixedall = sum(fixed,1);
        EdgeworthCDFValuestrue = cdf('Normal',test_points,0,1) + pdf('Normal',test_points,0,1).*  ...
		            ((2*test_points.^2+1).*g_qub./6./ksei^3./sqrt(n)+(r-1)*(test_points.^2+1).*intera./2./ksei^3./sqrt(n)-fixedall);
%         EdgeworthCDFValuestrue = cdf('Normal',test_points,0,1) + pdf('Normal',test_points,0,1).*  ...
% 		            ((2*test_points.^2+1).*g_qub./6./ksei^3./sqrt(n)+(r-1)*(test_points.^2+1).*intera./2./ksei^3./sqrt(n));
% 

        errorcdf3(k,mf) = max(abs(f_empri-EdgeworthCDFValuestrue));
        linewidth1 = 2;
        legendsize = 24;
        titlemulti = 1.8;
        gcafontsize = 20;

		%% generate CDF curve comparison between monte carlo of True T, standard normal and Edgeworth Expansion
        if k == size(N,2)
            fig = figure('visible','on');          
            plot1 = plot(test_points,f_empri,'LineWidth',linewidth1,'color',[0.3010, 0.7450, 0.9330]);
            hold on;
            plot3 = plot(test_points, EdgeworthCDFValues,'LineWidth',linewidth1,'color',[0, 0.5, 0]);
            hold on;
            plot2 = plot(test_points,normcdf,'LineWidth',linewidth1,'color','black');
            hold on;
            plot4 = plot(test_points, boot_empri,'LineWidth',linewidth1,'color',[0.4940, 0.1840, 0.5560]);
            hold on;
            plot5 = plot(test_points, boot_empri2,'LineWidth',linewidth1,'color',[0.8500, 0.3250, 0.0980]);
            hold off;
            title(strcat('CDF curve, $\alpha = $',string(al)),'Interpreter','latex');
            legend("True","Our method","N(0,1)","Resample","Subsample",'Location','southeast','FontSize', legendsize)
			ann = annotation('textbox',[0.20,0.77,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
			ann.VerticalAlignment = 'middle';
			ann.HorizontalAlignment = 'center';
            set(gca, 'FontSize', gcafontsize)
            ax = gca;
            ax.TitleFontSizeMultiplier = titlemulti;
            pbaspect([1.2 1 1])
            % set(gca,'units','centimeters')
            % set(gcf,'units','centimeters')
            % pos = get(gca,'Position');
            % ti = get(gca,'TightInset');
            % % set(gcf, 'PaperPositionMode', 'manual');
            % set(gca, 'Position',[1 1.1 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
            % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
            % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.2 5.4], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])

            exportgraphics(fig,strcat('./plot/CDF curve.',string(al*100),type,'.png'))


            fig = figure('visible','on');          
            plot1 = plot(test_points,f_empri,'LineWidth',linewidth1,'color',[0.3010, 0.7450, 0.9330]);
            hold on;
            plot3 = plot(test_points, EdgeworthCDFValues,'LineWidth',linewidth1,'color',[0, 0.5, 0]);
            hold on;
            plot2 = plot(test_points,normcdf,'LineWidth',linewidth1,'color','black');
            hold on;
            plot4 = plot(test_points, boot_empri,'LineWidth',linewidth1,'color',[0.4940, 0.1840, 0.5560]);
            hold on;
            plot5 = plot(test_points, boot_empri2,'LineWidth',linewidth1,'color',[0.8500, 0.3250, 0.0980]);
%             hold on;
%             plot4 = plot(test_points, EdgeworthCDFValuestrue,'LineWidth',linewidth1);
            hold off;
            title(strcat('CDF curve, $\alpha = $',string(al)),'Interpreter','latex');
%             title(strcat('CDF curve, '+MotifName+', m=n='+string(N(k))));
%             legend("MC","N(0,1)","Edgeworth","Edgeworthtrue",'Location','southeast','FontSize', 15)
%             legend("True","N(0,1)","Our method","Resample","Subsample",'Location','southeast','FontSize', 15)
			ann = annotation('textbox',[0.20,0.77,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
			ann.VerticalAlignment = 'middle';
			ann.HorizontalAlignment = 'center';
            set(gca, 'FontSize', gcafontsize)
            ax = gca;
            ax.TitleFontSizeMultiplier = titlemulti;
            pbaspect([1.2 1 1])
            % set(gca,'units','centimeters')
            % set(gcf,'units','centimeters')
            % pos = get(gca,'Position');
            % ti = get(gca,'TightInset');
            % % set(gcf, 'PaperPositionMode', 'manual');
            % set(gca, 'Position',[1 1.1 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
            % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
            % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.2 5.4], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])

            exportgraphics(fig,strcat('./plot/CDF curve.',string(al*100),type,'nolegend.png'))
       
        end
    end
end


%% generate CDF approximation error comparison plot 
for mf = 1:length(alpha)
    fig = figure('visible','on');
    box on
    al = alpha(mf);
    error = log(errorcdf1(:,mf,:));
    errortable = reshape(error,[length(N),iterc]);
    plot1 = shadedErrorBar(log(N),nanmean(errortable,2),nanstd(errortable,0,2),{'r-o','color',[0, 0.5, 0],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot2 = plot(log(N),log(errorcdf2(:,mf)),'Marker','s','linewidth',linewidth1,'MarkerSize',MarkerSize,'color','black');
%     hold on;
%     plot3 = plot(log(N),log(errorcdf3(:,mf)),'Marker','s','linewidth',linewidth1,'MarkerSize',MarkerSize);
    hold on
    error = log(errorcdf4(:,mf,:));
    errortable = reshape(error,[length(N),iterc]);
    plot4 = shadedErrorBar(log(N),nanmean(errortable,2),nanstd(errortable,0,2),{'r-o','color',[0.4940, 0.1840, 0.5560],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    error = log(errorcdf5(:,mf,:));
    errortable = reshape(error,[length(N),iterc]);
    plot5 = shadedErrorBar(log(N),nanmean(errortable,2),nanstd(errortable,0,2),{'r-o','color',[0.8500, 0.3250, 0.0980],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold off;
    yaxisname = 5:-1:1;
    yaxisname = -yaxisname;
    xticks(log(N));  xticklabels(N);  xlabel('# of nodes'); yticks(yaxisname);  yticklabels(yaxisname);  ylabel('Log(Error)');	
%     title(strcat('CDF Approx. Err, '+MotifName));
    title(strcat('CDF approx error, $\alpha = $',string(al)),'Interpreter','latex');
    legend("Our method","N(0,1)","Resample","Subsample",'FontSize', legendsize,'Location','southwest')
	ann = annotation('textbox',[0.38,0.77,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
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
    % set(gca, 'Position',[1 2 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.3 5.8], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])

    exportgraphics(fig,strcat('./plot/CDF Approx. Err.',string(al*100),type,'.png'))
    
    fig = figure('visible','on');
    box on
    al = alpha(mf);
    error = log(errorcdf1(:,mf,:));
    errortable = reshape(error,[length(N),iterc]);
    plot1 = shadedErrorBar(log(N),nanmean(errortable,2),nanstd(errortable,0,2),{'r-o','color',[0, 0.5, 0],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot2 = plot(log(N),log(errorcdf2(:,mf)),'Marker','s','linewidth',linewidth1,'MarkerSize',MarkerSize,'color','black');
%     hold on;
%     plot3 = plot(log(N),log(errorcdf3(:,mf)),'Marker','s','linewidth',linewidth1,'MarkerSize',MarkerSize);
    hold on
    error = log(errorcdf4(:,mf,:));
    errortable = reshape(error,[length(N),iterc]);
    plot4 = shadedErrorBar(log(N),nanmean(errortable,2),nanstd(errortable,0,2),{'r-o','color',[0.4940, 0.1840, 0.5560],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    error = log(errorcdf5(:,mf,:));
    errortable = reshape(error,[length(N),iterc]);
    plot5 = shadedErrorBar(log(N),nanmean(errortable,2),nanstd(errortable,0,2),{'r-o','color',[0.8500, 0.3250, 0.0980],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold off;
    yaxisname = 5:-1:1;
    yaxisname = -yaxisname;
    xticks(log(N));  xticklabels(N);  xlabel('# of nodes'); yticks(yaxisname);  yticklabels(yaxisname);  ylabel('Log(Error)');	
%     title(strcat('CDF Approx. Err, '+MotifName));
    title(strcat('CDF approx error, $\alpha = $',string(al)),'Interpreter','latex');
%     legend("Our method","N(0,1)","Resample","Subsample",'FontSize', 18,'Location','southwest')
	ann = annotation('textbox',[0.38,0.77,0.45,0.09],'String', sprintf('Deterministic'),'fontsize',33);
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
    % set(gca, 'Position',[1 2 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.3 5.8], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])

    exportgraphics(fig,strcat('./plot/CDF Approx. Err.',string(al*100),type,'nolegend.png'))

end

save("./result/cdf_approx_error_deterministic","errorcdf1","errorcdf2","errorcdf3","errorcdf4","errorcdf5")
