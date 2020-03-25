#!/usr/bin/env Rscript 

library(circlize)
library(dplyr)
library(data.table)
library(RColorBrewer)
library(stringr)
library(Cairo)

setwd("/Users/cc926/Documents/UKBiobank/PheWas_paper/Revision_Summer_2019/PheWas_manuscript_v2/Figure2")

annot<-fread("mito_annot_circos.txt",sep='\t',header=T)
annot$gene<-'chrM'


#annotation for categorical (416 SNVs)
annot_c<-fread("mito_annot_circos_cat.txt",sep='\t',header=T)
annot_c$gene<-'chrM'


#Serum biomarkers
SB_bed<-fread("SB.bed",sep='\t',header=F)
SB_bed$V1<-'chrM'
SB_bed$Pval = -log10(SB_bed$V3)
SB_newbed<-subset(SB_bed,select=c("V1","V2","V2","Pval","V4"))
colnames(SB_newbed)<-c("gene","start","end","Pval","trait")

#height
h_bed<-fread("height.bed",sep='\t',header=F)
h_bed$V1<-'chrM'
h_bed$Pval = -log10(h_bed$V4)
h_newbed<-subset(h_bed,select=c("V1","V2","V3","Pval","V5"))
colnames(h_newbed)<-c("gene","start","end","Pval","trait")

#categorical

c_bed<-fread("categorical.bed.mod",sep='\t',header=F)
c_bed$V1<-'chrM'
c_bed$Pval = -log10(c_bed$V4)
c_newbed<-subset(c_bed,select=c("V1","V2","V3","Pval","V5"))
colnames(c_newbed)<-c("gene","start","end","Pval","trait")

#blood
b_bed<-fread("Blood.bed",sep='\t',header=F)
b_bed$Pval = -log10(b_bed$V4)
b_newbed<-subset(b_bed,select=c("V1","V2","V3","Pval","V5"))
colnames(b_newbed)<-c("gene","start","end","Pval","trait")

#labels
snps<-fread('leading_mtSNPs.bed',sep='\t',header=F)

#colors
color_cat<-c("royalblue","chocolate1")
color_h<-c("orchid")
color_sb<-c("lightcoral","seagreen","blue","orangered")
color_b<-c("brown1","darkslategray","goldenrod")


pdf("QT_circos_v1.pdf",height = 10, width = 10,)

#CairoPNG(filename="QT_circos_v1.png", width = 7, height = 7, units = "in", dpi = 300)
    
#plot circos for quantitative traits
circos.clear()
circos.par("start.degree" = 90,"track.height" = 0.001,canvas.xlim=c(-1.4,1.4), canvas.ylim=c(-0.7,0.7))
circos.genomicInitialize(annot, major.by=17000, tickLabelsStartFromZero = 1, axis.labels.cex = 0.2,track.height = 0.001,sector.names="")


circos.trackPlotRegion(track.index = 1, bg.lwd=2,panel.fun = function(x,y) {
circos.axis(h="top",labels=c(snps$V4),major.at = c(snps$V2),track.index=1,direction="outside",major.tick.percentage = 0.2,labels.facing = "clockwise",labels.cex=0.5,labels.niceFacing=TRUE,labels.font=4)
})



#print height
c=1
for (i in unique(h_newbed$trait)) {
	df<-subset(h_newbed[h_newbed$trait==i,],select=c("gene","start","end","Pval"))
	circos.track(factor = df$gene, x = df$start, y = df$Pval, ylim = c(1,13), track.height = 0.08,bg.col = 'ivory',panel.fun = function(x, y) {
    if (CELL_META$sector.index == "chrM"){
	circos.yaxis(side = "left", labels.cex = 0.3)
	}
    circos.lines(CELL_META$xlim, y = rep(-log10(5e-5),2), lty = 2,lwd=1, col = "red")
    circos.lines(CELL_META$xlim, y = rep(-log10(1e-8),2), lty = 2,lwd=1, col = "blue")
    circos.points(x, y, pch = 21, cex = 0.7, col=color_h[c])
    }
)
	c = c+1
}

#print SB traits
c=1
for (i in unique(SB_newbed$trait)) {
	df<-subset(SB_newbed[SB_newbed$trait==i,],select=c("gene","start","end","Pval"))
	circos.track(factor = df$gene, x = df$start, y = df$Pval, ylim = c(1,13), track.height = 0.08, bg.col = 'lightcyan',panel.fun = function(x, y) {
    if (CELL_META$sector.index == "chrM"){
	circos.yaxis(side = "left", labels.cex = 0.3)
	}
    circos.lines(CELL_META$xlim, y = rep(-log10(5e-5),2), lty = 2,lwd=1, col = "red")
    circos.lines(CELL_META$xlim, y = rep(-log10(1e-8),2), lty = 2,lwd=1, col = "blue")
    circos.points(x, y, pch = 21, cex = 0.7, col=color_sb[c])
    }
)
	c = c+1
}

#print Blood
c=1
for (i in unique(b_newbed$trait)) {
	df<-subset(b_newbed[b_newbed$trait==i,],select=c("gene","start","end","Pval"))
	circos.track(factor = df$gene, x = df$start, y = df$Pval, ylim = c(1,19.5), track.height = 0.12, bg.col = '#FFE1FF',panel.fun = function(x, y) {
    if (CELL_META$sector.index == "chrM"){
	circos.yaxis(side = "left", labels.cex = 0.3)
	}
    circos.lines(CELL_META$xlim, y = rep(-log10(5e-5),2), lty = 2,lwd=1, col = "red")
    circos.lines(CELL_META$xlim, y = rep(-log10(1e-8),2), lty = 2,lwd=1, col = "blue")
    circos.points(x, y, pch = 21, cex = 0.5, col=color_b[c])
    }
)
	c = c+1
}


dev.off()

#plot circos for categorical traits
pdf("Cat_circos_v1.pdf",height = 7, width = 7, )
circos.clear()
circos.par(start.degree=90)
circos.genomicInitialize(annot, tickLabelsStartFromZero = 1, axis.labels.cex = 0.6,track.height = 0.01)

#print categorical traits
c=1
for (i in unique(c_newbed$trait)) {
	df<-subset(c_newbed[c_newbed$trait==i,],select=c("gene","start","end","Pval"))
	circos.track(factor = df$gene, x = df$start, y = df$Pval, ylim = c(1,13), bg.col = 'lavenderblush',panel.fun = function(x, y) {
    if (CELL_META$sector.index == "chrM"){
	circos.yaxis(side = "left", labels.cex = 0.5)
	}
    circos.lines(CELL_META$xlim, y = rep(-log10(5e-5),2), lty = 2,lwd=1, col = "red")
    circos.lines(CELL_META$xlim, y = rep(-log10(1e-8),2), lty = 2,lwd=1, col = "blue")
    circos.points(x, y, pch = 21, cex = 0.8, bg=color_cat[c])
    }
)
	c = c+1
}

dev.off()

#create legends
pdf("SB_legend.pdf",height = 5, width = 5, )
plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
legend("topleft", legend =c('Alanine aminotransferase','Aspartate aminotransferase', 'Creatinine','Urea'), pch=16, pt.cex=3, cex=1.5, bty="o", bg='lightcyan',col = c( "lightcoral", "seagreen", "blue", "orangered"))
dev.off()
pdf("Height_legend.pdf",height = 5, width = 5, )
plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
legend("topleft", legend =c('Height'), pch=16, pt.cex=3, cex=1.5, bty="o", bg='ivory',col = c("orchid"))
dev.off()
pdf("Blood_legend.pdf",height = 5, width = 5, )
plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
legend("topleft", legend =c('Red blood cells','Platelets','White blood cells'), pch=16, pt.cex=3, cex=1.5, bty="o", bg='#FFE1FF',col = c("brown1","darkslategray","goldenrod"))
dev.off()

