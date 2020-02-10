## Sam Old - 10th Feburary 2020
## FLOWSOM
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
if (!requireNamespace("FlowSOM", quietly = TRUE))
  BiocManager::install("FlowSOM")
if (!requireNamespace("flowCore", quietly = TRUE))
  BiocManager::install("flowCore")
if (!requireNamespace("ggplot2", quietly = TRUE))
  install.packages('ggplot2')
library(FlowSOM)
library(ggplot2)
library(flowCore)
library(rstudioapi)

# Getting the path of your current open file
current_path <- rstudioapi::getActiveDocumentContext()$path
setwd(dirname(current_path))

# Load datasets for Aurora
asinh_value <- 5
seed    <- 44
Fscore  <- VarScore <- RangeScore <- MeanScore <- list()
fsFiles <- c(
  "data/AURORA_DS_PBS1_11.fcs",
  "data/AURORA_DS_PBS1_8.fcs",
  "data/AURORA_DS_PBS2_11.fcs",
  "data/AURORA_DS_PBS2_8.fcs",
  "data/AURORA_DS_PBS3_11.fcs",
  "data/CYTOF_DS_Spleen_day11_PBS_1.fcs",
  "data/CYTOF_DS_Spleen_day11_PBS_2.fcs",
  "data/CYTOF_DS_Spleen_day11_PBS3_.fcs",
  "data/CYTOF_DS_SPleen_day8_PBS_1.fcs",
  "data/CYTOF_DS_Spleen_day8_PBS_2.fcs"
)
fs.A <- read.flowSet(files = fsFiles[1:5])
marker.A        <- c("MHCII", "Ki67", "CD3e", "Ly6C", "CD69",
                     "CD161", "Ly6G", "CD11c", "CD45R", "FoxP3",
                     "XCR1", "CD274", "CD44", "CD11b", "CD4",
                     "CD279", "KLRG1", "F4/80", "CD8a", "CD45")
names(marker.A) <- c("FJComp-eFluor 450-A", "FJComp-BV480-A", "FJComp-BV510-A", "FJComp-BV570-A", "FJComp-Super Bright 600-A",
                     "FJComp-BV650-A", "FJComp-BV711-A", "FJComp-BV786-A", "FJComp-FITC-A", "FJComp-Alexa Fluor 532-A",
                     "FJComp-PE-A", "FJComp-PE-Dazzle594-A", "FJComp-PE-Cy5-A", "FJComp-BB700-A", "FJComp-PerCP-eFluor 710-A",
                     "FJComp-PE-Cy7-A", "FJComp-APC-A", "FJComp-Alexa Fluor 647-A", "FJComp-Alexa Fluor 700-A", "FJComp-APC-Fire 750-A")
fs.A <- fs.A[1:3][,names(marker.A)]


# Need to initialise 'realClusters' with clusterSide = 2
data1 <- exprs(fs.A[[1]])
data1[, names(marker.A)] <- asinh(data1[, names(marker.A)] / asinh_value)
data2 <- exprs(fs.A[[2]])
data2[, names(marker.A)] <- asinh(data2[, names(marker.A)] / asinh_value)
data3 <- exprs(fs.A[[3]])
data3[, names(marker.A)] <- asinh(data3[, names(marker.A)] / asinh_value)

data_FlowSOM <- flowFrame(data1)
fs.A[[1]]@exprs <- data1
fs.A[[2]]@exprs <- data2
fs.A[[3]]@exprs <- data3

set.seed(seed)
out <- FlowSOM::ReadInput(data_FlowSOM, transform = FALSE, scale = FALSE)
set.seed(seed)
out <- FlowSOM::ReadInput(fs.A, transform = FALSE, scale = FALSE)
set.seed(seed)
out <- FlowSOM::BuildSOM(out, colsToUse = names(marker.A), xdim = 2, ydim = 2)
set.seed(seed)
out <- FlowSOM::BuildMST(out)
set.seed(seed)
labels_pre <- out$map$mapping[, 1]
metacl <- metaClustering_consensus(out$map$codes, k = 3, seed = seed)
realClusters <- out$map$mapping[,1]

# Now that realClusters is initialised, increment clusters and test recall as cluster size increases exponentially
Fscore <- VarScore <- RangeScore <- MeanScore <- list()
for (i in 3:25) {

  set.seed(seed)
  out <- FlowSOM::ReadInput(data_FlowSOM, transform = FALSE, scale = FALSE)
  set.seed(seed)
  out <- FlowSOM::ReadInput(fs.A, transform = FALSE, scale = FALSE)
  set.seed(seed)
  out <- FlowSOM::BuildSOM(out, colsToUse = names(marker.A), xdim = i, ydim = i)
  set.seed(seed)
  out <- FlowSOM::BuildMST(out)

  # extract cluster labels (pre meta-clustering) from output object
  set.seed(seed)
  labels_pre <- out$map$mapping[, 1]

  set.seed(seed)
  metacl <- metaClustering_consensus(out$map$codes, k = 8, seed = seed)
  # set.seed(seed)
  # FlowSOM::PlotVariable(out, metacl)
  set.seed(seed)
  predictedClusters <- out$map$mapping[,1]
  set.seed(seed)

  Fscore[[i]] <- FMeasure(realClusters,predictedClusters)
  VarScore[[i]] <- var(as.numeric(table(predictedClusters)))
  RangeScore[[i]] <- range(as.numeric(table(predictedClusters)))
  MeanScore[[i]] <- mean(as.numeric(table(predictedClusters)))
  realClusters <- predictedClusters
}

Fscore.Aurora <- unlist(Fscore)
Range.Aurora  <- unlist(RangeScore)
Min.Aurora    <- Range.Aurora[seq(from = 1, to = length(Range.Aurora), by = 2)]
Max.Aurora    <- Range.Aurora[seq(from = 2, to = length(Range.Aurora), by = 2)]
Mean.Aurora   <- unlist(MeanScore)
Var.Aurora    <- unlist(VarScore)

FlowSOM_Clusters <- 3:25
FlowSOM_Clusters <- FlowSOM_Clusters^2
zz <- cbind(FlowSOM_Clusters, Fscore.Aurora, Min.Aurora, Max.Aurora, Mean.Aurora, Var.Aurora)

## Calculate values for CyTOF

fs.C <- read.flowSet(files = fsFiles[6:10])
marker.C        <- c("MHCII", "Ki67", "CD3e", "Ly6C", "CD69",
                     "CD161", "Ly6G", "CD11c", "CD45R", "FoxP3",
                     "XCR1", "CD274", "CD44", "CD11b", "CD4",
                     "CD279", "KLRG1", "F4/80", "CD8a", "CD45")
names(marker.C) <- c("Yb174Di", "Er162Di", "Gd152Di", "Nd150Di", "Nd145Di",
                     "Er170Di", "Pr141Di", "Nd142Di", "Nd144Di", "Er164Di",
                     "Gd154Di", "Gd156Di", "Yb171Di", "Nd148Di", "Nd143Di",
                     "Dy161Di", "Lu176Di", "Eu151Di", "Er168Di", "In113Di")
fs.C <- fs.C[1:3][,names(marker.C)]
asinh_value <- 5

data1 <- exprs(fs.C[[1]])
data1[, names(marker.C)] <- asinh(data1[, names(marker.C)] / asinh_value)
data2 <- exprs(fs.C[[2]])
data2[, names(marker.C)] <- asinh(data2[, names(marker.C)] / asinh_value)
data3 <- exprs(fs.C[[3]])
data3[, names(marker.C)] <- asinh(data3[, names(marker.C)] / asinh_value)

data_FlowSOM <- flowFrame(data1)
fs.C[[1]]@exprs <- data1
fs.C[[2]]@exprs <- data2
fs.C[[3]]@exprs <- data3

Fscore <- VarScore <- RangeScore <- MeanScore <- list()

# Need to do one runthrough of the for loop first with clusterSide = 2 to initialise 'realClusters'
set.seed(seed)
out <- FlowSOM::ReadInput(data_FlowSOM, transform = FALSE, scale = FALSE)
set.seed(seed)
out <- FlowSOM::ReadInput(fs.C, transform = FALSE, scale = FALSE)
set.seed(seed)
out <- FlowSOM::BuildSOM(out, colsToUse = names(marker.C),
                         xdim = 2, ydim = 2)
set.seed(seed)
out <- FlowSOM::BuildMST(out)

# extract cluster labels (pre meta-clustering) from output object
set.seed(seed)
labels_pre <- out$map$mapping[, 1]
set.seed(seed)
metacl <- metaClustering_consensus(out$map$codes, k = 3, seed = seed)
set.seed(seed)
realClusters <- out$map$mapping[,1]

for (i in 3:25) {
  set.seed(seed)
  out <- FlowSOM::ReadInput(data_FlowSOM, transform = FALSE, scale = FALSE)
  set.seed(seed)
  out <- FlowSOM::ReadInput(fs.C, transform = FALSE, scale = FALSE)
  set.seed(seed)
  out <- FlowSOM::BuildSOM(out, colsToUse = names(marker.C),
                           xdim = i, ydim = i)
  set.seed(seed)
  out <- FlowSOM::BuildMST(out)
  set.seed(seed)
  # FlowSOM::PlotStars(out)

  # extract cluster labels (pre meta-clustering) from output object
  set.seed(seed)
  labels_pre <- out$map$mapping[, 1]

  set.seed(seed)
  metacl <- metaClustering_consensus(out$map$codes, k = 8, seed = seed)
  set.seed(seed)
  # FlowSOM::PlotVariable(out, metacl)
  set.seed(seed)
  predictedClusters <- out$map$mapping[,1]
  set.seed(seed)
      Fscore[[i]] <- FMeasure(realClusters,predictedClusters)
    VarScore[[i]] <- var(as.numeric(table(predictedClusters)))
  RangeScore[[i]] <- range(as.numeric(table(predictedClusters)))
   MeanScore[[i]] <- mean(as.numeric(table(predictedClusters)))
     realClusters <- predictedClusters
}

Fscore.CyTOF <- unlist(Fscore)
Range.CyTOF  <- unlist(RangeScore)
Min.CyTOF    <- Range.CyTOF[seq(from = 1, to = length(Range.CyTOF), by = 2)]
Max.CyTOF    <- Range.CyTOF[seq(from = 2, to = length(Range.CyTOF), by = 2)]
Mean.CyTOF   <- unlist(MeanScore)
Var.CyTOF    <- unlist(VarScore)

z <- as.data.frame(cbind(zz, Fscore.CyTOF, Min.CyTOF, Max.CyTOF, Mean.CyTOF, Var.CyTOF))

ggplot(data = z, aes(x = FlowSOM_Clusters, y = Fscore.Aurora)) +
  geom_point() +
  theme_classic() +
  xlab("Number of FlowSOM Clusters") +
  ylab("Aurora F-score")

ggplot(data = z, aes(x = FlowSOM_Clusters, y = Fscore.CyTOF)) +
  geom_point() +
  theme_classic() +
  xlab("Number of FlowSOM Clusters") +
  ylab("CyTOF F-score")
