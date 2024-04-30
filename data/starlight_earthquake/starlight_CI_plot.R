
library(R.matlab)
typename = c("Type 1","Type 2","Type 3")
windows(width=6, height=6)
par(mfrow=c(1,2), oma=c(2,2,3.5,0))
for(i in 1:3){
  dat = readMat(paste("./data/starlight_earthquake/result/all_innerdistance5",i,"_15.mat",sep = ""))
  CI_all = dat$CI.all
  mu_true= 0
  CI_list = CI_all
  m = dim(CI_list)[1]
  par(mar = c(2, 1.8,2 , 1.5) + 0.1)
  plot(apply(CI_list, 1, mean),1:m, ylab="Iteration", xlab="Confidence interval",xlim=c(min(CI_all)-0.1, max(CI_all)+0.1), col="blue", cex=0.1, pch=19,cex.main=1.5, cex.lab=2, cex.axis=1.2,main = paste("CI for within-",typename[i],"\n Average pariwise distance",font.main = 1)
  bar_colors = rep("black", m); 
  arrows(CI_list[,1],1:m, CI_list[,2], 1:m, length=0.05, angle=90, code=3, col=bar_colors,lwd = 2)
}




for(i in 1:1){
  for(j in (i+2):3){
    dat = readMat(paste("./data/starlight_earthquake/result/all_dist_bt_10_",i,"_",j,"_15.mat",sep = ""))
    CI_all = dat$CI.all
    mu_true= 0
    CI_list = CI_all
    png(file=paste('./data/starlight_earthquake/plot/starlight, group comparison',i,j,'.png',sep = ""))
    par(mar=c(5.1, 5, 5, 2.7), mgp=c(3, 1.2, 0), las=0)
    m = dim(CI_list)[1]
    plot(apply(CI_list, 1, mean),1:m, ylab="Iteration", xlab="Confidence interval",xlim=c(min(CI_all)-0.01, max(CI_all)+0.01), col="black", cex=0.1, pch=19,main = sprintf('CI for MMD, \n Type %d vs. Type %d',i,j),cex.main=2,  cex.lab=2.2, cex.axis=1.5,font.main = 1)
    m = dim(CI_list)[1]
    bar_colors = rep("black", m); 
    arrows(CI_list[,1], 1:m, CI_list[,2], 1:m, length=0.05, angle=90, code=3, col=bar_colors,lwd = 3)
    dev.off()
  }
  
}

typename = c("Type 1","Type 2","Type 3")
for(i in 2:2){
    dat = readMat(paste("./data/starlight_earthquake/result/all_innerdistance10",i,"_15.mat",sep = ""))
    CI_all = dat$CI.all
    dat = readMat(paste("./data/starlight_earthquake/result/all_innerdistance5",i,"_1510.mat",sep = ""))
    CI_all = rbind(CI_all,dat$CI.all)
    dat = readMat(paste("./data/starlight_earthquake/result/all_innerdistance5",i,"_1520.mat",sep = ""))
    CI_all = rbind(CI_all,dat$CI.all)
    mu_true_all = readMat(paste("./data/starlight_earthquake/result/cluster",i,"CIless_comp.mat",sep = ""))
    mu_true= mean(mu_true_all$mu.hat)
    CI_list = CI_all
    png(file=paste('./data/starlight_earthquake/plot/starlight, within comparison',i,'.png',sep = ""))
    par(mar=c(5.1, 5, 5, 2.7), mgp=c(3, 1.2, 0), las=0)
    m = dim(CI_list)[1]
    plot(apply(CI_list, 1, mean),1:m, ylab="Iteration", xlab="Confidence interval",xlim=c(min(CI_all)-0.1, max(CI_all)+0.1), col="blue", cex=0.1, pch=19,cex.main=2,  cex.lab=2.2, cex.axis=1.5,main = paste("CI for within-cluster","\n average pariwise distance, ",typename[i],sep =""),font.main = 1)
    m = dim(CI_list)[1]
    bar_colors = rep("black", m); 
    arrows(CI_list[,1], 1:m, CI_list[,2], 1:m, length=0.05, angle=90, code=3, col=bar_colors,lwd = 3)
    abline(v=mu_true, col="black", lty=2,lwd = 2)
    dev.off()
  
}
