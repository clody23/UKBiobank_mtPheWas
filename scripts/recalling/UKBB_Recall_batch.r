##===============================
##This is a script for recalling within array and spliting per batch
##
##Left clicks to drwo the polygons 
##Right click after drawing each polygon, don't use the middle mouse butten and don't cklick backwords to avoid R crashing 
##Always call starting from x (AA) and then moving to y (BB)
##================================


#/bin/R

rm(list=ls())
closeAllConnections()

setwd(getwd())
dir.create('recalled',showWarnings=FALSE)

library(sp, lib.loc="/home/ps629/RLibs/")
library(data.table, lib.loc="/home/ps629/RLibs/")
library(dplyr, lib.loc="/home/ey246/R/x86_64-pc-linux-gnu-library/3.3/")

###INPUT

allele.info.ref <- fread("/home/ey246/UKBB_recalling/map.txt",header=T,showProgress=F)

###You need a file (allele.info.ref) that lists the alleles for each SNP in format:
####Order of alleles must be the same as in the origianl BED file!!!
###Name    B37_CHR_POS     CHR_B37 POS_B37 A_allele        B_allele        STRAND_TOP_B37  A_plus  B_plus
###Affx.11359144      MT:1438 MT      1438    A       G       +       A       G
###Affx.11360020      MT:7028 MT      7028    T       C       +       T       C

snps<-read.table("/home/ey246/UKBB_recalling/by_batch.txt", as.is=T, header=F)

#Aff.1 format
#i="Affx-52321475"

for (i in unlist(snps)) {
f1<-paste0("/home/ey246/UKBB_recalling/intensity/Intensities_UKBB",i,"array_UKBB.RData")
f2<-paste0("/home/ey246/UKBB_recalling/intensity/Intensities_UKBB",i,"array_UKBL.RData")

ifelse(file.exists(f1) & file.exists(f2), ar<-c("UKBB", "UKBL"), ifelse (file.exists(f1), ar<-"UKBB", ar<-"UKBL"))

for (j in ar){
#j="UKBL"
#load (Sys.glob(paste0("/home/ey246/claudia/intensity/Intensities_UKBB",i,"array_*.RData"))) 
load ((paste0("/home/ey246/UKBB_recalling/intensity/Intensities_UKBB",i,"array_",j,".RData"))) 
if (all(is.na(dsn[,4]))) {next}
#load ((paste0("/home/ey246/claudia/intensity/Intensities_UKBB",i,"array_UKBL.RData"))) 

#exclude individuals, modifiy with your own ids
dsn=dplyr::filter(dsn, !grepl('id1|id2|id3|...|idn',ID))

##================================
## Make required vectors
##================================

for (m in unique(dsn$batch)){
#for (m in (c("Batch_b067", "Batch_b071", "Batch_b080", "Batch_b081", "Batch_b095"))){
#m="Batch_b016"
#m="UKBiLEVEAX_b10"


dt <- dsn[dsn$batch==m,]
row.names(dt)<-dt[,1]
sample.names <- row.names(dt)
intensities.a <- dt[,4]
intensities.b <- dt[,5]
j=unlist(dsn[,2])[1]
variant.name=i
nas <- length(unique(which(is.na(intensities.a)==TRUE | is.na(intensities.b)==TRUE)))
alleles <- unlist(as.character(allele.info.ref[Name==variant.name,.(A_plus,B_plus)]))
calls.genotypes <- rep("00",length(intensities.a))
calls.fam <- as.data.frame(cbind(sample.names,sample.names,0,0,-9,-9))
calls.fam[,1] <- gsub("\\.","-",calls.fam[,1])
calls.fam[,2] <- gsub("\\.","-",calls.fam[,2])
plot.name <- paste("ukbb_",variant.name,"_array_",j,"batch_",m,sep="")
x.label <-  paste("ALLELE_A (",alleles[1],")",sep="")
y.label <-  paste("ALLELE_B (",alleles[2],")",sep="")
min.int <- min(c(intensities.a,intensities.b),na.rm=TRUE)
max.int <- max(c(intensities.a,intensities.b),na.rm=TRUE)
aa <- paste(alleles[c(1,1)],collapse="")
ab <- paste(alleles[c(1,2)],collapse="")
bb <- paste(alleles[c(2,2)],collapse="")
goodsamples.no <- nrow(calls.fam)-nas
calls.made <- 0
define.happy <- FALSE
      
      ##==================================
      ## Plot until happy with definitions
      ##==================================
      
      max.a=max(intensities.a)
      max.b=max(intensities.b)
      
      plot(intensities.a, intensities.b, 
      			xlim = c(min.int, max.a), 
      			ylim = c(min.int, max.b), 
      			ylab = y.label, xlab = x.label, pch = 20, 
        		main = plot.name, 
      			)
      
      #plot(intensities.a, intensities.b, 
           #xlim = c(min.int, max.int), 
          # ylim = c(min.int, max.int), 
          # ylab = y.label, xlab = x.label, pch = 20, 
          # main = plot.name)
      
      cat("Select samples with AA genotype\n")
      genotype.define  <- locator(type = "o", lty = 2, col = "blue")
      genotype.defined <- point.in.polygon(intensities.a, intensities.b, genotype.define$x, genotype.define$y)
      
      calls.genotypes[which(genotype.defined==1)] <- aa
      calls.made <- length(which(calls.genotypes!='00'))
      print(aa)
      
      points(intensities.a[which(genotype.defined==1)],intensities.b[which(genotype.defined==1)],pch=20,col='darkgreen')
      
      if(calls.made!=goodsamples.no) {
        
        cat("Select samples with BB genotype\n")
        genotype.define  <- locator(type = "o", lty = 2, col = "blue")
        genotype.defined <- point.in.polygon(intensities.a, intensities.b, genotype.define$x, genotype.define$y)
        
        calls.genotypes[which(genotype.defined==1)] <- bb
        calls.made <- length(which(calls.genotypes!='00'))
        
        
        points(intensities.a[which(genotype.defined==1)],intensities.b[which(genotype.defined==1)],pch=20,col='maroon')	
      }
      if(calls.made!=goodsamples.no) {
        
        points(intensities.a[which(calls.genotypes=='00')],intensities.b[which(calls.genotypes=='00')],pch=20,col='black')	
        
      }	
      
      ##====================================
      ## Done with recalling
      ##====================================
      
      index.info <- which(allele.info.ref$Name==variant.name)
      
      calls.genotypes <- unlist(strsplit(paste(calls.genotypes,collapse=""),split=""))
      calls.genotypes <- c(allele.info.ref$CHR_B37[index.info],allele.info.ref$Name[index.info],"0",allele.info.ref$POS_B37[index.info],calls.genotypes)
      
      write.table(paste(calls.genotypes,collapse=" "),paste0('./recalled/',"ukbb",'_',variant.name,"array_",j,"batch_",m,'.tped'),col.names=FALSE,row.names=FALSE,quote=FALSE,sep="\t")
      write.table(calls.fam,paste0('./recalled/',"ukbb",'_',variant.name,"array_",j,"batch_",m,'.tfam'),col.names=FALSE,row.names=FALSE,quote=FALSE,sep="\t")
      #write.table(paste(calls.genotypes,collapse=" "),paste0('/home/ey246/UKBB_recalling/redone/',"ukbb",'_',variant.name,"array_",j,"batch_",m,'.tped'),col.names=FALSE,row.names=FALSE,quote=FALSE,sep="\t")
      #write.table(calls.fam,paste0('/home/ey246/UKBB_recalling/redone/',"ukbb",'_',variant.name,"array_",j,"batch_",m,'.tfam'),col.names=FALSE,row.names=FALSE,quote=FALSE,sep="\t")
      obj.list <- ls()
      dev.off()
}
}
}
 
