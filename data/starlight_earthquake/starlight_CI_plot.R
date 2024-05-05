

library(R.matlab)

MC_times = 5;
# MC_times = 20;  % waiting simulation to finish!
MC_times_2 = 1;
clustername = c(1,2);
for(ell in 5:8){
  ell_index = ell-4;
  for(i in 1:2){
    dat = readMat(
        sprintf("./data/starlight_earthquake/result/result_earthquake_inner%d%d30.mat",i,MC_times)
      );
    CI_all = dat$CI.all[,,ell_index]
    mu_true_all = readMat(paste("./data/starlight_earthquake/result/result_earthquake_inner_comp",i,MC_times_2,".mat",sep = ""))
    mu_true= mu_true_all$mu.hat.all.set[ell_index]
    CI_list = CI_all
    m = dim(CI_list)[1]
    pdf(file=paste('./data/starlight_earthquake/plot/earthquake, inner comparison type ',ell,'_column_',i,'.pdf',sep = ""))
    par(mar = c(2, 1.8,4 , 1.5) + 0.1)
    plot(apply(CI_list, 1, mean),1:m, ylab="Iteration", xlab="Confidence interval",xlim=c(min(CI_all)-0.1, max(CI_all)+0.1), col="blue", cex=0.1, pch=19,cex.main=1.5, cex.lab=2, cex.axis=1.2,main = paste("CI for within-",clustername[i],"\n Average pariwise distance",font.main = 1))
    bar_colors = rep("black", m); 
    arrows(CI_list[,1],1:m, CI_list[,2], 1:m, length=0.05, angle=90, code=3, col=bar_colors,lwd = 2)
    dev.off()
  }
}




typename = c("Major", "Non-major")
for(i in 5:8){
    dat = readMat(paste("./data/starlight_earthquake/result/result_earthquake_new",i,"2010.mat",sep = ""))
    CI_all = dat$CI.all
    mu_true_all = readMat(paste("./data/starlight_earthquake/result/result_earthquake_true",i,".mat",sep = ""))
    mu_true= mu_true_all$mu.true
    CI_list = CI_all
    pdf(file=paste('./data/starlight_earthquake/plot/earthquake, within comparison',i,'.pdf',sep = ""))
    par(mar=c(5.1, 5, 5, 2.7), mgp=c(3, 1.2, 0), las=0)
    m = dim(CI_list)[1]
    plot(apply(CI_list, 1, mean),1:m, ylab="Iteration", xlab="Confidence interval",xlim=c(min(CI_all)-0.01, max(CI_all)+0.01), col="blue", cex=0.1, pch=19,cex.main=2,  cex.lab=2.2, cex.axis=1.5,main = paste("CI for MMD, l=",i,"\n","Major vs. Non-major",sep =""),font.main = 1)
    m = dim(CI_list)[1]
    bar_colors = rep("black", m); 
    arrows(CI_list[,1], 1:m, CI_list[,2], 1:m, length=0.05, angle=90, code=3, col=bar_colors,lwd = 3)
    abline(v=mu_true, col="black", lty=2,lwd = 2)
    dev.off()
}






