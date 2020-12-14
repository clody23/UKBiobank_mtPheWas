#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args) < 8) {
  stop("Usage\nscript.R <input> <xcol> <ycol> <fonts_file> <xlabel> <ylabel> <title> <outfile>\n", call.=FALSE)
} else if (length(args)>=1) {
  # default output file
  ifile = args[1]
  xcol = args[2]
  ycol = args[3]
  fonts_file = args[4]
  xlabel = args[5]
  ylabel = args[6]
  t = args[7]
  outfile = args[8]
}

source(fonts_file)

library("data.table")
library("dplyr")
df = fread(ifile, header=TRUE,sep='\t')
df = as.data.frame(df)

library(ggplot2)



cols = c(paste0(xcol),paste0(ycol))
df<-select(df,cols[1],cols[2],'Index','Count')
df = df[complete.cases(df), ]

x = as.character(df[[cols[1]]])

y = as.numeric(df[[cols[2]]])

categorical = as.numeric(df$Index)
counts = as.numeric(df$Count)
head(df)


length(x)
length(categorical)


define.y <- function(x){
  return(c(y = max(x)+0.1)) 
}
sums <- c(by(counts,x, sum))
maxs <- c(by(y,x, define.y))
print(unlist(sums))
print(maxs)
print("Plotting...")
bp=ggplot(df, aes(x=reorder(x,categorical),y=y)) + geom_boxplot(fill = "darkslategray3",notch=FALSE,outlier.size = 0.5,outlier.shape =1,outlier.colour="gray15")+ theme_classic()
bp= bp + geom_hline(aes(yintercept = 0.7),color='gray15',linetype = "dashed")
bp = bp + labs(x = xlabel, y = ylabel, title=t) +  theme(plot.title = element_text(hjust = 0.5)) + theme(axis.text.x = element_text(angle = 45, hjust = 1, family="Helvetica",face="bold",size=18)) + theme(axis.text.y=element_text(family="Helvetica",face="bold",size=18)) + theme(axis.title.x = element_text(size=18,family="Helvetica",face="bold"))+theme(axis.title.y = element_text(size=18,family="Helvetica",face="bold")) + theme(legend.position="none")

print(names(maxs))
df2 = data.frame(label = as.factor(sums),Bins = levels(as.factor(names(maxs))),Max = maxs)
print(df2)
bp + geom_text(data = df2, mapping=aes(x=levels(as.factor(names(maxs))),y=Max,label = label),size = 5,family="Helvetica",color="black")



ggsave(paste0(outfile),units=c("in"), width=6, height=5)
print("Done.")

