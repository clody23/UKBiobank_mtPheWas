#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args) < 9) {
  stop("Usage\nscript.R <input> <xcol> <ycol> <label> <color_file>  <xlabel> <ylabel> <title> <outfile>\n", call.=FALSE)
} else if (length(args)>=1) {
  # default output file
  ifile = args[1]
  xcol = args[2]
  ycol = args[3]
  label = args[4]
  color_file = args[5]
  xlabel = args[6]
  ylabel = args[7]
  t = args[8]
  outfile = args[9]
}

library("data.table")

df = fread(ifile, header=TRUE,sep='\t')
df = as.data.frame(df)

#print('Remove NAs, if found...')
#df = df[complete.cases(df), ]

library(ggplot2)
print("Sourcing color file...")
source(color_file)


cols = c(paste0(xcol),paste0(ycol),paste0(label),'Order')

x = df[[cols[1]]]

y = as.numeric(df[[cols[2]]])
order = as.numeric(df$Order)
label = as.factor(df[[cols[3]]])

print("Plotting...")
#png(outfile,units="in", width=6, height=5, res=300)
bp<- ggplot(df, aes(reorder(x,order,order=TRUE),y,fill=label)) + geom_bar(stat='identity',alpha=1,size=1,colour="black")+scale_fill_manual(label,values=clist,guide=guide_legend(ncol=8),name=t)+ theme_classic()
bp<- bp + labs(x = xlabel, y = ylabel) + theme(plot.title =element_text(hjust = 0.5), 
	text=element_text(size=18),
	legend.position="bottom",
	axis.text.x = element_text(angle = 45, hjust = 1, family="Helvetica",face="bold",size=14),
	axis.text.y=element_text(family="Helvetica",face="bold",size=14),
	axis.title.x = element_blank(),
	axis.title.y = element_text(size=18,family="Helvetica",face="bold"),
	legend.text = element_text(size=14,family="Helvetica"),
	legend.title = element_text(size=14,family="Helvetica",face="bold"),
	legend.key = element_blank())


ggsave(outfile,units="in",width=8, height=8)

print("Done.")

