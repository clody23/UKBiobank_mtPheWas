#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args) < 8) {
  stop("Usage\nscript.R <input> <xcol> <ycol> <colors_file> <xlabel> <ylabel> <title> <outfile>\n", call.=FALSE)
} else if (length(args)>=1) {
  # default output file
  ifile = args[1]
  xcol = args[2]
  ycol = args[3]
  color_file = args[4]
  xlabel = args[5]
  ylabel = args[6]
  t = args[7]
  outfile = args[8]
}

library("data.table")
library("ggplot2")
library("grid")
print("Sourcing color file and fonts...")
source(color_file)


df = fread(ifile, header=TRUE,sep='\t')
df = as.data.frame(df)
cols = c(paste0(xcol),paste0(ycol),"Population","Tag")
df = subset(df,select=cols)
print('Remove NAs, if found...')
df = df[complete.cases(df), ]

x = as.numeric(df[[cols[1]]])
x = -log10(x)
y = as.numeric(df[[cols[2]]])
y = -log10(y)
#print(x)

Legend = df[[cols[3]]]
print(df$Tag)


#calc correlation

#print(x)
#print(y)


print("Plotting...")

bp<- ggplot(df, aes(x,y))+ geom_point(aes(color=Legend),shape=1,size=4)+ scale_color_manual(Legend,values=clist,name=t) 
bp<- bp + facet_grid(. ~ Tag,scale='free')
bp<- bp + labs(x = xlabel, y = ylabel) + theme_bw()
bp<- bp + theme(plot.title = element_text(hjust = 0.5), 
	text = element_text(size=18), 
	legend.position="top",
	axis.text.x = element_text(angle = 0, family="Helvetica",face="bold",size=14),
	axis.text.y=element_text(family="Helvetica",face="bold",size=14), 
	axis.title.x = element_text(size=18,family="Helvetica",face="bold"),
	axis.title.y = element_text(size=18,family="Helvetica",face="bold"),
	legend.text = element_text(size=14,family="Helvetica"),
	legend.title = element_text(size=14,family="Helvetica",face="bold"),
	legend.key = element_blank(),
	panel.grid.major = element_blank(),
	panel.grid.minor = element_blank())

bp<- bp + scale_x_continuous(limits = c(0, 3.5)) + scale_y_continuous(limits = c(0, 3.5))

dat_text <- data.frame(
	label = c(paste("N = 178 \n Rho = 0.9 \n P < 2.2e-16"), paste("N = 96 \n Rho = 0.8 \n P < 2.2e-16")),
	Tag = c("Genotyped SNVs","Imputed SNVs"))


bp<- bp + geom_text(data = dat_text,mapping = aes(x = c(2,2),y = c(3,3), label = label),fontface = "bold",size = 3,family="Helvetica",color="black")  

bp + geom_abline(slope=1, intercept=0,linetype='F1',colour='gray29') + theme_classic()

ggsave(outfile,units='in',width=9,height=6)

print("Done.")

