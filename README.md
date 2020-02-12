# CyTOFAuroraComparison

This GitHub page contains several scripts addressing reviewer comments in regard to a comparison between CyTOF and Aurora data

## Code to create figure 1d

In ![figure 1d](https://github.com/SameOldSamOld/CyTOFAuroraComparison/blob/master/data/fig1d.pdf) we wanted to visually and statistically compare the ability of CyTOF and Aurora technologies to estimate the percentage of 11 cell populations. We chose to show the 95% confidence interval of each cell population replicate to compare the estimation of the true population percentage using CyTOF and Aurora. The statistical values were calculated in R and visualised in ggplot2 (H. Wickham) for publication ready images.

To obtain the raw data values, Laura Ferrer performed expert gating upon each of the 11 cell populations to find the percentage of all cells in each FCS file. These percentage values were loaded into R to calculate the mean and 95% confidence interval. The script and data for loading, computing and visualising are available as described below. They can be downloaded and run in RStudio from this page.

*plotPCCounts.R* is the R code used to create figure 1d using ggplot2. It requires the data from */data/percountCounts.csv* to reproduce figure 1d.

*/data/percountCounts.csv* is the dataset with raw values used to calculate the mean, and 95% confidence interval as recommended by reviewers.

You can run this code by copy pasting this code into the RStudio Console:

    eval(parse("https://raw.githubusercontent.com/SameOldSamOld/CyTOFAuroraComparison/master/plotPCCounts_figure1d.R"))

## Code to generate Concordance Correlation Coefficient

Another problem we wanted to address was that we wanted to find a coefficient to summarise the similarity or differences for similar markers between CyTOF and Aurora technologies. We chose to compare CyTOF and Aurora using a concordance correlation coefficient. This statistic was calculated by installing the R package *epiR* (Mark Stevenson *et al*). The *ggplot2* (H. Wickham.) package was used again for publication ready, easy to use figures.

 ![concordance correlation coefficient plot](/data/ccc_plot.pdf) was generated to calculate a coefficient for similar markers between CyTOF and Aurora technologies. This is performed by installing the *epiR* package to calculate the concordance correlation coefficient from raw values obtained by Laura Ferrer. The calculation was performed between two sets of observations (CyTOF & Aurora) with a 95% confidence interval using the ‘z-transform’ method. 

*ccc_plot.R* is the script used to calculate the concordance correlation coefficient. Raw values used to calculate the correlation concordance coefficient are included within the script. 

You can run this code by copy pasting this code into the RStudio Console:

    eval(parse("https://raw.githubusercontent.com/SameOldSamOld/CyTOFAuroraComparison/master/ccc_plot.R"))

## Code to calculate and plot F-scores

We were asked to justify the number of clusters we used for the generation of Self Organising Maps for cytometry data by FlowSOM. We wanted to compare the effect of incrementing the number of clusters in a [i,j] matrix. We had seen that using a high number of clusters can cause a cyclic graph (graph theory) within the FlowSOM graph which are meaningless FlowSOM graphs. FlowSOM has an inbuilt statistic to compare two FlowSOM graphs called an F-score. We used the F-score to assess the similarity of FlowSOM graphs as we increased the number of clusters used in generating each FlowSOM graph. We used several R packages to achieve this: FlowSOM (Sofie Van Gassen *et al*), flowCore (B Ellis *et al*), and ggplot2 (H. Wickham) for visualisation.

This script *FlowSOM-Fscore.R* first uses *flowCore* to load the FCS files attached in /data/. which is followed by marker selection and data normalisation. The loaded FCS files are then used to calculate a Self Organising Map using *FlowSOM*. 24 *FlowSOM* graphs are generated for both Aurora and CyTOF FCS files with exponentially larger cluster sizes {2 … 25}^2 and the *FMeasure* algorithm from *FlowSOM* is used to generate an F-score after each incrementation. The F-scores are finally plotted using *ggplot2*.

Reproduce the F-score calculation you will need to follow these steps to run this code in R:

1) Download this GitHub repository as a .zip

2) Unzip the folder and open *FlowSOM-Fscore.R* in RStudio

3) Click Source or ⌘:arrow_up:S

The algorithm will calculate 48 Self Organising Maps and can take at least 10-15 minutes to run on a 16GB RAM computer.


## Citations

H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.

Mark Stevenson with contributions from Telmo Nunes, Cord Heuer, Jonathon Marshall, Javier Sanchez,  Ron Thornton, Jeno Reiczigel, Jim Robison-Cox, Paola Sebastiani, Peter Solymos, Kazuki Yoshida,  Geoff Jones, Sarah Pirikahu, Simon Firestone, Ryan Kyle, Johann Popp, Mathew Jay and Charles  Reynard. (2020). epiR: Tools for the Analysis of Epidemiological Data. R package version 1.0-11.  https://CRAN.R-project.org/package=epiR

Sofie Van Gassen, Britt Callebaut and Yvan Saeys (2019). FlowSOM: Using self-organizing maps for  visualization and interpretation of cytometry data. http://www.r-project.org, http://dambi.ugent.be.

B Ellis, Perry Haaland, Florian Hahne, Nathan Le Meur, Nishant Gopalakrishnan, Josef Spidlen, Mike Jiang and Greg Finak (2019). flowCore: flowCore: Basic structures for flow cytometry data. R package version 1.50.0.
