library(tidyverse)
setwd("C:/Users/Amanda/Desktop/dnds/")
all_killifish <- read.delim("dndsomega_data.csv", header=TRUE,sep=",")
all_significant <- subset(all_killifish,all_killifish$num_parameter=="two")
all_notsignificant <- subset(all_killifish,all_killifish$num_parameter=="one")

background <- select(all_significant,dS,background)
names(background) <- c("dS","dNdS")
foreground <- select(all_significant,dS,foreground)
names(foreground) <- c("dS","dNdS")
oneratio <- select(all_killifish,dS,one.ratio)
names(oneratio) <- c("dS","dNdS")
tworatio <- select(all_significant,dS,one.ratio)
names(tworatio) <- c("dS", "dNdS")

same <- select(all_notsignificant,dS,one.ratio)
names(same) <- c("dS","dNdS")

all_significant <- mutate(all_significant, difference = foreground - background)
nonannual <- subset(all_significant,all_significant$difference < 0)
annual <- subset(all_significant,all_significant$difference > 0)

png(filename="no_differences.png")
ggplot(data=same, mapping=aes(x=dS, y=dNdS)) +
  geom_point(color="black",alpha=0.1)+
  ylim(0,3)+
  labs(title="Distribution of dN/dS values amongst synonymous change",x="dS for alignment",y="dN/dS for alignment")
dev.off()

png(filename="nonannual_faster.png")
ggplot(data=nonannual, mapping=aes(x=dS, y=background)) +
  geom_point(color="black",alpha=0.1)+
  geom_point(data=nonannual, aes(x=dS, y=foreground), color='red', alpha=0.1)+
  xlim(0,12)+
  ylim(0,3)+
  labs(title="dN/dS vs synonymous change when nonannual sig. faster than annual",x="dS for alignment",y="dN/dS for alignment")
dev.off()

png(filename="annual_faster.png")
ggplot(data=annual, mapping=aes(x=dS, y=background)) +
  geom_point(color="black",alpha=0.1)+
  geom_point(data=nonannual, aes(x=dS, y=foreground), color='red', alpha=0.1)+
  xlim(0,12)+
  ylim(0,3)+
  labs(title="dN/dS vs synonymous change when annual sig. faster than nonannual",x="dS for alignment",y="dN/dS for alignment")
dev.off()

png(filename="one.ratio.distribution.png")
ggplot(data = oneratio, mapping = aes(x=dNdS, y=dS)) + 
  geom_point(color="black",alpha=0.1)+
  xlim(0,3)+
  ylim(0,15)+
  labs(title="Distribution of synonymous change",x="dN/dS for alignment",y="synonymous change")
dev.off()

png(filename="one.ratio.distribution.highlight.png")
ggplot(data = oneratio, mapping = aes(x=dNdS, y=dS)) + 
  geom_point(color="black",alpha=0.1)+
  geom_point(data=tworatio, aes(x=dNdS, y=dS),color='red', alpha=0.1) +
  xlim(0,3)+
  ylim(0,15)+
  labs(title="Distribution of synonymous change",x="dN/dS for alignment",y="synonymous change")
dev.off()

png(filename="background.distribution.png")
ggplot(data = background, mapping = aes(x=dNdS, y=dS)) + 
  geom_point(color="black",alpha=0.1)+
  xlim(0,3)+
  ylim(0,15)+
  labs(title="Distribution of synonymous changes in annual vs nonannual",caption="Groups with a significantly different omega value between annual and \n nonannual lineages. Nonannual lineages are in grey \n and annual lineages are in blue.",x="dN/dS for group",y="synonymous change")
dev.off()

png(filename="foreground.distribution.png")
ggplot(data = background, mapping = aes(x=dNdS, y=dS)) + 
  geom_point(color="black",alpha=0.1)+
  geom_point(data=foreground, aes(x=dNdS, y=dS),color='blue',alpha=0.1) +
  xlim(0,3)+
  ylim(0,15)+
  labs(title="Distribution of synonymous changes in annual vs nonannual",caption="Groups with a significantly different omega value between annual and \n nonannual lineages. Nonannual lineages are in grey \n and annual lineages are in blue.",x="dN/dS for group",y="synonymous change")
dev.off()

mycolors <- c("grey","red")
names(mycolors) <- c("NO","YES")

png(filename="dSbyomega.png")
ggplot(data = killifish, mapping = aes(x=dNdS1, y=dS)) + 
  geom_point(color="black",alpha=0.1)+
  labs(title="Synonymous changes vs Omega",x="Omega",y="Synonymous change")
dev.off()

png(filename="dSbyomega_highlight.png")
ggplot(data = killifish, mapping = aes(x=dNdS1, y=dS)) + 
  geom_point(color="black",alpha=0.1)+
  geom_point(data=significant, aes(x=dNdS1, y=dS),color='red', alpha=0.4) +
  labs(title="Synonymous changes (dS) vs Omega",caption="Groups with a significantly different omega value between annual and \n nonannual lineages are highlighted in red",x="Omega",y="Synonymous change")
dev.off()

png(filename="dSbyomega_highlight_different.png")
ggplot(data = killifish, mapping = aes(x=dS, y1=dNdS1, y2=dNdS2)) + 
  geom_point(color="black",alpha=0.1)+
  geom_point(data=significant, aes(x=dS, y1=dNdS1, y2=dNdS2),color='red', alpha=0.4) +
  labs(title="Synonymous changes (dS) vs Omega",caption="Groups with a significantly different omega value between annual and \n nonannual lineages are highlighted in red",x="Omega",y="Synonymous change")
dev.off()



killifish <- all_killifish[!(all_killifish$dNdS1 >=3),]
killifish <- killifish[!(killifish$dNdS2 >=3),]
killifish <- killifish[!(killifish$dS >= 60),]
significant <- subset(killifish,killifish$likelihood.ratio>=3.84)
