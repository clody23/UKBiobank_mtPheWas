#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args) < 16) {
  stop("Usage\nscript.R <input1> <xcol1> <zcol1> <xlabel1> <ylabel2> <tlegend1> <input2> <xcol2> <ycol2> <zcol2> <xlabel2> <ylabel2>  <tlegend2> <color_file> <font_file> <outfile>\n", call.=FALSE)
} else if (length(args)>=1) {
  # default output file
  ifile1 = args[1]
  xcol1 = args[2]
  zcol1 = args[3]
  xlabel1 = args[4]
  ylabel1 = args[5]
  t1 = args[6]
  ifile2 = args[7]
  xcol2 = args[8]
  ycol2  = args[9]
  zcol2 = args[10]
  xlabel2 = args[11]
  ylabel2 = args[12]
  t2 = args[13]
  color_file = args[14]
  fonts_file = args[15]
  outfile = args[16]
}

library("data.table")

df1 = fread(ifile1, header=TRUE,sep='\t')
df1 = as.data.frame(df1)
df2 = fread(ifile2, header=TRUE,sep='\t')
df2 = as.data.frame(df2)
library("ggplot2")
library("cowplot")
print("Sourcing color file and fonts...")
source(color_file)
source(fonts_file)


x1 = -log10(df1[[paste0(xcol1)]])
Legend = df1[[paste0(zcol1)]]

print("Plotting...")

dp<- ggplot(df1, aes(x=x1,fill=Legend)) + 
	geom_histogram(binwidth=0.1, color="black",size=0.1, alpha=.6,position="identity") +
	geom_density(alpha=.2,aes(y=0.1 * ..count.., color=Legend),linetype="dashed",size=1.5)+ 
	scale_color_manual(Legend,values=clist,name=t1)+ 
	scale_fill_manual(Legend,values=clist,name=t1)+
	theme_classic()
dp<- dp + labs(x = xlabel1, y = ylabel1) +  
	theme(plot.title = element_text(hjust = 0.5), 
	text = element_text(size=18),
	legend.position="top",
	axis.text.x = element_text(angle = 0, family="Helvetica",face="bold",size=14),
	axis.text.y=element_text(family="Helvetica",face="bold",size=14),
	axis.title.x = element_text(size=18,family="Helvetica",face="bold"),
	axis.title.y = element_text(size=18,family="Helvetica",face="bold"),
	legend.text = element_text(size=14,family="Helvetica"),
	legend.title = element_text(size=14,family="Helvetica",face="bold"),
	legend.key = element_blank())
print("Done")
#plot2 inset
Legend2 = df2[[paste0(zcol2)]]
x2 = df2[[paste0(xcol2)]]
y2 = df2[[paste0(ycol2)]]
bp<- ggplot() + geom_bar(aes(x = x2, y = y2,fill = Legend2), color='black', data = df2, stat='identity') + scale_fill_manual(Legend2,values=clist,guide=guide_legend(ncol=1),name=t2)+theme_classic()
bp<- bp + labs(x = xlabel2, y = ylabel2) +
	theme(plot.title = element_text(hjust = 0.5),
	text = element_text(size=18),
	legend.position="none",
	axis.text.x = element_blank(),
        axis.text.y=element_text(family="Helvetica",face="bold",size=14),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size=18,family="Helvetica",face="bold"),
        legend.text = element_text(size=14,family="Helvetica"),
        legend.title = element_text(size=14,family="Helvetica",face="bold"),
        legend.key = element_blank(),
	panel.background = element_rect(fill = "transparent",colour = NA),
	plot.background = element_rect(fill = "transparent",colour = NA))

print("Done")

#ggdraw()+	
#	draw_plot(dp, theme(legend.justification = "bottom", 0,0,1,1)) +
#	draw_plot(bp, theme(legend.justification = "top"), 0.5, 0.52, 0.5, 0.4) + 
#	draw_plot_label(c("a", "b"), c(0, 0.5), c(1, 0.92), size = 15)

dp + annotation_custom(ggplotGrob(bp),xmin = 4.6, ymin = 0.2, xmax = 5.2)

ggsave(outfile,units='in',width=10,height=6)


print("Done.")
