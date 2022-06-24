library(tidyr)
library(dplyr)
library(tidyverse)
library(tibble)
library(nlme)
library(minpack.lm)

## input the tidy dataset
plateData <- read.delim("spectro_data.txt", sep="\t", header=TRUE)
colnames(plateData) <- c("salinity","oxygen","treatment","tank","fish","well","plate","CO2","O2","387nm","390nm","427nm")
plateData <- as_tibble(plateData)

OECdata <- plateData
OECdata <- select(OECdata, -salinity, -treatment, -oxygen, -tank, -plate)
OECdata <- unite(OECdata, fish,well,col="sample",sep="")

## input pH data
phData <- read.delim("phData.txt", sep="\t", header = TRUE)
phData <- as_tibble(phData)
## turn pH into [H+] for better averaging
phData <- mutate(phData, H=10^pH)
phTensions <- split(phData, f = phData$CO2)
names(phTensions) <- c("low","high")

lowPH <- split(phTensions, f=phTensions$low)
highPH <- split(phTensions, f=phTensions$high)


## turn %O2 into PO2 (torr)
OECdata$O2 <- OECdata$O2*7.6
colnames(OECdata) <- c("sample","CO2","PO2","387nm","390nm","427nm")

## lists of dataframes, each sample has its own dataframe
tensions <- split(OECdata, f = OECdata$CO2)
names(tensions) <- c("low","high")

lowSamples <- split(tensions$low, f=tensions$low$sample)
highSamples <- split(tensions$high, f=tensions$high$sample)

## add columns for ???? values for 427-387, 427-390, and average ????.
lowSamples <- lowSamples %>%
  map(~mutate(., delta387=`427nm`-`387nm`, delta390=`427nm`-`390nm`))
highSamples <- highSamples %>%
  map(~mutate(.,delta387=`427nm`-`387nm`, delta390=`427nm`-`390nm`))

## add columns for Y (% Hb-O2)
lowSamples <- lowSamples %>%
  map(~mutate(.,min387=NA,min390=NA,range387=NA,range390=NA,Y387=NA,Y390=NA))
highSamples <- highSamples %>%
  map(~mutate(.,min387=NA,min390=NA,range387=NA,range390=NA,Y387=NA,Y390=NA))

## calculate the min and range needed to calculate Y values.
## IDK why the pull function is returning a vector where the col name is the value I want
## but this works

for (i in 1:length(lowSamples)){
  lowSamples[[i]]$min387 <- as.numeric(names(pull(lowSamples[[i]] %>% filter(PO2==0), name=delta387)))
  lowSamples[[i]]$min390 <- as.numeric(names(pull(lowSamples[[i]] %>% filter(PO2==0), name=delta390)))
  lowSamples[[i]]$range387 <- as.numeric(names(pull(lowSamples[[i]] %>% filter(PO2==228), name=delta387)))
  lowSamples[[i]]$range390 <- as.numeric(names(pull(lowSamples[[i]] %>% filter(PO2==228), name=delta390)))
}

for (i in 1:length(highSamples)){
  highSamples[[i]]$min387 <- as.numeric(names(pull(highSamples[[i]] %>% filter(PO2==0), name=delta387)))
  highSamples[[i]]$min390 <- as.numeric(names(pull(highSamples[[i]] %>% filter(PO2==0), name=delta390)))
  highSamples[[i]]$range387 <- as.numeric(names(pull(highSamples[[i]] %>% filter(PO2==228), name=delta387)))
  highSamples[[i]]$range390 <- as.numeric(names(pull(highSamples[[i]] %>% filter(PO2==228), name=delta390)))
}

## calculate Y values

lowSamples <- lowSamples %>%
  map(~mutate(., Y387=(delta387-min387)/(range387-min387)))
lowSamples <- lowSamples %>%
  map(~mutate(.,Y390=(delta390-min390)/(range390-min390)))
lowSamples <- lowSamples %>%
  map(~mutate(.,Ymean=(Y387+Y390)/2))

highSamples <- highSamples %>%
  map(~mutate(., Y387=(delta387-min387)/(range387-min387)))
highSamples <- highSamples %>%
  map(~mutate(.,Y390=(delta390-min390)/(range390-min390)))
highSamples <- highSamples %>%
  map(~mutate(.,Ymean=(Y387+Y390)/2))

## loop over list of dataframes and add Y values to original data frame
colnames(OECdata) <- c("sample","CO2","PO2","nm1","nm2","nm3")
OECdata <- select(OECdata, -PO2, -nm1, -nm2, -nm3)

## loop over list of dataframes and write table to file
for (i in 1:length(lowSamples)){
  write.table(lowSamples[[i]],"OECYtable.txt",append=TRUE,sep="\t",col.names=FALSE,row.names=FALSE)
  write.table(highSamples[[i]],"OECYtable.txt",append=TRUE,sep="\t",col.names=FALSE,row.names=FALSE)
  }
## read that back in as a single data frame
take2 <- read.delim("OECYtable.txt", sep="\t", header=FALSE)
colnames(take2) <- colnames(lowSamples[[1]])
samplesOEC <- select(take2, sample, CO2, PO2, Ymean)

take3 <- read.delim("final_by_tank.txt", sep="\t",header=TRUE)

## merge old data frame with new data frame
test <- left_join(samplesOEC, OECdata, by="sample")
## remove duplicates
test <- distinct(test)
## filter only the ones where the CO2 tensions match and remove redundant column
colnames(test)[2] <- "COx"
colnames(test)[5] <- "COy"
test <- filter(test, COx==COy)
test <- select(test, -COy)

## make it mean something, with rownames for each sample
test <- pivot_wider(test, names_from="PO2", values_from="Ymean")
test <- unite(test, sample, COx, col="sample",sep="")
solution <- column_to_rownames(test, var="sample")

solution2 <- split(solution, 1:nrow(solution))
names(solution2) <- rownames(solution)

## solution is a dataframe where each row is named for the sample.

## solution2 is a list of dataframes. each dataframe has rownames equivalent
## to the sample. each column is the partial pressure of oxygen needed for curve
## the value is %Hb-O2 saturation.

## I need a a dataframe for each sample with an X value for each Y value. two cols.
## dumbass, transpose that shit.

actual_answer <- data.frame(t(solution))
rownames(actual_answer) <- colnames(solution)
colnames(actual_answer) <- rownames(solution)

## data_points is a list of vectors named for the relevant sample.

###############

data_points = list(NA)
models = list(NA)

X=c(0,7.6,15.2,22.8,38,53.2,76,114,159.6,228)

for (i in 1:length(solution2)) {
  Y = slice(solution2[[i]], 1)
  Y2 <- c(Y$`0`,Y$`7.6`,Y$`15.2`,Y$`22.8`,Y$`38`,Y$`53.2`,Y$`76`,Y$`114`,Y$`159.6`,Y$`228`)
  oec <- nlsLM(Y2 ~ d/(1 + exp(b*(log10(X) - log10(e)))), start = list(d=1, b=-5, e=20))
  name <- row.names(Y)
  models[[name]] <- oec
  data_points[[name]] <- Y2
}

colNames <- names(actual_answer[1:3])

for (i in colNames){
  plt <- ggplot(actual_answer, aes_string(x=X, y=i)) +
    geom_point(color="#B20000", size=4, alpha=0.5) + 
    geom_hline(yintercept=0,size=0.06,color="black") +
    geom_smooth(method=lm, alpha=0.25, color="black", fill="black")
  print(plt)
}

write.table(actual_answer,file="prune_this.txt",sep="\t",col.names=TRUE,row.names=TRUE)

## Loop the below over each sample.
## need to exclude the shitty ones.

x=c(0,7.6,15.2,22.8,38,53.2,76,114,159.6,228)

y= lowSamples[[3]]$Ymean
oec <- nlsLM(y ~ d/(1 + exp(b*(log10(x) - log10(e)))), start = list(d=1, b=-5, e=20))
plot(x, y, pch=16, col="blue", xlim = c(0,230), ylim = c(0,1.0),
     xlab=expression(italic("P")~O[2]), ylab=expression(Hb-O[2]~saturation), main="Oxygen Equilibrium Curve")
# plot fitted values
lines(x, fitted(oec), col="blue", lwd=2)
plot(X,)

x2 = lowSamples[[15]]$PO2
y2 = lowSamples[[15]]$Ymean
oec2 <- nlsLM(y2 ~ d/(1 + exp(b*(log10(x2) - log10(e)))), start = list(d=1, b=-5, e=20))

ggplot()

oecp50 <- (coef(oec)[3])*10^(1/(coef(oec)[2])*log((coef(oec)[1])/0.5 - 1)) ## oecp50 <- (coef(oec)[3])*10^(1/(coef(oec)[2])*log((coef(oec)[1])/0.5 - 1))
d <- coef(oec)[[1]]
b <- coef(oec)[[2]]
e <- coef(oec)[[3]]
oecp50 <- e*10^(1/b*log(d/0.5 - 1))
z <- log10(oecp50)
n50 <- -(b*exp(b*z))/((-(-1 + d)*e^(b/log(10)) + exp(b*z))*log(10)) ## result of differentiating Hill equation to get slope of "Hill plot" at log10(p50)
print(oec) # summary(oec); profile(oec); update(oec)           
coef(oec) # d <- coef(oec)[1]; b <- coef(oec)[2]; e <- coef(oec)[3]
round(oecp50, 3)
round(n50, 3)
