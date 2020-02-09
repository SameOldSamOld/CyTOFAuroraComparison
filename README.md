# CyTOFAuroraComparison
Addressing reviewer comments in regard to a comparison between CyTOF and Aurora data

## Code to create figure 1d

*plotPCCounts.R* is the R code used to create figure 1d using ggplot2. It uses the data from */data/percountCounts.csv* to reproduce figure 1d.

*/data/percountCounts.csv* is the dataset with raw values used to calculate 95% confidence interval as requested by reviewers.

You can run this code by copy pasting this code into R:

    eval(parse("https://raw.githubusercontent.com/SameOldSamOld/CyTOFAuroraComparison/master/plotPCCounts_figure1d.R"))

## Code to generate Concordance Correlation Coefficient

*ccc_plot.R* was used to calculate the concordance correlation coefficient used in a figure for our paper.

You can run this code by copy pasting this code into R:

    eval(parse("https://raw.githubusercontent.com/SameOldSamOld/CyTOFAuroraComparison/master/ccc_plot.R"))

## Code to calculate f-scores
