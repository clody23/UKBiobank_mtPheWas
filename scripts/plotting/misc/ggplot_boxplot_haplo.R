#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args) < 10) {
  stop("Usage\nscript.R <input> <xcol> <ycol> <zcol> <colors_file> <fonts_file> <xlabel> <ylabel> <title> <outfile>\n", call.=FALSE)
} else if (length(args)>=1) {
  # default output file
  ifile = args[1]
  xcol = args[2]
  ycol = args[3]
  zcol = args[4]
  color_file = args[5]
  fonts_file = args[6]
  xlabel = args[7]
  ylabel = args[8]
  t = args[9]
  outfile = args[10]
}

source(fonts_file)

library("data.table")
library("dplyr")
df = fread(ifile, header=TRUE,sep='\t')
df = as.data.frame(df)

#print('Remove NAs, if found...')
#df = df[complete.cases(df), ]

library(ggplot2)
print("Sourcing color file...")
source(color_file)

#fill <- "grey"
#line <- "black"

cols = c(paste0(xcol),paste0(ycol),paste0(zcol))
df<-select(df,cols[1],cols[2],cols[3])
df = df[complete.cases(df), ]

x = df[[cols[1]]]

y = as.numeric(df[[cols[2]]])


Legend = df[[cols[3]]]
head(df)
categories = as.numeric(df$Group)

length(x)
length(categories)
print("Plotting...")
bp=ggplot(df, aes(x=x,y=y,fill=as.factor(Legend))) + geom_boxplot(notch=FALSE,outlier.size = 0.5,outlier.shape =1,outlier.colour="gray15")+ scale_fill_manual(Legend,values=clist,name=t)+ theme_classic()
#bp + labs(x = xlabel, y = ylabel, title=t) +  theme(plot.title = element_text(hjust = 0.5)) + theme(axis.text.x = element_text(angle = 0, hjust = 1, family="Helvetica",face="bold",size=12)) + theme(axis.text.y=element_text(family="Helvetica",face="bold",size=12)) + theme(axis.title.x = element_text(size=14,family="Helvetica",face="bold"))+theme(axis.title.y = element_text(size=14,family="Helvetica",face="bold")) +theme(legend.position=c("top"))
bp<- bp + labs(x = xlabel, y = ylabel)
bp + theme(plot.title = element_text(hjust = 0.5),
	text = element_text(size=18),
	legend.position="top",
	axis.text.x = element_text(angle = 0, family="Helvetica",face="bold",size=14),
	axis.text.y=element_text(family="Helvetica",face="bold",size=14), 
	axis.title.x = element_text(size=18,family="Helvetica",face="bold"),
	axis.title.y = element_text(size=18,family="Helvetica",face="bold"),
	legend.text = element_text(size=14,family="Helvetica"),
	legend.title = element_text(size=14,family="Helvetica",face="bold"),
	legend.key = element_blank())

ggsave(paste0(outfile),units=c("in"), width=16, height=5)
print("Done.")
#geom_boxplot(aes(colour = Legend))
