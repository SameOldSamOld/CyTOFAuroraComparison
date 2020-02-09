# CyTOFAuroraComparison
Addressing reviewer comments in regard to a comparison between CyTOF and Aurora data

## Code to create figure 1d

*plotPCCounts.R* is the R code used to create figure 1d using ggplot2. Run the script in its entirety to reproduce figure 1d.

*/data/percountCounts.csv* is the downloadable dataset with raw values used to calculate 95% confidence interval as requested by reviewers.

Or you can run it in one go by copy pasting this code into R:

    eval(parse("https://raw.githubusercontent.com/SameOldSamOld/CyTOFAuroraComparison/master/plotPCCounts_figure1d.R"))

## Code to calculate f-scores
