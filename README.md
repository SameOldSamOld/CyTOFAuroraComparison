# CyTOFAuroraComparison

This github page contains the scripts and algorithms used for the comparison of CYTOF and Aurora technologies as presented in Ferrer-Font, Cytometry A, 2020 (Link will be added when made available).

## Compare immune cell percentages measured by CyTOF and Aurora technologies

We wanted to visually and statistically compare the ability of CyTOF and Aurora technologies to measure the similarity of 11 immune cell populations. To compare each population, we calculated the 95% confidence interval of all cell population replicates. The statistical values were calculated in R and then visualised using *ggplot2<sup>1</sup>*

To obtain the raw data values, Ferrer-Font *et. al.* performed expert gating upon each of the 11 cell populations to identify the percentage of all cells in each FCS file. These percentages were loaded into R to calculate the mean and 95% confidence interval. The script and data for loading, computing and visualising are available as described below. They can be downloaded and run in RStudio from this page.

*plotPCCounts.R* is the R code used to create figure 1D using *ggplot2<sup>1</sup>*

To obtain the raw data values, *plotPCCounts.R* requires the data from */data/percountCounts.csv* to reproduce figure 1D.

*/data/percountCounts.csv* is the dataset with raw values used to calculate the mean, and 95% confidence interval.

This code can be run by copy pasting this code into the RStudio Console:

    eval(parse("https://raw.githubusercontent.com/SameOldSamOld/CyTOFAuroraComparison/master/plotPCCounts_figure1d.R"))

## Calculate Concordance Correlation Coefficient

In order to address whether cell percentages defined in our CyTOF or Aurora datasets were comparable, we calculated the concordance correlation coefficient which calculates the agreement between two variables. This statistic was calculated by installing the R package *epiR<sup>2</sup>* and visualised using *ggplot2<sup>1</sup>*

 ![A concordance correlation coefficient plot](/data/ccc_plot.pdf) was generated to calculate a coefficient for similar cell populations between CyTOF and Aurora technologies. This is performed by installing the *epiR<sup>2</sup>* package to calculate the concordance correlation coefficient from raw values obtained by Ferrer-Font, L. et. al. The calculation was performed between two sets of observations (CyTOF & Aurora) with a 95% confidence interval using the ‘z-transform’ method. 

*ccc_plot.R* is the script used to calculate the concordance correlation coefficient. Raw values used to calculate the correlation concordance coefficient are included within the script. 

This code can be run by copy pasting this code into the RStudio Console:

    eval(parse("https://raw.githubusercontent.com/SameOldSamOld/CyTOFAuroraComparison/master/ccc_plot.R"))

## Calculate and plot F-scores

In order to determine the number of clusters that would optimally represent our data using Self-organising Maps for cytometry data such as FlowSOM<sup>3</sup>, we compared the effect of incrementing the number of clusters in a [i,j] matrix. FlowSOM<sup>3</sup>, has an inbuilt function (FMeasure) to compare two FlowSOM<sup>3</sup>, graphs in an F-score. The F-score summarises the precision and recall between two observations. We observed that an optimal range of clusters was achieved between 80 - 150 clusters for our dataset. A lower number of clusters was not biologically relevant and higher numbers of clusters caused cyclic graphs.

We used several R packages to calculate the F-score as cluster sizes were incremented. These included FlowSOM<sup>3</sup>,*flowCore<sup>4</sup>*, and *ggplot2<sup>1</sup>*. The script *FlowSOM-Fscore.R* first uses *flowCore<sup>4</sup>* to load the FCS files attached in /data/. which is followed by marker selection and data normalisation. The loaded FCS files are then used to calculate a Self-organising Map using *FlowSOM<sup>3</sup>*. 24 *FlowSOM<sup>3</sup>,* graphs were generated for both Aurora and CyTOF FCS files with exponentially larger cluster sizes ![](/data/CodeCogsEqn.gif). The *FMeasure* algorithm from *FlowSOM<sup>3</sup>* was used to generate an F-score after each incrementation. The F-scores were then plotted using *ggplot2<sup>1</sup>*

To reproduce the F-score calculation, the following steps should be followed to run this code in R: 

1) Download this GitHub repository as a .zip

2) Unzip the folder and open *FlowSOM-Fscore.R* in RStudio

3) Click Source or ⌘:arrow_up:S

The algorithm will calculate 48 Self-organising maps and can take at least 10-15 minutes to run on a 16GB RAM, 2.3 GHz Intel i5 computer.


## References

1.	H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.

2.	Mark Stevenson with contributions from Telmo Nunes, Cord Heuer, Jonathon Marshall, Javier Sanchez,  Ron Thornton, Jeno Reiczigel, Jim Robison-Cox, Paola Sebastiani, Peter Solymos, Kazuki Yoshida,  Geoff Jones, Sarah Pirikahu, Simon Firestone, Ryan Kyle, Johann Popp, Mathew Jay and Charles  Reynard. (2020). epiR: Tools for the Analysis of Epidemiological Data. R package version 1.0-11.  https://CRAN.R-project.org/package=epiR

3.	Sofie Van Gassen, Britt Callebaut and Yvan Saeys (2019). FlowSOM: Using self-organizing maps for  visualization and interpretation of cytometry data. http://www.r-project.org, http://dambi.ugent.be.

4.	B Ellis, Perry Haaland, Florian Hahne, Nathan Le Meur, Nishant Gopalakrishnan, Josef Spidlen, Mike Jiang and Greg Finak (2019). flowCore: flowCore: Basic structures for flow cytometry data. R package version 1.50.0.
