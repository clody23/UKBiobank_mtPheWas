#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args) < 8) {
  stop("Usage\nscript.R <input> <xcol> <ycol> <label>  <xlabel> <ylabel> <title> <outfile>\n", call.=FALSE)
} else if (length(args)>=1) {
  # default output file
  ifile = args[1]
  xcol = args[2]
  ycol = args[3]
  label = args[4]
  xlabel = args[5]
  ylabel = args[6]
  t = args[7]
  outfile = args[8]
}

library("data.table")

df = fread(ifile, header=TRUE,sep='\t')
df = as.data.frame(df)

#print('Remove NAs, if found...')
#df = df[complete.cases(df), ]

library(ggplot2)
print("Sourcing color file...")
#source(color_file)

#fill <- "grey"
#line <- "black"

cols = c(paste0(xcol),paste0(ycol),paste0(label))

x = df[[cols[1]]]

y = as.numeric(df[[cols[2]]])

label = as.factor(df[[cols[3]]])

print("Plotting...")
#png(outfile,units="in", width=6, height=5, res=300)
bp<- ggplot(df, aes(reorder(x,y,order=TRUE),y)) + geom_bar(stat='identity',position = "dodge",alpha=0.6,size=1,fill="brown1",colour="brown1")+theme_classic()
bp<- bp + labs(x = xlabel, y = ylabel, title=t) + theme(plot.title =element_text(hjust = 0.5), 
	text=element_text(size=18),
	legend.position="none",
	axis.text.x = element_text(angle = 45, hjust = 1, family="Helvetica",face="bold",size=14),
	axis.text.y=element_text(family="Helvetica",face="bold",size=14),
	axis.title.x = element_text(size=18,family="Helvetica",face="bold"),
	axis.title.y = element_text(size=18,family="Helvetica",face="bold"),
	legend.text = element_text(size=14,family="Helvetica"),
	legend.title = element_text(size=14,family="Helvetica",face="bold"),
	legend.key = element_blank())

bp<- bp + coord_flip()
bp + geom_text(aes(label=label), position=position_dodge(width=0.25), vjust=0,hjust=0.05,angle=0,size=4)
ggsave(outfile,units="in",width=9.5, height=6)


print("Done.")

