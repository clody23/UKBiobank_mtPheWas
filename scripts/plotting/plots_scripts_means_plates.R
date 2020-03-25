library(data.table)
library(ggplot2)
library(cowplot)

####mean ouliers
data<-fread("/home/ey246/claudia/mean_int_ukbb.txt", header=T, stringsAsFactors=FALSE)
data2<-fread("/home/ey246/claudia/mean_int_ukbl.txt", header=T, stringsAsFactors=FALSE)
mx<-mean(data$intabb)
sdx<-sd(data$intabb)
x7h<-mx+7*sdx
x7l<-mx-7*sdx
x10h<-mx+10*sdx
x10l<-mx-10*sdx
my<-mean(data$intbbb)
sdy<-sd(data$intbbb)
y7h<-my+7*sdy
y7l<-my-7*sdy
y10h<-my+10*sdy
y10l<-my-10*sdy
x_lim<-max(data$intabb)
y_lim<-max(data$intbbb)
dmx<-mean(data2$intabb)
dsdx<-sd(data2$intabb)
dx7h<-dmx+7*dsdx
dx7l<-dmx-7*dsdx
dmy<-mean(data2$intbbb)
dsdy<-sd(data2$intbbb)
dy7h<-dmy+7*dsdy
dy7l<-dmy-7*dsdy
dx_lim<-max(data2$intabb)
dy_lim<-max(data2$intbbb)
p1<-ggplot(data=data, aes(intabb,intbbb))+geom_point()+ labs(title="UK Biobank array")+ xlab("mean A allele intensity") + ylab("mean B allele intensity")+xlim(1000,x_lim)+ylim(1000,y_lim)+
geom_vline(aes(xintercept=x7h, colour = 'blue4')) + geom_vline(aes(xintercept=x10h, colour = 'magenta')) + 
geom_hline(aes(yintercept=y7h, colour = 'blue4')) + geom_hline(aes(yintercept=y10h, colour = 'magenta'))+
theme(axis.text.y = element_text(family="helvetica",size=12))+
theme(axis.text.x = element_text(family="helvetica",size=12))+
theme(axis.title.y = element_text(family="helvetica",face="bold",size=14))+
theme(axis.title.x = element_text(family="helvetica",face="bold",size=14))+
theme(plot.title = element_text(family="helvetica",size=14))+theme(legend.position="none")+
theme(plot.title = element_text(hjust = 0.5))+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
panel.background = element_blank(), axis.line = element_line(colour = "black"))
p2<-ggplot(data=data2, aes(intabb,intbbb))+geom_point()+ labs(title="UK BiLEVE array")+ xlab("mean A allele intensity") + ylab("mean B allele intensity")+xlim(1000,dx_lim)+ylim(1000,dy_lim)+
geom_vline(aes(xintercept=dx7h, colour = 'magenta')) + geom_hline(aes(yintercept=dy7h, colour = 'magenta')) +
theme(axis.text.y = element_text(family="helvetica",size=12))+
theme(axis.text.x = element_text(family="helvetica",size=12))+
theme(axis.title.y = element_text(family="helvetica",face="bold",size=14))+
theme(axis.title.x = element_text(family="helvetica",face="bold",size=14))+
theme(plot.title = element_text(family="helvetica",size=14))+theme(legend.position="none")+ theme(plot.title = element_text(hjust = 0.5))+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
panel.background = element_blank(), axis.line = element_line(colour = "black"))
plot_grid(p1, p2, labels=c('a', 'b'), label_fontfamily ="helvetica", label_size=14)
ggsave("FigureS2.jpeg", dpi=300, width =14, height =7)
##plate effects
data<-fread("/home/ey246/claudia/mean_int_ukbb.txt",header=T, stringsAsFactors=FALSE)
data2<-fread("plates_batches.txt",header=T, stringsAsFactors=FALSE)
names(data)[1]<-names(data2)[1]
df<-merge(data,data2,by="iid")
b53<-subset(df,batch=="Batch_b053")
b53$col<-ifelse( b53$plate=="SMP4_0011842A", "greay", "black")
b78<-subset(df,batch=="Batch_b078")
b78$col<-ifelse( b78$plate=="SMP4_0013977A", "grey",ifelse( b78$plate=="SMP4_0015506A", "plum", ifelse(b78$plate=="SMP4_0013808A","seagreen1", "black")))
b87<-subset(df,batch=="Batch_b087")
b87$col<-ifelse( b53$plate=="SMP4_0011380A", "grey", "black")
p1<-ggplot(data=b53, aes(intabb,intbbb))+geom_point(col=b53$col)+ labs(title="Batch 53")+ xlab("mean A allele intensity") + ylab("mean B allele intensity")+
theme(axis.text.y = element_text(family="helvetica",size=12))+
theme(axis.text.x = element_text(family="helvetica",size=12))+
theme(axis.title.y = element_text(family="helvetica",face="bold",size=14))+
theme(axis.title.x = element_text(family="helvetica",face="bold",size=14))+
theme(plot.title = element_text(family="helvetica",size=14))+theme(legend.position="none")+ theme(plot.title = element_text(hjust = 0.5))+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
panel.background = element_blank(), axis.line = element_line(colour = "black"))
p2<-ggplot(data=b78, aes(intabb,intbbb))+geom_point(col=b78$col)+ labs(title="Batch 78")+ xlab("mean A allele intensity") + ylab("mean B allele intensity")+
theme(axis.text.y = element_text(family="helvetica",size=12))+
theme(axis.text.x = element_text(family="helvetica",size=12))+
theme(axis.title.y = element_text(family="helvetica",face="bold",size=14))+
theme(axis.title.x = element_text(family="helvetica",face="bold",size=14))+
theme(plot.title = element_text(family="helvetica",size=14))+theme(legend.position="none")+ theme(plot.title = element_text(hjust = 0.5))+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
panel.background = element_blank(), axis.line = element_line(colour = "black"))
p3<-ggplot(data=b87, aes(intabb,intbbb))+geom_point(col=b87$col)+ labs(title="Batch 87")+ xlab("mean A allele intensity") + ylab("mean B allele intensity")+
theme(axis.text.y = element_text(family="helvetica",size=12))+
theme(axis.text.x = element_text(family="helvetica",size=12))+
theme(axis.title.y = element_text(family="helvetica",face="bold",size=14))+
theme(axis.title.x = element_text(family="helvetica",face="bold",size=14))+
theme(plot.title = element_text(family="helvetica",size=14))+theme(legend.position="none")+ theme(plot.title = element_text(hjust = 0.5))+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
panel.background = element_blank(), axis.line = element_line(colour = "black"))
plot_grid(p1, p2, p3, labels=c('a', 'b', "c"), label_fontfamily ="helvetica", label_size=14)
ggsave("FigureS3.jpeg", dpi=300, width =14, height =14)