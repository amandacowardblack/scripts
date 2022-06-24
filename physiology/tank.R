library(tidyverse)
library(doBy)
library(dplyr)
library(sciplot)
require(stats)

setwd("C:/Users/amanda/OneDrive - Mississippi State University/Dissertation")

tank_d2015_2week <- read.delim("2015TankData_2week.csv", header=TRUE,sep=",")
tank_d2017_2week <- read.delim("2017TankData_2week.csv", header=TRUE,sep=",")

'''
tank_d2015 <- read.delim("2015TankData.csv", header=TRUE,sep=",")
tank_d2017 <- read.delim("2017TankData.csv", header=TRUE,sep=",")

levels(tank_d2015$treatment_salinity) = c("F","B")
levels(tank_d2015$treatment_oxygen) = c("H","N")
levels(tank_d2015$time) = c("AM","PM")
tank_d2015$treatment_oxygen <- as.factor(tank_d2015$treatment_oxygen)
tank_d2015$treatment_salinity <- as.factor(tank_d2015$treatment_salinity)
tank_d2015$time <- as.factor(tank_d2015$time)

tank_d2015_omitNA <- na.omit(tank_d2015)
levels(tank_d2015_omitNA$treatment_salinity) = c("B","F")
levels(tank_d2015_omitNA$treatment_oxygen) = c("H","N")
levels(tank_d2015_omitNA$time) = c("AM","PM")
tank_d2015_omitNA$treatment_oxygen <- as.factor(tank_d2015_omitNA$treatment_oxygen)
tank_d2015_omitNA$treatment_salinity <- as.factor(tank_d2015_omitNA$treatment_salinity)
tank_d2015_omitNA$time <- as.factor(tank_d2015_omitNA$time)

tapply(tank_d2015_omitNA$oxygen_dissolved, tank_d2015_omitNA$original_tank, mean)
options(digits=4)
summaryBy(oxygen_dissolved ~ treatment_oxygen + treatment_salinity, data=tank_d2015_omitNA, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

tapply(tank_d2015_omitNA$temp, tank_d2015_omitNA$original_tank, mean)
options(digits=4)
summaryBy(temp ~ treatment_oxygen + treatment_salinity, data=tank_d2015_omitNA, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

tapply(tank_d2015_omitNA$salinity, tank_d2015_omitNA$original_tank, mean)
options(digits=4)
summaryBy(salinity ~ treatment_oxygen + treatment_salinity, data=tank_d2015_omitNA, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

tank_d2017_omitNA <- na.omit(tank_d2017)
levels(tank_d2017_omitNA$treatment_salinity) = c("B","F")
levels(tank_d2017_omitNA$treatment_oxygen) = c("H","N")
levels(tank_d2017_omitNA$time) = c("AM","PM")
tank_d2017_omitNA$treatment_oxygen <- as.factor(tank_d2017_omitNA$treatment_oxygen)
tank_d2017_omitNA$treatment_salinity <- as.factor(tank_d2017_omitNA$treatment_salinity)
tank_d2017_omitNA$time <- as.factor(tank_d2017_omitNA$time)

tapply(tank_d2017_omitNA$oxygen_dissolved, tank_d2017_omitNA$original_tank, mean)
options(digits=4)
summaryBy(oxygen_dissolved ~ treatment_oxygen + treatment_salinity, data=tank_d2017_omitNA, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

tapply(tank_d2017_omitNA$temp, tank_d2017_omitNA$original_tank, mean)
options(digits=4)
summaryBy(temp ~ treatment_oxygen + treatment_salinity, data=tank_d2017_omitNA, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

tapply(tank_d2017_omitNA$salinity, tank_d2017_omitNA$original_tank, mean)
options(digits=4)
summaryBy(salinity ~ treatment_oxygen + treatment_salinity, data=tank_d2017_omitNA, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
'''
## The above was all for the entirety of the experiment, including acclimation periods.
## The below is specifically for the 2-week exposure period of the experiment.

### Reading In and Factoring Data
## Year One Water Quality
tank_d2015_2week_omitNA <- na.omit(tank_d2015_2week)
levels(tank_d2015_2week_omitNA$treatment_salinity) = c("B","F")
levels(tank_d2015_2week_omitNA$treatment_oxygen) = c("H","N")
levels(tank_d2015_2week_omitNA$time) = c("AM","PM")
levels(tank_d2015_2week_omitNA$treatment) = c("NF","NB","HF","HB")
tank_d2015_2week_omitNA$treatment_oxygen <- as.factor(tank_d2015_2week_omitNA$treatment_oxygen)
tank_d2015_2week_omitNA$treatment_salinity <- as.factor(tank_d2015_2week_omitNA$treatment_salinity)
tank_d2015_2week_omitNA$time <- as.factor(tank_d2015_2week_omitNA$time)
tank_d2015_2week_omitNA$treatment <- as.factor(tank_d2015_2week_omitNA$treatment)

## Year One Size
d2015_sizein <- read.delim("2015sizein.csv",header=TRUE,sep=",")
d2015_sizeout <- read.delim("2015sizeout.csv",header=TRUE,sep=",")
levels(d2015_sizein$treatment) = c("nfw","nbw","hfw","hbw")
levels(d2015_sizein$oxygen) = c("H","N")
levels(d2015_sizein$salinity) = c("F","B")
levels(d2015_sizeout$treatment) = c("nfw","nbw","hfw","hbw")
levels(d2015_sizeout$oxygen) = c("H","N")
levels(d2015_sizeout$salinity) = c("F","B")
d2015_sizein$treatment <- as.factor(d2015_sizein$treatment)
d2015_sizein$oxygen <- as.factor(d2015_sizein$oxygen)
d2015_sizein$salinity <- as.factor(d2015_sizein$salinity)
d2015_sizeout$treatment <- as.factor(d2015_sizeout$treatment)
d2015_sizeout$oxygen <- as.factor(d2015_sizeout$oxygen)
d2015_sizeout$salinity <- as.factor(d2015_sizeout$salinity)

d2015_sizein_weight_bytank <- summaryBy(weight.in ~ original_tank + treatment, data=d2015_sizein, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
d2015_sizeout_weight_bytank <- summaryBy(weight.out ~ original_tank + treatment, data=d2015_sizeout, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
d2015_sizein_length_bytank <- summaryBy(length.in ~ original_tank + treatment, data=d2015_sizein, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
d2015_sizeout_length_bytank <- summaryBy(length.out ~ original_tank + treatment, data=d2015_sizeout, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

d2015_diff_bytank <- merge(d2015_sizein_weight_bytank, d2015_sizeout_weight_bytank, by=c("original_tank","treatment"))
d2015_diff_bytank <- merge(d2015_diff_bytank, d2015_sizein_length_bytank, by=c("original_tank","treatment"))
d2015_diff_bytank <- merge(d2015_diff_bytank, d2015_sizeout_length_bytank, by=c("original_tank","treatment"))
d2015_diff_bytank <- mutate(d2015_diff_bytank, weight.diff = weight.out.mean - weight.in.mean)
d2015_diff_bytank <- mutate(d2015_diff_bytank, length.diff = length.out.mean - length.in.mean)
d2015_diff_bytank <- d2015_diff_bytank[c("treatment","weight.in.mean","weight.out.mean","weight.diff","length.in.mean","length.out.mean","length.diff")]

## Year Two Water Quality
tank_d2017_2week_omitNA <- na.omit(tank_d2017_2week)
levels(tank_d2017_2week_omitNA$treatment_salinity) = c("B","F")
levels(tank_d2017_2week_omitNA$treatment_oxygen) = c("H","N")
levels(tank_d2017_2week_omitNA$time) = c("AM","PM")
levels(tank_d2017_2week_omitNA$treatment) = c("NF","NB","HF","HB")
tank_d2017_2week_omitNA$treatment_oxygen <- as.factor(tank_d2017_2week_omitNA$treatment_oxygen)
tank_d2017_2week_omitNA$treatment_salinity <- as.factor(tank_d2017_2week_omitNA$treatment_salinity)
tank_d2017_2week_omitNA$time <- as.factor(tank_d2017_2week_omitNA$time)
tank_d2017_2week_omitNA$treatment <- as.factor(tank_d2017_2week_omitNA$treatment)

## Year Two Size
d2017_sizein <- read.delim("2017sizein.csv",header=TRUE,sep=",")
d2017_sizeout <- read.delim("2017sizeout.csv",header=TRUE,sep=",")
levels(d2017_sizein$treatment) = c("nfw","nbw","hfw","hbw")
levels(d2017_sizein$oxygen) = c("H","N")
levels(d2017_sizein$salinity) = c("F","B")
levels(d2017_sizeout$treatment) = c("nfw","nbw","hfw","hbw")
levels(d2017_sizeout$oxygen) = c("H","N")
levels(d2017_sizeout$salinity) = c("F","B")
d2017_sizein$treatment <- as.factor(d2017_sizein$treatment)
d2017_sizein$oxygen <- as.factor(d2017_sizein$oxygen)
d2017_sizein$salinity <- as.factor(d2017_sizein$salinity)
d2017_sizeout$treatment <- as.factor(d2017_sizeout$treatment)
d2017_sizeout$oxygen <- as.factor(d2017_sizeout$oxygen)
d2017_sizeout$salinity <- as.factor(d2017_sizeout$salinity)

d2017_sizein_weight_bytank <- summaryBy(weight.in ~ tank + treatment, data=d2017_sizein, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
d2017_sizeout_weight_bytank <- summaryBy(weight.out ~ tank + treatment, data=d2017_sizeout, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
d2017_sizein_length_bytank <- summaryBy(length.in ~ tank + treatment, data=d2017_sizein, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
d2017_sizeout_length_bytank <- summaryBy(length.out ~ tank + treatment, data=d2017_sizeout, FUN=c(length, mean, se), fun.names=c("n","mean","se"))

d2017_diff_bytank <- merge(d2017_sizein_weight_bytank, d2017_sizeout_weight_bytank, by=c("tank","treatment"))
d2017_diff_bytank <- merge(d2017_diff_bytank, d2017_sizein_length_bytank, by=c("tank","treatment"))
d2017_diff_bytank <- merge(d2017_diff_bytank, d2017_sizeout_length_bytank, by=c("tank","treatment"))
d2017_diff_bytank <- mutate(d2017_diff_bytank, weight.diff = weight.out.mean - weight.in.mean)
d2017_diff_bytank <- mutate(d2017_diff_bytank, length.diff = length.out.mean - length.in.mean)
d2017_diff_bytank <- d2017_diff_bytank[c("treatment","weight.in.mean","weight.out.mean","weight.diff","length.in.mean","length.out.mean","length.diff")]


### Normality, Variance, and Outlier Testing
library(moments)
library(car)
library(outliers)

### if normal, do Bartlett
##bartlett.test(response ~ treatment, data=data)
### if not normal, do levene
##leveneTest(response ~ treatment, data=data)
### check for outliers (first is one end, second is other end, and last is both ends)
##grubbs.test(dataA$response, type = 10)
##grubbs.test(data$response, type = 10, opposite=TRUE)
##grubbs.test(data$response, type = 11)

## Year One Water Quality
# salinity
shapiro.test(tank_d2015_2week_omitNA$salinity)
skewness(tank_d2015_2week_omitNA$salinity)
leveneTest(salinity ~ treatment, data=tank_d2015_2week_omitNA)
grubbs.test(tank_d2015_2week_omitNA$salinity, type = 10)
grubbs.test(tank_d2015_2week_omitNA$salinity, type = 10, opposite=TRUE)
grubbs.test(tank_d2015_2week_omitNA$salinity, type = 11)

# dissolved oxygen
shapiro.test(tank_d2015_2week_omitNA$oxygen_dissolved)
skewness(tank_d2015_2week_omitNA$oxygen_dissolved)
leveneTest(oxygen_dissolved ~ treatment, data=tank_d2015_2week_omitNA)
grubbs.test(tank_d2015_2week_omitNA$oxygen_dissolved, type = 10)
grubbs.test(tank_d2015_2week_omitNA$oxygen_dissolved, type = 10, opposite=TRUE)
grubbs.test(tank_d2015_2week_omitNA$oxygen_dissolved, type = 11)

# temperature
shapiro.test(tank_d2015_2week_omitNA$temp)
skewness(tank_d2015_2week_omitNA$temp)
leveneTest(temp ~ treatment, data=tank_d2015_2week_omitNA)
grubbs.test(tank_d2015_2week_omitNA$temp, type = 10)
grubbs.test(tank_d2015_2week_omitNA$temp, type = 10, opposite=TRUE)
grubbs.test(tank_d2015_2week_omitNA$temp, type = 11)

##  Year One Size
# weight.in 
shapiro.test(d2015_sizein$weight.in)
skewness(d2015_sizein$weight.in)
bartlett.test(weight.in ~ original_tank, data=d2015_sizein)
bartlett.test(weight.in ~ treatment, data=d2015_sizein)
grubbs.test(d2015_sizein$weight.in, type = 10)
grubbs.test(d2015_sizein$weight.in, type = 10, opposite=TRUE)
grubbs.test(d2015_sizein$weight.in, type = 11)

# weight.in.mean
shapiro.test(d2015_diff_bytank$weight.in.mean)
skewness(d2015_diff_bytank$weight.in.mean)
bartlett.test(weight.in.mean ~ treatment, data=d2015_diff_bytank)
grubbs.test(d2015_diff_bytank$weight.in.mean, type = 10)
grubbs.test(d2015_diff_bytank$weight.in.mean, type = 10, opposite=TRUE)
grubbs.test(d2015_diff_bytank$weight.in.mean, type = 11)

# length.in
shapiro.test(d2015_sizein$length.in)
skewness(d2015_sizein$length.in)
bartlett.test(length.in ~ original_tank, data=d2015_sizein)
bartlett.test(length.in ~ treatment, data=d2015_sizein)
grubbs.test(d2015_sizein$length.in, type = 10)
grubbs.test(d2015_sizein$length.in, type = 10, opposite=TRUE)
grubbs.test(d2015_sizein$length.in, type = 11)

# length.in.mean
shapiro.test(d2015_diff_bytank$length.in.mean)
skewness(d2015_diff_bytank$length.in.mean)
bartlett.test(length.in.mean ~ treatment, data=d2015_diff_bytank)
grubbs.test(d2015_diff_bytank$length.in.mean, type = 10)
grubbs.test(d2015_diff_bytank$length.in.mean, type = 10, opposite=TRUE)
grubbs.test(d2015_diff_bytank$length.in.mean, type = 11)

# weight.out
shapiro.test(d2015_sizeout$weight.out)
skewness(d2015_sizeout$weight.out)
bartlett.test(weight.out ~ original_tank, data=d2015_sizeout)
bartlett.test(weight.out ~ treatment, data=d2015_sizeout)
grubbs.test(d2015_sizeout$weight.out, type = 10)
grubbs.test(d2015_sizeout$weight.out, type = 10, opposite=TRUE)
grubbs.test(d2015_sizeout$weight.out, type = 11)

# weight.out.mean
shapiro.test(d2015_diff_bytank$weight.out.mean)
skewness(d2015_diff_bytank$weight.out.mean)
bartlett.test(weight.out.mean ~ treatment, data=d2015_diff_bytank)
grubbs.test(d2015_diff_bytank$weight.out.mean, type = 10)
grubbs.test(d2015_diff_bytank$weight.out.mean, type = 10, opposite=TRUE)
grubbs.test(d2015_diff_bytank$weight.out.mean, type = 11)

# length.out
shapiro.test(d2015_sizeout$length.out)
skewness(d2015_sizeout$length.out)
bartlett.test(length.out ~ original_tank, data=d2015_sizeout)
bartlett.test(length.out ~ treatment, data=d2015_sizeout)
grubbs.test(d2015_sizeout$length.out, type = 10)
grubbs.test(d2015_sizeout$length.out, type = 10, opposite=TRUE)
grubbs.test(d2015_sizeout$length.out, type = 11)

# length.out.mean
shapiro.test(d2015_diff_bytank$length.out.mean)
skewness(d2015_diff_bytank$length.out.mean)
bartlett.test(length.out.mean ~ treatment, data=d2015_diff_bytank)
grubbs.test(d2015_diff_bytank$length.out.mean, type = 10)
grubbs.test(d2015_diff_bytank$length.out.mean, type = 10, opposite=TRUE)
grubbs.test(d2015_diff_bytank$length.out.mean, type = 11)

## Year Two Water Quality
# salinity
shapiro.test(tank_d2017_2week_omitNA$salinity)
skewness(tank_d2017_2week_omitNA$salinity)
leveneTest(salinity ~ treatment, data=tank_d2017_2week_omitNA)
grubbs.test(tank_d2017_2week_omitNA$salinity, type = 10)
grubbs.test(tank_d2017_2week_omitNA$salinity, type = 10, opposite=TRUE)
grubbs.test(tank_d2017_2week_omitNA$salinity, type = 11)

# dissolved oxygen
shapiro.test(tank_d2017_2week_omitNA$oxygen_dissolved)
skewness(tank_d2017_2week_omitNA$oxygen_dissolved)
leveneTest(oxygen_dissolved ~ treatment, data=tank_d2017_2week_omitNA)
grubbs.test(tank_d2017_2week_omitNA$oxygen_dissolved, type = 10)
grubbs.test(tank_d2017_2week_omitNA$oxygen_dissolved, type = 10, opposite=TRUE)
grubbs.test(tank_d2017_2week_omitNA$oxygen_dissolved, type = 11)

# temperature
shapiro.test(tank_d2017_2week_omitNA$temp)
skewness(tank_d2017_2week_omitNA$temp)
leveneTest(temp ~ treatment, data=tank_d2017_2week_omitNA)
grubbs.test(tank_d2017_2week_omitNA$temp, type = 10)
grubbs.test(tank_d2017_2week_omitNA$temp, type = 10, opposite=TRUE)
grubbs.test(tank_d2017_2week_omitNA$temp, type = 11)

##  Year Two Size
# weight.in
shapiro.test(d2017_sizein$weight.in)
skewness(d2017_sizein$weight.in)
bartlett.test(weight.in ~ tank, data=d2017_sizein)
bartlett.test(weight.in ~ treatment, data=d2017_sizein)
grubbs.test(d2017_sizein$weight.in, type = 10)
grubbs.test(d2017_sizein$weight.in, type = 10, opposite=TRUE)
grubbs.test(d2017_sizein$weight.in, type = 11)

# weight.in.mean
shapiro.test(d2017_diff_bytank$weight.in.mean)
skewness(d2017_diff_bytank$weight.in.mean)
bartlett.test(weight.in.mean ~ treatment, data=d2017_diff_bytank)
grubbs.test(d2017_diff_bytank$weight.in.mean, type = 10)
grubbs.test(d2017_diff_bytank$weight.in.mean, type = 10, opposite=TRUE)
grubbs.test(d2017_diff_bytank$weight.in.mean, type = 11)

# length.in
shapiro.test(d2017_sizein$length.in)
skewness(d2017_sizein$length.in)
bartlett.test(length.in ~ tank, data=d2017_sizein)
bartlett.test(length.in ~ treatment, data=d2017_sizein)
grubbs.test(d2017_sizein$length.in, type = 10)
grubbs.test(d2017_sizein$length.in, type = 10, opposite=TRUE)
grubbs.test(d2017_sizein$length.in, type = 11)

# length.in.mean
shapiro.test(d2017_diff_bytank$length.in.mean)
skewness(d2017_diff_bytank$length.in.mean)
bartlett.test(length.in.mean ~ treatment, data=d2017_diff_bytank)
grubbs.test(d2017_diff_bytank$length.in.mean, type = 10)
grubbs.test(d2017_diff_bytank$length.in.mean, type = 10, opposite=TRUE)
grubbs.test(d2017_diff_bytank$length.in.mean, type = 11)

# weight.out
shapiro.test(d2017_sizeout$weight.out)
skewness(d2017_sizeout$weight.out)
bartlett.test(weight.out ~ tank, data=d2017_sizeout)
bartlett.test(weight.out ~ treatment, data=d2017_sizeout)
grubbs.test(d2017_sizeout$weight.out, type = 10)
grubbs.test(d2017_sizeout$weight.out, type = 10, opposite=TRUE)
grubbs.test(d2017_sizeout$weight.out, type = 11)

# weight.out.mean
shapiro.test(d2017_diff_bytank$weight.out.mean)
skewness(d2017_diff_bytank$weight.out.mean)
bartlett.test(weight.out.mean ~ treatment, data=d2017_diff_bytank)
grubbs.test(d2017_diff_bytank$weight.out.mean, type = 10)
grubbs.test(d2017_diff_bytank$weight.out.mean, type = 10, opposite=TRUE)
grubbs.test(d2017_diff_bytank$weight.out.mean, type = 11)

# length.out
shapiro.test(d2017_sizeout$length.out)
skewness(d2017_sizeout$length.out)
bartlett.test(length.out ~ tank, data=d2017_sizeout)
bartlett.test(length.out ~ treatment, data=d2017_sizeout)
grubbs.test(d2017_sizeout$length.out, type = 10)
grubbs.test(d2017_sizeout$length.out, type = 10, opposite=TRUE)
grubbs.test(d2017_sizeout$length.out, type = 11)

# length.out.mean
shapiro.test(d2017_diff_bytank$length.out.mean)
skewness(d2017_diff_bytank$length.out.mean)
bartlett.test(length.out.mean ~ treatment, data=d2017_diff_bytank)
grubbs.test(d2017_diff_bytank$length.out.mean, type = 10)
grubbs.test(d2017_diff_bytank$length.out.mean, type = 10, opposite=TRUE)
grubbs.test(d2017_diff_bytank$length.out.mean, type = 11)

### mean +- standard error and groupings if significantly different
library(broom)
library(ggplot2)
library(multcomp)

## Year One Water Quality
# dissolved oxygen
tapply(tank_d2015_2week_omitNA$oxygen_dissolved, tank_d2015_2week_omitNA$original_tank, mean)
options(digits=3)
summaryBy(oxygen_dissolved ~ treatment_oxygen + treatment_salinity, data=tank_d2015_2week_omitNA, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
DO2015 <- aov(oxygen_dissolved ~ treatment, data=tank_d2015_2week_omitNA)
summary(DO2015)
tuk <- glht(DO2015, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# temperature
tapply(tank_d2015_2week_omitNA$temp, tank_d2015_2week_omitNA$original_tank, mean)
options(digits=3)
summaryBy(temp ~ treatment_oxygen + treatment_salinity, data=tank_d2015_2week_omitNA, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
C2015 <- aov(temp ~ treatment*time, data=tank_d2015_2week_omitNA)
summary(C2015)
tuk <- glht(C2015, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# salinity
tapply(tank_d2015_2week_omitNA$salinity, tank_d2015_2week_omitNA$original_tank, mean)
options(digits=3)
summaryBy(salinity ~ treatment_oxygen + treatment_salinity, data=tank_d2015_2week_omitNA, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
ppt2015 <- aov(salinity ~ treatment, data=tank_d2015_2week_omitNA)
summary(ppt2015)
tuk <- glht(ppt2015, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

## Year One Size
# weight.in.mean
tapply(d2015_diff_bytank$weight.in.mean, d2015_diff_bytank$treatment, mean)
summaryBy(weight.in.mean ~ treatment,data=d2015_diff_bytank, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
g_in_2015 <- aov(weight.in.mean ~ treatment,data=d2015_diff_bytank)
summary(g_in_2015)
tuk <- glht(g_in_2015, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# length.in.mean
tapply(d2015_diff_bytank$length.in.mean, d2015_diff_bytank$treatment, mean)
summaryBy(length.in.mean ~ treatment,data=d2015_diff_bytank, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
mm_in_2015 <- aov(length.in.mean ~ treatment,data=d2015_diff_bytank)
summary(mm_in_2015)
tuk <- glht(mm_in_2015, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# weight.out.mean
tapply(d2015_diff_bytank$weight.out.mean, d2015_diff_bytank$treatment, mean)
summaryBy(weight.out.mean ~ treatment,data=d2015_diff_bytank, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
g_out_2015 <- aov(weight.out.mean ~ treatment,data=d2015_diff_bytank)
summary(g_out_2015)
tuk <- glht(g_out_2015, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# length.out.mean
tapply(d2015_diff_bytank$length, d2015_diff_bytank$treatment, mean)
summaryBy(length.out.mean ~ treatment,data=d2015_diff_bytank, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
mm_out_2015 <- aov(length.mean ~ treatment,data=d2015_diff_bytank)
summary(mm_out_2015)
tuk <- glht(mm_out_2015, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# weight.diff
summaryBy(weight.diff ~ treatment,data=d2015_diff_bytank, FUN=c(length,mean,se), fun.names=c("n","mean","se"))
g_diff_2015 <- aov(weight.diff ~ treatment,data=d2015_diff_bytank)
summary(g_diff_2015)
tuk <- glht(g_diff_2015, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# length.diff
summaryBy(length.diff ~ treatment,data=d2015_diff_bytank, FUN=c(length,mean,se), fun.names=c("n","mean","se"))
mm_diff_2015 <- aov(length.diff ~ treatment,data=d2015_diff_bytank)
summary(mm_diff_2015)
tuk <- glht(mm_diff_2015, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

## Year Two Water Quality
# dissolved oxygen
tapply(tank_d2017_2week_omitNA$oxygen_dissolved, tank_d2017_2week_omitNA$original_tank, mean)
options(digits=4)
summaryBy(oxygen_dissolved ~ treatment_oxygen + treatment_salinity, data=tank_d2017_2week_omitNA, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
DO2017 <- aov(oxygen_dissolved ~ treatment, data=tank_d2017_2week_omitNA)
summary(DO2017)
tuk <- glht(DO2017, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# temperature
tapply(tank_d2017_2week_omitNA$temp, tank_d2017_2week_omitNA$original_tank, mean)
options(digits=4)
summaryBy(temp ~ treatment_oxygen + treatment_salinity, data=tank_d2017_2week_omitNA, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
C2017 <- aov(temp ~ treatment*time, data=tank_d2017_2week_omitNA)
summary(C2017)
tuk <- glht(C2017, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# salinity
tapply(tank_d2017_2week_omitNA$salinity, tank_d2017_2week_omitNA$original_tank, mean)
options(digits=4)
summaryBy(salinity ~ treatment_oxygen + treatment_salinity, data=tank_d2017_2week_omitNA, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
ppt2017 <- aov(salinity ~ treatment, data=tank_d2017_2week_omitNA)
summary(ppt2017)
tuk <- glht(ppt2017, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

## Year Two Size
# weight.in.mean
tapply(d2017_diff_bytank$weight.in.mean, d2017_diff_bytank$treatment, mean)
summaryBy(weight.in.mean ~ treatment,data=d2017_diff_bytank, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
g_in_2017 <- aov(weight.mean ~ treatment,data=d2017_diff_bytank)
summary(g_in_2017)
tuk <- glht(g_in_2017, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# length.in.mean
d2017_NAomit <- na.omit(d2017_diff_bytank)
tapply(d2017_NAomit$length.in.mean, d2017_NAomit$treatment, mean)
summaryBy(length.in.mean ~ treatment,data=d2017_NAomit, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
mm_in_2017 <- aov(length.in.mean ~ treatment,data=d2017_NAomit)
summary(mm_in_2017)
tuk <- glht(mm_in_2017, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# weight.out.mean
tapply(d2017_diff_bytank$weight.out.mean, d2017_diff_bytank$treatment, mean)
summaryBy(weight.out.mean ~ treatment,data=d2017_diff_bytank, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
g_out_2017 <- aov(weight.out.mean ~ treatment,data=d2017_diff_bytank)
summary(g_out_2017)
tuk <- glht(g_out_2017, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# length.out.mean
tapply(d2017_diff_bytank$length.out.mean, d2017_diff_bytank$treatment, mean)
summaryBy(length.out.mean ~ treatment,data=d2017_diff_bytank, FUN=c(length, mean, se), fun.names=c("n","mean","se"))
mm_out_2017 <- aov(length.out.mean ~ treatment,data=d2017_diff_bytank)
summary(mm_out_2017)
tuk <- glht(mm_out_2017, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# weight.diff
tapply(d2017_diff_bytank$weight.diff, d2017_diff_bytank$treatment, mean)
summaryBy(weight.diff ~ treatment,data=d2017_diff_bytank, FUN=c(length,mean,se), fun.names=c("n","mean","se"))
g_diff_2017 <- aov(weight.diff ~ treatment,data=d2017_diff_bytank)
summary(g_diff_2017)
tuk <- glht(g_diff_2017, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

# length.diff
tapply(d2017_diff_bytank$length.diff, d2017_diff_bytank$treatment, mean)
summaryBy(length.diff ~ treatment,data=d2017_diff_bytank, FUN=c(length,mean,se), fun.names=c("n","mean","se"))
mm_diff_2017 <- aov(length.diff ~ treatment,data=d2017_diff_bytank)
summary(mm_diff_2017)
tuk <- glht(mm_diff_2017, linfct = mcp(treatment = "Tukey"))
summary(tuk)          # standard display
tuk.cld <- cld(tuk)   # letter-based display
opar <- par(mai=c(1,1,1.5,1))
plot(tuk.cld)
par(opar)

