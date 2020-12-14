#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args) < 7) {
  stop("Usage\nscript.R <input> <xcol> <ycol> <fonts_file> <xlabel> <ylabel> <outfile>\n", call.=FALSE)
} else if (length(args)>=1) {
  # default output file
  ifile = args[1]
  xcol = args[2]
  ycol = args[3]
  fonts = args[4]
  xlabel = args[5]
  ylabel = args[6]
  outfile = args[7]
}

library("data.table")
library("ggplot2")

print("Sourcing color file and fonts...")

source(fonts)

df = fread(ifile, header=TRUE,sep='\t')
df = as.data.frame(df)
cols = c(paste0(xcol),paste0(ycol))
df = subset(df,select=cols)
print('Remove NAs, if found...')
df = df[complete.cases(df), ]

head(df)
x = -log10(as.numeric(df[[cols[1]]]))
y = -log10(as.numeric(df[[cols[2]]]))

print("Plotting...")

bp<- ggplot(df, aes(x,y))+ geom_point(colour = "black",fill="darkslategray3",size=5,shape=21,alpha=0.7) + geom_smooth(method=lm,colour="black",linetype = "dashed")
bp<- bp + labs(x = xlabel, y = ylabel) + theme_bw()
bp<- bp + theme(plot.title = element_text(hjust = 0.5), 
	text = element_text(size=14), 
	legend.position="bottom",
	axis.text.x = element_text(angle = 0, hjust = 1, family="Helvetica",face="bold",size=12),
	axis.text.y=element_text(family="Helvetica",face="bold",size=12), 
	axis.title.x = element_text(size=14,family="Helvetica",face="bold"),
	axis.title.y = element_text(size=14,family="Helvetica",face="bold"),
	legend.text = element_text(size=13,family="Helvetica"),
	legend.title = element_text(size=13,family="Helvetica",face="bold"),
	legend.key = element_blank(),
	panel.grid.major = element_blank(),
	panel.grid.minor = element_blank()) +
	coord_fixed(xlim = c(0, 5),ylim = c(0,5))

bp<- bp + geom_abline(slope=1, intercept=0,linetype='F1',colour='gray29')
bp + annotate("text",x = 4, y = 2, label = "N = 241 \n Rho = 0.99 \n P < 2.2e-16",fontface = "bold",size = 5,family="Helvetica",color="black") + theme_classic()
ggsave(outfile,units='in',width=5,height=5)

print("Done.")

