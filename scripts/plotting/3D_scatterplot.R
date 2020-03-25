#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args) < 9) {
  stop("Usage\nscript.R <pca.txt> <xdim_col> <ydim_col> <zdim_col> <haplo_col> <xlabel> <ylabel> <zlabel> <outfile>\n", call.=FALSE)
} else if (length(args)>=1) {
  # default output file
  ifile = args[1]
  xdim = args[2]
  ydim = args[3]
  zdim = args[4]
  haplo = args[5]
  xlabel = args[6]
  ylabel = args[7]
  zlabel = args[8]
  outname = args[9]
}


library("scatterplot3d")
library("data.table")

df = fread(ifile, header=TRUE,sep='\t')

df = as.data.frame(df)

k = c(paste0(xdim),paste0(ydim),paste0(zdim),paste0(haplo))

x = df[[k[1]]]
y = df[[k[2]]]
z = df[[k[3]]]

colors_haplo <- c("darkorange","seagreen","purple","red","plum","tomato2","sienna","navy","darkgoldenrod")

haplogroups <- df[[k[4]]]

cols<-colors_haplo[as.factor(haplogroups)]

png(paste0(outname,".png"),width = 6,height = 6,units = 'in',res=350)
scatterplot3d(x,y,z,pch=20,color=cols, angle = 300,cex.axis=0.6,xlab=xlabel,ylab=ylabel,zlab=zlabel)
legend("bottom",legend=levels(as.factor(haplogroups)),col=colors_haplo,pch=c(16,16,16,16,16,16,16,16,16),inset= -0.23,xpd=TRUE,horiz=TRUE)
dev.off()