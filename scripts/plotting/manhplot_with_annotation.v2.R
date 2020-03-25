#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args) < 10) {
  stop("Usage\nscript.R <input> <annotation.txt> <xcol> <ycol> <zcol> <colors_file> <xlabel> <ylabel> <title> <outfile>\n", call.=FALSE)
} else if (length(args)>=1) {
  # default output file
  ifile = args[1]
  annot = args[2]
  xcol = args[3]
  ycol = args[4]
  zcol = args[5]
  color_file = args[6]
  xlabel = args[7]
  ylabel = args[8]
  t = args[9]
  outfile = args[10]
}

library("data.table")
#library(cowplot)

df = fread(ifile, header=TRUE,sep='\t')
df = as.data.frame(df)
annotation = fread(annot,header=TRUE,sep='\t')
annotation = as.data.frame(annotation)

library(ggplot2)
print("Sourcing color file...")
source(color_file)


cols = c(paste0(xcol),paste0(ycol),paste0(zcol))

x = as.numeric(df[[cols[1]]])

y = as.numeric(df[[cols[2]]])
y = -log10(y)
Legend = df[[cols[3]]]


#annotation
xmin = annotation$Start_x
xmax = annotation$End_x
ymin = annotation$Start_y
ymax = annotation$End_y
label = annotation$Locus
Genomic.annotation = annotation$Genomic_annotation

print("Plotting...")


#manhplot

bp <- ggplot(df, aes(x,y,group=1))+ geom_point(pch=20,size=5,alpha=0.7) + coord_cartesian(ylim = c(0, 9))
bp <- bp + aes(colour=Legend) + scale_colour_manual(zcol,values=clist)
bp <- bp + facet_grid(Chapter ~ .,scales="free_y",labeller=label_wrap_gen(width = 6, multi_line = TRUE)) +
  theme(strip.text.x = element_text(size = 5.5),
        strip.background = element_rect(color="black",size=1.5),
        panel.border = element_rect(color = "black", fill="NA"))
bp <- bp + geom_hline(aes(yintercept=-log10(0.00005)), colour="dodgerblue", linetype="dashed")
bp <- bp + geom_hline(aes(yintercept=-log10(0.00000005)),colour="red",linetype="dashed")
bp <- bp + scale_x_continuous(breaks=c(seq(1,16569,by=1000)))
bp <- bp + scale_y_continuous(breaks=c(seq(0,8,by=2)))
bp <- bp + labs(x = xlabel, y = ylabel)+ theme(plot.title = element_text(hjust = 0.5)) +
  theme(text = element_text(size=11), axis.text.x = element_text(angle = 30, hjust = 1,face="bold")) + 
  theme(plot.margin = unit(c(-0.3,0.1,0,0.1),units = "in"), 
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"),
	axis.text.x = element_text(angle = 45, hjust = 1, family="Helvetica",face="bold",size=14),
	axis.text.y=element_text(family="Helvetica",face="bold",size=14),
	axis.title.x = element_text(size=18,family="Helvetica",face="bold"),
	axis.title.y = element_text(size=18,family="Helvetica",face="bold"),
	legend.text = element_text(size=12,family="Helvetica"),
	legend.title = element_text(size=14,family="Helvetica",face="bold"),
	legend.key = element_blank(),
        panel.border=element_rect(colour="black", fill=NA,size=1))+ 
  theme(legend.position="bottom")

anno <- ggplot() + geom_rect(data=annotation,mapping=aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax,fill=Genomic.annotation),color="gray72",alpha=0.7) +
  scale_fill_manual(values=clist2) +
  geom_text(data=annotation, aes(x=xmin+(xmax-xmin)/2, y=ymin+(ymax-ymin)/2, label=label), size=3,angle=90,color="black")+
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        panel.background=element_blank(),
        axis.line = element_blank(),
        panel.border = element_blank(),
        plot.margin = unit(c(0,0,0.05,0),units = "in"),
	legend.text = element_text(size=14,family="Helvetica"),
	legend.title = element_text(size=14,family="Helvetica"),
        legend.position="top") +
  labs(x = '', y = '', title='')
  

cowplot::plot_grid(anno, bp, ncol = 1, align = "v", axis = "lr", rel_heights = c(1, 10))

ggsave(outfile,units='in', width=15,height=18)

print("Done.")
