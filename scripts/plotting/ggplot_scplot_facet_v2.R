#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args) < 9) {
  stop("Usage\nscript.R <input> <xcol> <ycol> <colors_file> <fonts_file> <xlabel> <ylabel> <title> <outfile>\n", call.=FALSE)
} else if (length(args)>=1) {
  # default output file
  ifile = args[1]
  xcol = args[2]
  ycol = args[3]
  color_file = args[4]
  fonts = args[5]
  xlabel = args[6]
  ylabel = args[7]
  t = args[8]
  outfile = args[9]
}

library("data.table")
library("ggplot2")
library("grid")
print("Sourcing color file and fonts...")
source(color_file)
source(fonts)

df = fread(ifile, header=TRUE,sep='\t')
df = as.data.frame(df)
cols = c(paste0(xcol),paste0(ycol),"Haplogroup","Tag","Group")
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
print(df$Group)

#calc correlation

#print(x)
#print(y)


print("Plotting...")

bp<- ggplot(df, aes(x,y))+ geom_point(aes(color=Legend))+ scale_color_manual(Legend,values=clist,name=t) 
bp<- bp + facet_grid(Group ~ Tag,scale='free')
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
	legend.key = element_blank())

bp<- bp + scale_x_continuous(limits = c(0, 5)) + scale_y_continuous(limits = c(0, 5))

dat_text <- data.frame(
	label = c(paste("N = 196 \n Rho = 0.73 \n P < 2.2e-16"), paste("N = 235 \n Rho = 0.89 \n P < 2.2e-16"), paste("N = 151 \n Rho = 0.78 \n P < 2.2e-16"),paste("N = 230 \n Rho = 0.36 \n P = 3.1e-08"),paste("N = 245 \n Rho = 0.73 \n P < 2.2e-16"),paste("N = 151 \n Rho = 0.79 \n P < 2.2e-16")),
	Tag = c("UK Biobank vs 1000 Genomes","UK Biobank vs GenBank","UK Biobank vs WTCCC","UK Biobank vs 1000 Genomes","UK Biobank vs GenBank","UK Biobank vs WTCCC"),
	Group = c("Europeans","Europeans","Europeans","All","All","All"))


bp<- bp + geom_text(data = dat_text,mapping = aes(x = c(1,1,1,1,1,1),y = c(4,4,4,4,4,4), label = label),fontface = "bold",size = 3,family="Helvetica",color="black")  

bp + geom_abline(slope=1, intercept=0,linetype='F1',colour='gray29')

ggsave(outfile,units='in',width=9,height=6)

print("Done.")

