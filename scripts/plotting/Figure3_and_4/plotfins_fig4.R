#!/usr/bin/env Rscript 

library(circlize)
library(dplyr)
library(data.table)
library(RColorBrewer)
library(stringr)
library(Cairo)

setwd("/home/ey246/rds/hpc-work/plots/")

annot<-fread("mito_annot_circos.txt",sep='\t',header=T)
annot$gene<-'chrM'


#Serum biomarkers
SB_bed<-fread("bloodcv.bed",sep='\t',header=F)
SB_bed$V1<-'chrM'
SB_bed$Pval = -log10(SB_bed$V4)
SB_newbed<-subset(SB_bed,select=c("V1","V2","V2","Pval","V5"))
colnames(SB_newbed)<-c("gene","start","end","Pval","trait")
#labels
snps<-fread('leading_bloodcv2.bed',sep='\t',header=F)



#colors

color_sb<-c("#4B0C6BFF","#FCFFA4FF","#A52C60FF","#ED6925FF","#F7D03CFF")



pdf("MainFigure4.pdf",height = 10, width = 10,)

#CairoPNG(filename="QT_circos_v1.png", width = 7, height = 7, units = "in", dpi = 300)
    
#plot circos for quantitative traits
circos.clear()
#circos.par("start.degree" = 90,"track.height" = 0.001,canvas.xlim=c(-7,7), canvas.ylim=c(-3.5,3.5))
#circos.par(cell.padding=c(0,0,0,0), track.margin=c(0,0.0001), start.degree = 90, gap.degree =16, canvas.xlim=c(-1.4,1.4), canvas.ylim=c(-0.7,0.7)))
#circos.par("start.degree" = 90,"track.height" = 0.001,gap.degree =16,canvas.xlim=c(-1.6,1.6), canvas.ylim=c(-0.9,0.9))

circos.par("start.degree" = 90,"track.height" = convert_length(210, unit = c("mm")),gap.degree =8,canvas.xlim=c(-1.6,1.6), canvas.ylim=c(-1.6,1.6))

#circos.genomicInitialize(annot, major.by=3300, tickLabelsStartFromZero = 1, axis.labels.cex = 1,track.height = convert_length(7, "inches"),sector.names="")

circos.genomicInitialize(annot, major.by=2000, tickLabelsStartFromZero = FALSE, axis.labels.cex = 0.7,track.height = 0.1,sector.names="")

circos.trackPlotRegion(track.index = 1,bg.lwd=2,cell.padding=c(1,1),panel.fun = function(x,y){
circos.axis(h="top",labels=c(snps$V4),major.at = c(snps$V2),track.index=1,direction="outside",major.tick.percentage = 0.2,labels.facing = "clockwise",labels.cex=0.8,labels.niceFacing=TRUE,labels.font=2)
})

#track.margin=c(1,1)
#print SB traits
c=1
for (i in unique(SB_newbed$trait)) {
	df<-subset(SB_newbed[SB_newbed$trait==i,],select=c("gene","start","end","Pval"))
	circos.track(factor = df$gene, x = df$start, y = df$Pval, ylim = c(0,20), track.height = 0.15, bg.col = 'white',panel.fun = function(x, y) {
    if (CELL_META$sector.index == "chrM"){
	circos.yaxis(side = "left", labels.cex = 0.8, at=c(10,20))
	}
    circos.lines(CELL_META$xlim, y = rep(-log10(5e-5),2), lty = 2,lwd=1, col = "black")
    circos.lines(CELL_META$xlim, y = rep(-log10(1e-8),2), lty = 2,lwd=1, col = "blue")
    circos.points(x, y, pch = 21, cex = 1, col=color_sb[c])
    }
)
	c = c+1
}

dev.off()
pdf("legend_fig4.pdf",height = 5, width = 5, )
plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
legend("topleft", legend =c("Red blood cell traits","Anemia","Platelet traits","Circulatory system","Endocrine system"), pch=16, pt.cex=3, cex=1.5, bty="o", bg='white',col = c( "#4B0C6BFF","#FCFFA4FF","#A52C60FF","#ED6925FF","#F7D03CFF"))
dev.off()

