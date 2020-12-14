#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args) < 9) {
  stop("Usage\nscript.R <input> <xcol> <ycol> <zcol> <colors_file> <xlabel> <ylabel> <title> <outfile>\n", call.=FALSE)
} else if (length(args)>=1) {
  # default output file
  ifile = args[1]
  xcol = args[2]
  ycol = args[3]
  zcol = args[4]
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

#fill <- "grey"
#line <- "black"

cols = c(paste0(xcol),paste0(ycol),paste0(zcol))

x = as.numeric(df[[cols[1]]])

y = as.numeric(df[[cols[2]]])
Legend = df[[cols[3]]]


#print(x)
#print(y)

print("Plotting...")
bp<-ggplot(df, aes(x,y))+ 
	geom_point(aes(color=Legend)) + 
	scale_color_manual(Legend,values=clist) + 
	scale_fill_manual(Legend,values=clist)
bp + labs(x = xlabel, y = ylabel, title=t)+ 
	theme(plot.title = element_text(hjust = 0.5)) + 
	theme(text = element_text(size=12), axis.text.x = element_text(angle = 90, hjust = 1)) + 
	#theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
	theme(legend.position="bottom") + theme_classic(base_size=22)

ggsave(outfile,width=7,height=8)

print("Done.")

