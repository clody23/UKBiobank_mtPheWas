#!/usr/bin/env Rscript

library(data.table)
require(foreign)
require(nnet)
require(ggplot2)
require(reshape2)


ifile <- 'UKBiobank_samples_to_macro_haplo_matrix_to_covariates_to_DS.v3.txt'

SNP <- "DS_11778"
df <- fread(ifile,sep='\t',header=T)

head(df)

#remove NAs

df<-subset(df,select=c("Macro_haplogroup",paste0(SNP),"Array","Sex","Easting_postcode_invnorm","Northing_postcode_invnorm","Easting_birth_invnorm","Northing_birth_invnorm"))

df <- df[complete.cases(df), ]

head(df)
df$Macro_haplogroup <- as.factor(df$Macro_haplogroup)
with(df,table(df[[paste0(SNP)]],Macro_haplogroup))
with(df,table(df[[paste0(SNP)]],Sex))
with(df,table(df[[paste0(SNP)]],Array))

df$Macro_haplogroup2 <- relevel(df$Macro_haplogroup,ref = "H")

predictors<-c(paste0(SNP),"Array","Sex","Easting_postcode_invnorm","Northing_postcode_invnorm","Easting_birth_invnorm","Northing_birth_invnorm")
predictors<-paste(predictors,collapse="+")
#print(predictors)
f<-as.formula(paste("Macro_haplogroup2 ~ ",predictors,sep=""))
print(f)
r<- multinom(f, data = df)


z<-summary(r)$coefficients/summary(r)$standard.errors

#calculate Wald pvalue using z-statistics
#p <- (1 - pnorm(abs(z), 0, 1)) * 2

p<-pnorm(abs(z),lower.tail=FALSE)*2

pval<-as.data.frame(p)
pval$Macro_haplo<-rownames(pval)
wald_pval<-pval[,c(paste0(SNP),"Macro_haplo")]
colnames(wald_pval)<-c("Wald_P","Macro_haplo")
or<-as.data.frame(exp(coef(r)))
or$Macro_haplo<-rownames(or)
or<-or[,c(paste0(SNP),"Macro_haplo")]
colnames(or)<-c("OR","Macro_haplo")
coeff<-as.data.frame(summary(r)$coefficients)
coeff$Macro_haplo<-rownames(coeff)
coeff<-coeff[,c(paste0(SNP),"Macro_haplo")]
colnames(coeff)<-c("Coeff","Macro_haplo")
ster<-as.data.frame(summary(r)$standard.errors)
ster$Macro_haplo<-rownames(ster)
ster<-ster[,c(paste0(SNP),"Macro_haplo")]
colnames(ster)<-c("Stderr","Macro_haplo")
ci<-as.data.frame(exp(confint(r)))
snp_ci<-ci[2,]
snp_ci<-matrix(snp_ci,ncol=8)
snp_ci<-as.data.frame(t(snp_ci))
snp_ci$Macro_haplo<-rownames(or)
colnames(snp_ci)<-c("CI_low","CI_up","Macro_haplo")
snp_ci_df<-data.frame(cbind(unlist(snp_ci$CI_low),unlist(snp_ci$CI_up),snp_ci$Macro_haplo))
colnames(snp_ci_df)<-c("CI_low","CI_up","Macro_haplo")

#zscore<-as.data.frame(z)
#zscore$Macro_haplo<-rownames(zscore)

i = coeff
for (d in list(ster,or,snp_ci_df,wald_pval)) {
	i = merge(i,d,by=c("Macro_haplo"))
}


write.table(i,file=paste0("Multinominal_regression_",SNP,".txt"),sep='\t',col.names=T,row.names=F,quote=F)

