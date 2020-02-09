# Sam Old 10th February 2020
# Code to create figure 1D. comparing the cell population percentages by Spectral and CyTOF technologies.

if(!require(ggplot2)) {
  install.packages("ggplot2")
}
library(ggplot2)


# download raw data from github
percents <- read.csv("https://raw.githubusercontent.com/SameOldSamOld/CyTOFAuroraComparison/master/data/percountCounts.csv",
              row.names = 1, header = T)

# Change x labels to human readable for final figure
rn <- c("CD3 T cells", "CD4 T cells", "CD8 T cells", "DN T cells",
        "B cells", "NK cells", "Monocytes", "DCs",
        "DC1s", "DC2s", "Neutrophils")
rownames(percents) <- rn


## Reformat csv data for ggplot2
pcDat <- cbind(as.numeric(unlist(c(percents[,c(1,6)]))),
               as.numeric(unlist(c(percents[,c(2,7)]))),
               as.numeric(unlist(c(percents[,c(3,8)]))),
               as.numeric(unlist(c(percents[,c(4,9)]))),
               as.numeric(unlist(c(percents[,c(5,10)]))))
colnames(pcDat) <- c("obs1","obs2","obs3","obs4","obs5")
pcDat           <- as.data.frame(pcDat)

# Calculate mean, sd, mean, var, 95% confidence interval for the 5 observations
pcDat.mean <- rowMeans(pcDat)
pcDat.sd   <- apply(pcDat, 1, sd)
pcDat.var  <- apply(pcDat, 1, var)
std        <- function(x) sd(x)/sqrt(length(x))
pcDat.std  <- apply(pcDat, 1, std)
pcDat.95ci <- pcDat.std * 2.776 # to calculate 95 % ci I have used z = 2.776 for n = 5

# compile final dataframe format for ggplot2
pcDat$Technology <- c(rep("CyTOF", 11), rep("Aurora", 11))
pcDat$Cell       <- rep(rownames(percents),2)
pcDat$Mean       <- pcDat.mean
pcDat$sd         <- pcDat.sd
pcDat$var        <- pcDat.var
pcDat$std.error  <- pcDat.std
pcDat$ci95       <- pcDat.95ci

# Code to plot final output barchart figure
ggplot(pcDat, aes(x = Cell, y = Mean, fill = Technology)) +
  geom_bar(position = position_dodge(), stat = "identity") +
  geom_errorbar(aes(ymin = Mean - ci95, ymax = Mean + ci95), width = .2, position = position_dodge(.9)) +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("") +
  ylab("Estimated percentage of Cells") +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_discrete(limits = pcDat$Cell[1:11])
