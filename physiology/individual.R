library(dplyr)
library(ggpubr)
library(ggplot2)
library(tidyverse)
library(broom)
library(AICcmodavg)
library(desplot)
library(haven)
library(doBy)
library(sciplot)
library(lme4)
library(moments)

## load the data
setwd("C:/Users/Amanda/OneDrive - Mississippi State University/Dissertation")
d2015 <- read.delim("2015IndividualData.csv", header=TRUE,sep=",")
d2017 <- read.delim("2017IndividualData.csv", header=TRUE,sep=",")
tank_d2015 <- read.delim("2015TankData.csv", header=TRUE,sep=",")
tank_d2017 <- read.delim("2017TankData.csv", header=TRUE,sep=",")

## label factor levels
levels(d2015$salinity) = c("freshwater","saltwater")
levels(d2017$salinity) = c("freshwater","saltwater")
levels(d2015$oxygen) = c("normoxia","hypoxia")
levels(d2017$oxygen) = c("normoxia","hypoxia")
levels(tank_d2015$treatment_salinity) = c("F","B")
levels(tank_d2015$treatment_oxygen) = c("N","H")


## tell R that predictors are FACTORS
d2015$oxygen <- as.factor(d2015$oxygen)
d2017$oxygen <- as.factor(d2017$oxygen)
d2015$salinity <- as.factor(d2015$salinity)
d2017$salinity <- as.factor(d2017$salinity)
tank_d2015$treatment_oxygen <- as.factor(tank_d2015$treatment_oxygen)
tank_d2015$treatment_salinity <- as.factor(tank_d2015$treatment_salinity)

## remove the empty water quality data.
tank_d2015 <- na.omit(tank_d2015)
tank_d2017 <- na.omit(tank_d2017)

## get descriptives, separated by groups
require(stats)

tapply(d2015$weight, list(d2015$oxygen, d2015$salinity), mean)
options(digits=4)
summaryBy(weight ~ oxygen + salinity, data=d2015, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

tapply(d2015$hemoglobin, list(d2015$oxygen, d2015$salinity), mean)
options(digits=4)
summaryBy(hemoglobin ~ oxygen + salinity, data=d2015, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

tapply(d2017$hemoglobin, list(d2017$oxygen, d2017$salinity), mean)
options(digits=4)
summaryBy(hemoglobin ~ oxygen + salinity, data=d2017, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

tapply(d2015$hematocrit, list(d2015$oxygen, d2015$salinity), mean)
options(digits=4)
summaryBy(hematocrit ~ oxygen + salinity, data=d2015, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

tapply(d2017$hematocrit, list(d2017$oxygen, d2017$salinity), mean)
options(digits=4)
summaryBy(hematocrit ~ oxygen + salinity, data=d2017, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

tapply(d2015$ph, list(d2015$oxygen, d2015$salinity), mean)
options(digits=4)
summaryBy(ph ~ oxygen + salinity, data=d2015, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

tapply(d2017$phv, list(d2017$oxygen, d2017$salinity), mean)
options(digits=4)
summaryBy(phv ~ oxygen + salinity, data=d2017, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

tapply(d2017$pha, list(d2017$oxygen, d2017$salinity), mean)
options(digits=4)
summaryBy(pha ~ oxygen + salinity, data=d2017, FUN=c(length, mean, se), fun.names=c("n","mean","se"))


tapply(d2017$hemoglobin, d0217, mean)
options(digits=4)
summaryBy(hemoglobin ~ oxygen + salinity, data=d2017, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

## one-way side by sides
blank <- ggplot(data=d2015, aes(x=salinity, y=hemoglobin))
blank2 <- blank + labs(title="line1\nline2")
points <- blank2 + geom_point()
pointsbox <- points + geom_boxplot(aes(color=salinity))

## Graph Main Effects
plot.design(hemoglobin ~ oxygen*salinityy, data=d2015, main="Main Effects Plot")
## and interaction
lineplot.CI(x.factor=oxygen, response=hemoglobin, group=salinity, data=d2015, xlab="Oxygen", ylab="Mean [Hb] (mg/dL)", main="Interaction Plot")
# fit2 way anova
fit <- aov(hemoglobin ~ oxygen*salinity, data=d2015)
fit <- aov(hemoglobin ~ oxygen + salinity + oxygen*salinity, data=d2015)

anova(fit)
summary(fit)

## test for normality (b/w -0.5 and 0.5, symmetrical)
## sqrt(x) for moderate (b/w .05 and 1 or b/w -1 and -0.5)
## log for greater skew (< -1 or > 1)
## inverse for severe skew
shapiro.test(d2015$weight)
skewness(d2015$weight, na.rm=TRUE)
shapiro.test(d2015$length)
skewness(d2015$length,na.rm=TRUE)
shapiro.test(d2015$hematocrit)
skewness(d2015$hematocrit,na.rm=TRUE)
shapiro.test(d2015$hemoglobin)
skewness(d2015$hemoglobin,na.rm=TRUE)
shapiro.test(d2015$pH)
skewness(d2015$pH,na.rm=TRUE)
shapiro.test(d2015$protein)
skewness(d2015$protein,na.rm=TRUE)
shapiro.test(d2015$cortisol)
skewness(d2015$cortisol,na.rm=TRUE)
shapiro.test(d2015$lactate)
skewness(d2015$lactate,na.rm=TRUE)
shapiro.test(d2015$glucose)
skewness(d2015$glucose,na.rm=TRUE)
shapiro.test(d2015$osmolality)
skewness(d2015$osmolality,na.rm=TRUE)

## anova on normal data
one.way <- aov(hemoglobin ~ salinity, data =d2015)
other.way <- aov(hemoglobin ~ oxygen, data = d2015)
two.way <- aov(hemoglobin ~ oxygen + salinity, data = d2015)
interaction <-aov(hemoglobin ~ oxygen*salinity, data=d2015)

model.set <- list(one.way,other.way,two.way,interaction)
model.names <- c("one.way","other.way","two.way","interaction")
aictab(model.set,modnames=model.names)

summary(one.way)
?aov

## post hoc test

tukey.one.way<-TukeyHSD(one.way)
tukey.one.way
tukey.plot.aov<-aov(hemoglobin ~ oxygen:salinity, data=d2015)
tukey.plot.test<-TukeyHSD(tukey.plot.aov)
plot(tukey.plot.test, las =1)

mean.hemoglobin.d2015 <- d2015 %>%
  group_by(oxygen, salinity) %>%
  summarise(
    hemoglobin = mean(hemoglobin)
  )

## add group labels
mean.hemoglobin.d2015$group <- c("a","b","b","c")
mean.hemoglobin.d2015

## plot raw data
one.way.plot <- ggplot(d2015, aes(x = salinity, y = hemoglobin)) + geom_point(cex = 1.5, pch = 1.0, position = position_jitter(w = 0.1, h=0))
## add means and standard errors
one.way.plot <- one.way.plot + stat_summary(fun.data = 'mean_se', geom = 'errorbar', width = 0.2) + stat_summary(fun.data = 'mean_se', geom = 'pointrange') + geom_point(data=mean.hemoglobin.data, aes(x=salinity,y=hemoglobin))
## split up the data
one.way.plot <- one.way.plot + geom_text(data=mean.hemoglobin.d2015, label=mean.hemoglobin.d2015$group, vjust = -8, size = 5) + facet_wrap(~ oxygen)
## clean up
one.way.plot <- one.way.plot + theme_classic2() + labs(title= "Hemoglobin concentration in response to oxygen and salinity treatments", x = "Salinity Type", y = "Hemoglobin (mg/dL)")
one.way.plot

### try to incorporate subsampling. aggregate the data.
d2015.agg = d2015 %>% group_by(oxygen,salinity,tank) %>% summarize(inverseprotein = mean(inverseprotein))
d2015.agg
boxplot(hemoglobin ~ oxygen:salinity, d2015.agg)

png(filename="physiology_figures\\2015protein.png")
ggplot(d2015.agg, aes(y=inverseprotein,x=oxygen:salinity)) + geom_boxplot() + labs(x=expression(treatment),y=expression("[total protein]"~microgram/mL^-1))
dev.off()

## i think this works?????
levels(d2015.agg$salinity) = c("freshwater","saltwater")
levels(d2015.agg$oxygen) = c("normoxia","hypoxia")
d2015.agg$oxygen <- as.factor(d2015.agg$oxygen)
d2015.agg$salinity <- as.factor(d2015.agg$salinity)
boxplot(hemoglobin ~ oxygen+salinity, d2015.agg)
fit <- aov(hemoglobin ~ oxygen+salinity+oxygen*salinity, data=d2015.agg)
anova(fit)

## 4/20/2022 Practice
d2015$oxygen <- factor(d2015$oxygen, levels = c("hypoxia","normoxia"), ordered = TRUE)
d2015$salinity <- factor(d2015$salinity, levels = c("freshwater","brackishwater"), ordered = TRUE)

Hb<-aov(hemoglobin ~ oxygen*salinity + Error(tank), data = d2015)
one.way<-aov(hemoglobin ~ treatment + Error(tank), data=d2015)
two.way<-aov(hemoglobin ~ oxygen*salinity + Error(tank), data=d2015)
summary(Hb)

hct <- aov(hematocrit ~ oxygen*salinity + Error(tank), data=d2015)
summary(aov(hematocrit ~ treatment + Error(tank), data=d2015))
summary(aov(hematocrit ~ oxygen*salinity + Error(tank), data=d2015))
summary(hct)

pH<-aov(pH ~ oxygen*salinity + Error(tank), data= data)
summary(pH)

cortisol<- aov(cortisol ~ oxygen*salinity + Error(tank), data=data)
summary(cortisol)

lactate <- aov(inverselactate ~ oxygen*salinity + Error(tank), data=d2015)
summary(aov(inverselactate ~ oxygen*salinity + Error(tank), data=d2015))
summary(aov(inverselactate ~ treatment + Error(tank), data=d2015))

glucose<- aov(glucose ~ oxygen*salinity + Error(tank), data=data)
summary(aov(glucose ~ oxygen*salinity + Error(tank), data=d2015))
summary(aov(glucose ~ treatment + Error(tank), data=d2015))
summary(glucose)

osmolality <- aov(osmolality ~ oxygen*salinity + Error(tank), data=d2015)
summary(aov(osmolality ~ oxygen*salinity + Error(tank), data=d2015))
summary(aov(osmolality ~ treatment + Error(tank), data=d2015))

summary(aov(inverseprotein ~ oxygen*salinity + Error(tank), data=d2015))
summary(aov(inverseprotein ~ treatment + Error(tank), data=d2015))


## idk what I'm doing here, testing if weight and length are skewed somehow?

weight<- aov(weight ~ oxygen*salinity + Error(tank), data=data)
summary(weight)

length <- aov(length ~ oxygen*salinity + Error(tank), data=data)
summary(length)

## NEXT STEPS
## MISSING DATA

## NOT NORMAL DATA

## Working through run2 initially
shapiro.test(d2017$weight)
skewness(d2017$weight)
shapiro.test(d2017$length)
skewness(d2017$length)
shapiro.test(d2017$hematocrit)
skewness(d2017$hematocrit)
shapiro.test(d2017$hemoglobin)
skewness(d2017$hemoglobin)
shapiro.test(d2017$phv)
skewness(d2017$phv)
shapiro.test(d2017$pha)
skewness(d2017$pha)
shapiro.test(d2017$po2v)
skewness(d2017$po2v)
shapiro.test(d2017$po2a)
skewness(d2017$po2a)
shapiro.test(d2017$glucose)
skewness(d2017$glucose)
shapiro.test(d2017$osmolality)
skewness(d2017$osmolality)
shapiro.test(d2017$rbc)
skewness(d2017$rbc)
shapiro.test(d2017$mcv)
skewness(d2017$mcv)
shapiro.test(d2017$mch)
skewness(d2017$mch)
shapiro.test(d2017$mchc)
skewness(d2017$mchc)

## if normal, do Bartlett
#bartlett.test(response ~ treatment, data=data)

## if not normal, do levene
#leveneTest(response ~ treatment, data=data)

## check for outliers
#grubbs.test(data$response, type = 10)
#grubbs.test(data$response, type = 10, opposite=TRUE)
#grubbs.test(data$response, type = 11)

hb2017 <- aov(hemoglobin ~ oxygen*salinity + Error(tank), data=d2017)
summary(aov(hemoglobin ~ oxygen*salinity + Error(tank),data=d2017))
summary(aov(hemoglobin ~ treatment + Error(tank), data=d2017))
summary(hb2017)

summary(aov(hematocrit ~ oxygen*salinity + Error(tank), data=d2017))
summary(aov(hematocrit ~ treatment + Error(tank), data=d2017))

pha2017 <- aov(pHa ~ oxygen*salinity + Error(tank), data=d2017)
summary(pha2017)

phv2017 <- aov(pHv ~ oxygen*salinity + Error(tank), data=d2017)
summary(phv2017)

glucose2017 <- aov(glucose ~ oxygen*salinity + Error(tank), data=d2017)
summary(glucose2017)

d2017.agg = d2017 %>% group_by(oxygen,salinity,tank) %>% summarize(hematocrit = mean(hematocrit))


png(filename="physiology_figures\\2017hematocrit.png")
ggplot(d2017.agg, aes(y=hematocrit,x=oxygen:salinity)) + geom_boxplot() + labs(x=expression(treatment),y=expression("hematocrit %"))
dev.off()

## Missing data
## Calculate how much missing data weighs each variable.
p <- function (x) {sum(is.na(x))/length(x)*100}
apply (data,2,p)
