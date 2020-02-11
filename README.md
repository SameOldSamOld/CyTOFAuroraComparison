# CyTOFAuroraComparison

This GitHub page contains several scripts addressing reviewer comments in regard to a comparison between CyTOF and Aurora data

## Code to create figure 1d

![Figure 1d](https://github.com/SameOldSamOld/CyTOFAuroraComparison/blob/master/data/fig1d.pdf) was used to visualise the percentage of 11 cell populations as estimated through the use of CyTOF and Spectral cytometry technologies.

*plotPCCounts.R* is the R code used to create figure 1d using ggplot2. It uses the data from */data/percountCounts.csv* to reproduce figure 1d.

*/data/percountCounts.csv* is the dataset with raw values used to calculate 95% confidence interval as requested by reviewers.

You can run this code by copy pasting this code into the RStudio Console:

    eval(parse("https://raw.githubusercontent.com/SameOldSamOld/CyTOFAuroraComparison/master/plotPCCounts_figure1d.R"))

## Code to generate Concordance Correlation Coefficient

*ccc_plot.R* was used to calculate the concordance correlation coefficient used in a figure for our paper.

You can run this code by copy pasting this code into the RStudio Console:

    eval(parse("https://raw.githubusercontent.com/SameOldSamOld/CyTOFAuroraComparison/master/ccc_plot.R"))

## Code to calculate and plot F-scores

1) Download this GitHub repository

2) Unzip the folder and open *FlowSOM-Fscore.R* in RStudio

3) Click Source or ⌘:arrow_up:S

The algorithm will calculate 46 Self Organising Maps and can take at least 10 minutes to run. 
