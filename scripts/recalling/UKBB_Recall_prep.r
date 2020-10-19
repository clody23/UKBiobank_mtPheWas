##===============================
##This is a script for data preparation
##================================

#/bin/R

rm(list=ls())
closeAllConnections()

setwd(getwd())
dir.create('intensity',showWarnings=FALSE)

library(sp, lib.loc="/home/ps629/RLibs/")
library(data.table, lib.loc="/home/ps629/RLibs/")
library(dplyr, lib.loc="/home/ey246/R/x86_64-pc-linux-gnu-library/3.3/")

###INPUT

load("/home/ey246/UKBB_recalling/UKBB_intensity_recall_good.RData")
#dsn1<-read.table("/home/ey246/claudia/int_ukbl.txt", as.is=T, header=T)
dsn1[dsn1==-1] <- NA

##Pre-define RData variant call intenisties file (dsn1) with intenisitis for variants we want to recall 
## ID bacth array Affx-1_x Affx-1_y Affx-2_x Affx-2_y ...

snps<-(unlist(read.table("/home/ey246/UKBB_recalling/list_recall1.txt", as.is=T, header=F)))


##list of SNPs to recall
# Affx.11359144
# Affx.11360020

##===================================
#Data preparation 
##==========================

for (i in snps) {
 
  dt<-data.frame(dsn1$UKBBID, dsn1$array, dsn1$batch, select(dsn1, contains(i)))
  
  ukbb<- subset(dt, dsn1.array=="UKBB")
  ukbl <- subset(dt, dsn1.array=="UKBL")
  
  ifelse (length(ukbb[,3])==0, array<-"UKBL", ifelse (length(ukbl[,3])==0, array<-"UKBB", array<-c("UKBB", "UKBL")))
  
  a<-unlist(array)

  for (j in a) {
  dsn <- dt[dt$dsn1.array==j,]
  names(dsn)<-c("ID", "array", "batch", paste0(i,"A"), paste0(i,"B"))
  save(dsn,file=paste0("/home/ey246/UKBB_recalling/intensity/Intensities_UKBB",i,"array_",j,".RData"))    
}
}  