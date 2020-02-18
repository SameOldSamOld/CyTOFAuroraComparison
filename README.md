# CyTOFAuroraComparison

This GitHub page contains scripts used in our current publication comparing cytometry datasets to create figures addressing reviewer comments. 

## Code to create figure 1d

In ![figure 1d ](https://github.com/SameOldSamOld/CyTOFAuroraComparison/blob/master/data/fig1d.pdf) we wanted to visually and statistically compare the ability of CyTOF and Aurora technologies to measure similar percentages of 11 immune cell populations in our sample data. We chose to show the 95% confidence interval of each cell population replicate to compare the estimation of the true population percentage using CyTOF and Aurora. The statistical values were calculated in R and visualised in ggplot2<sup>1</sup>

To obtain the raw data values, Ferrer-Font et al. performed expert gating upon each of the 11 cell populations to identify the percentage of all cells in each FCS file. These percentages were loaded into R to calculate the mean and 95% confidence interval. The script and data for loading, computing and visualising are available as described below. They can be downloaded and run in RStudio from this page.

*plotPCCounts.R* is the R code used to create figure 1d using ggplot2<sup>1</sup>

To obtain the raw data values, *plotPCCounts.R* requires the data from */data/percountCounts.csv* to reproduce figure 1d.

*/data/percountCounts.csv* is the dataset with raw values used to calculate the mean, and 95% confidence interval.

You can run this code by copy pasting this code into the RStudio Console:

    eval(parse( "https://raw.githubusercontent.com/SameOldSamOld/CyTOFAuroraComparison/master/plotPCCounts_figure1d.R"))

## Code to generate Concordance Correlation Coefficient

In order to address whether cell percentages defined in our CyTOF or Aurora datasets were comparable, we calculated the concordance correlation coefficient which calculates the agreement between two variables. This statistic was calculated by installing the R package *epiR<sup>2</sup>* and visualised using *ggplot2<sup>1</sup>*.

 ![concordance correlation coefficient plot](/data/ccc_plot.pdf) was generated to calculate a coefficient for similar markers between CyTOF and Aurora technologies. This is performed by installing the *epiR* package to calculate the concordance correlation coefficient from raw values obtained by Laura Ferrer. The calculation was performed between two sets of observations (CyTOF & Aurora) with a 95% confidence interval using the ‘z-transform’ method. 

*ccc_plot.R* is the script used to calculate the concordance correlation coefficient. Raw values used to calculate the correlation concordance coefficient are included within the script. 

You can run this code by copy pasting this code into the RStudio Console:

    eval(parse( "https://raw.githubusercontent.com/SameOldSamOld/CyTOFAuroraComparison/master/ccc_plot.R"))

## Code to calculate and plot F-scores

In order to determine the number of clusters that would optimally represent our data using Self-organising Maps for cytometry data such as FlowSOM<sup>3</sup>, we compared the effect of incrementing the number of clusters in a [i,j] matrix. To calculate the precision and recall between the different maps. FlowSOM<sup>3</sup>,  has an inbuilt statistic to compare two FlowSOM<sup>3</sup>,  graphs called an F score. The F score measures precision and recall between two observations. We observed that an optimal range of clusters was achieved between 80 - 150 clusters for our dataset. A lower number of clusters was not biologically relevant and higher numbers of clusters caused cyclic graphs.

We used several R packages to calculate the F score as cluster sizes are incremented, including FlowSOM<sup>3</sup>, flowCore<sup>4</sup>, and ggplot2<sup>1</sup> for visualisation. The script *FlowSOM-Fscore.R* first uses *flowCore<sup>4</sup>* to load the FCS files attached in /data/. which is followed by marker selection and data normalisation. The loaded FCS files are then used to calculate a Self-organising map using *FlowSOM*. 24 *FlowSOM* graphs are generated for both Aurora and CyTOF FCS files with exponentially larger cluster sizes ![](/data/CodeCogsEqn.gif) and the *FMeasure* algorithm from *FlowSOM* is used to generate an F-score after each incrementation. The F-scores are finally plotted using *ggplot2<sup>1</sup>*.

To reproduce the F score calculation, you will need to follow these steps to run this code in R:

1) Download this GitHub repository as a .zip

2) Unzip the folder and open *FlowSOM-Fscore.R* in RStudio

3) Click Source or ⌘:arrow_up:S

The algorithm will calculate 48 Self-organising maps and can take at least 10-15 minutes to run on a 16GB RAM, 2.3 GHz Intel i5 computer.


## References

1.	H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.

2.	Mark Stevenson with contributions from Telmo Nunes, Cord Heuer, Jonathon Marshall, Javier Sanchez,  Ron Thornton, Jeno Reiczigel, Jim Robison-Cox, Paola Sebastiani, Peter Solymos, Kazuki Yoshida,  Geoff Jones, Sarah Pirikahu, Simon Firestone, Ryan Kyle, Johann Popp, Mathew Jay and Charles  Reynard. (2020). epiR: Tools for the Analysis of Epidemiological Data. R package version 1.0-11.  https://CRAN.R-project.org/package=epiR

3.	Sofie Van Gassen, Britt Callebaut and Yvan Saeys (2019). FlowSOM: Using self-organizing maps for  visualization and interpretation of cytometry data. http://www.r-project.org, http://dambi.ugent.be.

4.	B Ellis, Perry Haaland, Florian Hahne, Nathan Le Meur, Nishant Gopalakrishnan, Josef Spidlen, Mike Jiang and Greg Finak (2019). flowCore: flowCore: Basic structures for flow cytometry data. R package version 1.50.0.
