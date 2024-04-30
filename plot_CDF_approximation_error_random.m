clear
tic;
MarkerSize = 12;
rng(7);
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
type = "Sine";
for k = 1:length(N)
    for mf = 1:length(alpha)
        n = N(k);
        al = alpha(mf);
        M_alpha2 = min(floor(n^(al-1)),floor((n-1)/(r-1)));
        data = readtable(strcat("./result/nondegenerate_MC_random2",string(n),"_", string(al*100),type,".csv"));
        d = table2array(data);
        d = round(d,5);
        d = rmmissing(d);
        [f,X] = ecdf(d);
        X = X(2:end);     
        f = f(2:end);     
        f_empri = interp1(X,f,test_points,'nearest'); % Nearest neighbor interpolation
        errorcdf2(k,mf) = max(abs(f_empri-normcdf));


        %% list index for some estimates
        li_hat = [];
        for i = 1:M_alpha2
                item = zeros(n,r);
                item(:,1) = 1:n;
                for c = 1:r-1
                    item(:,c+1) = item(:,1)+i*c;
                end
                item = mod(item-1,n)+1;
                li_hat = [li_hat;item];
        end

	    g2_li = zeros(M_alpha2*n,r,2);
        g2_li1 = [];
        g2_li2 = [];
	    for i = 1:M_alpha2
			    item = zeros(n,r);
                item(:,1) = 1:n;
			    for c = 0:r-1
				    item(:,c+1) = item(:,1)+i*c;
                end
                g2_li1 = [g2_li1;item];
			    item2 = zeros(n,r);
			    for c = 0:r-1
				    item2(:,c+1) = item(:,end)+i*(c-1);
			    end
			    g2_li2 = [g2_li2;item2];
        end
        g2_li(:,:,1) = g2_li1;
        g2_li(:,:,2) = g2_li2;
        g2_li = mod(g2_li-1,n)+1;

        for i = 1:iterc
            x = sampling(n,type);
            check = false;
            while ~check 
                [li2,check] = randomsamle(n,al);
                if ~check
                    continue
                else
                    h_vec = motif(x(li2),type)';
                    mu_hat = mean(h_vec);
					mu_hat_esti = mean(motif(x(li_hat),type));
					mu_2 = mu_hat_esti^2;
					sigma_h2 = mean(motif(x(li_hat),type).^2)-mu_2;
					h_vec = motif(x(li2),type)';
					mu_hat = mean(h_vec);
					[al_value,al_number] = h_redu(li2, h_vec, n);
					al_weight = al_value./(al_number+1e-10);
					ksei2 = mean(( al_weight - mu_hat).^2);
					ksei = sqrt(ksei2);
					g13 = mean(( al_weight - mu_hat).^3);
					g112 = 1/size(li2,1)*sum((motif(x(li2),type)-mu_hat-(al_weight(li2(:,1))-mu_hat)-(al_weight(li2(:,r))-mu_hat)).*(al_weight(li2(:,1))-mu_hat).*(al_weight(li2(:,r))-mu_hat));    
					xx6 = motif(x(g2_li(:,:,1)),type); xx6 = xx6 - mean(xx6)-(al_weight(g2_li(:,(r-1),1))-mu_hat)-(al_weight(g2_li(:,r,1))-mu_hat);
					xx7 = motif(x(g2_li(:,:,2)),type); xx7 = xx7 - mean(xx7)-(al_weight(g2_li(:,1,2))-mu_hat)-(al_weight(g2_li(:,2,2))-mu_hat);
					g2 = mean(xx6.*xx7) ;
					M_alpha_new = n^(al-1)*(1+1/(r*n^(al-1)))/(1+n^(al-2)*g2*r*(r-1)/(sigma_h2-r*ksei^2));
					EdgeworthCDFValues = cdf('Normal',test_points,0,1) + pdf('Normal',test_points,0,1).*  ...
							((2*test_points.^2+1).*g13./6./ksei^3./sqrt(n)+(r-1)*(test_points.^2+1).*g112./2./ksei^3./sqrt(n)-(sigma_h2-r*ksei^2)/(r^2*ksei^2).*(test_points)./2/M_alpha_new);
					errorcdf1(k,mf,i) = max(abs(EdgeworthCDFValues-f_empri));
                    
				    t_mc_other = zeros(boot,1);
                    for l= 1:boot
                        indexn = datasample(1:n, n, 'Replace', true);
                        x_new = x(indexn);
                        [li2,checkin] = randomsamle(n,al);
                        if checkin
                            h_vec = motif(x_new(li2),type)';
                            mu_hat_new = mean(h_vec);
                            [al_value,al_number] = h_redu(li2, h_vec, n);
                            al_weight = al_value./(al_number+1e-10);
                            ksei2_new = mean(( al_weight - mu_hat_new).^2);
                            var_all_new = sum(al_number.^2)/(floor(n^al)^2)*ksei2_new;
                            t_mc_other(l,1) = (mu_hat_new - mu_hat)/sqrt(var_all_new);
                        else
                            t_mc_other(l,1) = NaN;
                        end
                    end
					t_mc_other = rmmissing(t_mc_other);
					[f,X] = ecdf(t_mc_other);
					X = X(2:end);     
					f = f(2:end);     
					boot_empri = interp1(X,f,test_points,'nearest'); % Nearest neighbor interpolation
					errorcdf4(k,mf,i) = max(abs(f_empri-boot_empri));
					t_mc_other2 = zeros(boot,1);
                    nboot = ceil(sqrt(n));
                    for l= 1:boot
                        indexn = datasample(1:n, nboot, 'Replace', false);
                        x_new = x(indexn);
                        [li2,checkin] = randomsamle_inner(nboot,al);
                        if checkin
                            h_vec = motif(x_new(li2),type)';
                            mu_hat_new = mean(h_vec);
                            [al_value,al_number] = h_redu(li2, h_vec, nboot);
                            al_weight = al_value./(al_number+1e-10);
                            ksei2_new = mean(( al_weight - mu_hat_new).^2);
                            var_all_new = sum(al_number.^2)/(floor(nboot^al)^2)*ksei2_new;
                            t_mc_other2(l,1) = (mu_hat_new - mu_hat)/sqrt(var_all_new);
                        else
                            t_mc_other2(l,1) = NaN;
                        end
                    end
					t_mc_other2 = rmmissing(t_mc_other2);
					[f,X] = ecdf(t_mc_other2);
					X = X(2:end);     
					f = f(2:end);     
					boot_empri2 = interp1(X,f,test_points,'nearest'); % Nearest neighbor interpolation
					errorcdf5(k,mf,i) = max(abs(f_empri-boot_empri2));	
                end
            end					
        end
        g_qub = -0.0372207;
        intera =  0.00953116;
        ksei = 0.29012; 
        g2 = 0.0188575;
        g3 = 0.00459752;
        M_alpha_new = n^(al-1)*(1+1/(r*n^(al-1)))/(1+n^(al-2)*g2*r*(r-1)/(3*g2+g3));
        EdgeworthCDFValuestrue = cdf('Normal',test_points,0,1) + pdf('Normal',test_points,0,1).*  ...
		            ((2*test_points.^2+1).*g13./6./ksei^3./sqrt(n)+(r-1)*(test_points.^2+1).*g112./2./ksei^3./sqrt(n)-(3*g2+g3)/(r^2*ksei^2).*(test_points)./2/M_alpha_new);
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
            set(gca, 'FontSize', gcafontsize)
            ax = gca;
            ax.TitleFontSizeMultiplier = titlemulti;
            pbaspect([1.2 1 1])
            % set(gca,'units','centimeters')
            % set(gcf,'units','centimeters')
            % pos = get(gca,'Position');
            % ti = get(gca,'TightInset');
            % set(gca, 'Position',[1 1.1 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
            % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
            % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.2 5.4], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])
            exportgraphics(fig,strcat('./plot/Random CDF curve.',string(al*100),type,'.png'))
            
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
            set(gca, 'FontSize', gcafontsize)
            ax = gca;
            ax.TitleFontSizeMultiplier = titlemulti;
            pbaspect([1.2 1 1])
            % set(gca,'units','centimeters')
            % set(gcf,'units','centimeters')
            % pos = get(gca,'Position');
            % ti = get(gca,'TightInset');
            % set(gca, 'Position',[1 1.1 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
            % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
            % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.2 5.4], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])

            exportgraphics(fig,strcat('./plot/Random CDF curve.',string(al*100),type,'nolegend.png'))
%
        end
    end
end

save("cdf_approx_error_random","errorcdf1","errorcdf2","errorcdf3","errorcdf4","errorcdf5")

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
    title(strcat('CDF approx error, $\alpha = $',string(al)),'Interpreter','latex');
    legend("Our method","N(0,1)","Resample","Subsample",'FontSize', legendsize,'Location','southwest')
    xlim([log(N(1))-0.1,log(N(end))+0.1]);
    set(gca, 'FontSize', gcafontsize)
    ax = gca;
    ax.TitleFontSizeMultiplier = titlemulti;
    pbaspect([1.2 1 1])
    % set(gca,'units','centimeters')
    % set(gcf,'units','centimeters')
    % pos = get(gca,'Position');
    % ti = get(gca,'TightInset');
    % set(gca, 'Position',[1 2 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.3 5.8], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])

    exportgraphics(fig,strcat('./plot/Random CDF Approx. Err.',string(al*100),type,'.png'))

    fig = figure('visible','on');
    box on
    al = alpha(mf);
    error = log(errorcdf1(:,mf,:));
    errortable = reshape(error,[length(N),iterc]);
    plot1 = shadedErrorBar(log(N),nanmean(errortable,2),nanstd(errortable,0,2),{'r-o','color',[0, 0.5, 0],'linewidth',linewidth1,'MarkerSize',MarkerSize},1);
    hold on;
    plot2 = plot(log(N),log(errorcdf2(:,mf)),'Marker','s','linewidth',linewidth1,'MarkerSize',MarkerSize,'color','black');
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
    title(strcat('CDF approx error, $\alpha = $',string(al)),'Interpreter','latex');
    xlim([log(N(1))-0.1,log(N(end))+0.1]);
    set(gca, 'FontSize', gcafontsize)
    ax = gca;
    ax.TitleFontSizeMultiplier = titlemulti;
    pbaspect([1.2 1 1])
    % set(gca,'units','centimeters')
    % set(gcf,'units','centimeters')
    % pos = get(gca,'Position');
    % ti = get(gca,'TightInset');
    % set(gca, 'Position',[1 2 pos(3)+ti(1)+ti(3)+2 pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    % set(gcf, 'Units', 'Inches', 'Position', [0 0 6.3 5.8], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 5.5])


    exportgraphics(fig,strcat('./plot/Random CDF Approx. Err.',string(al*100),type,'nolegend.png'))

end

save("./result/cdf_approx_error_random","errorcdf1","errorcdf2","errorcdf3","errorcdf4","errorcdf5")
toc;