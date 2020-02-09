## Sam Old
## Generate ccc plot from Laura's email


## Load Packages
if (!requireNamespace("epiR", quietly = TRUE))
  install.packages("epiR")
if (!requireNamespace("ggplot2", quietly = TRUE))
  install.packages("ggplot2")
library(epiR)
library(ggplot2)


## Read in raw data from Laura's provided sets.
s1_aurora <- c(29.1268,42.5622,14.7145,10.006,2.2459,4.0286,1.2992,2.6287,0.5993,1.7021,27.465)
s1_cytof  <- c(30.6778,44.6974,17.3129,10.6959,2.7243,2.251,0.4331,1.7172,1.3143,1.5007,25.8082)
s2_aurora <- c(43.8564,14.4224,9.3464,1.7222,4.4214,1.1683,3.097,1.0525,2.1049,20.5862,55.217)
s2_cytof  <- c(44.7578,13.8685,9.0543,1.41,3.8675,0.7654,3.0063,3.7869,1.828,22.5199,52.7999)
s3_aurora <- c(9.719,7.5285,3.4193,3.1725,1.2942,1.8481,1.1431,3.4243,1.1079,0.4633,1.4453)
s3_cytof  <- c(10.98,8.3442,2.7092,1.9942,0.282,1.6618,3.4293,1.5107,1.6568,4.2703,1.692)
aurora    <- c(s1_aurora,s2_aurora,s3_aurora)
cytof     <- c(s1_cytof, s2_cytof, s3_cytof)

data     <- data.frame(aurora, cytof)
data.ccc <- epi.ccc(aurora, cytof, ci = "z-transform", conf.level = 0.95, rep.measure = FALSE)
data.lab <- data.frame(lab = paste("CCC: ",
                                   round(data.ccc$rho.c[,1], digits = 2), " (95% CI ",
                                   round(data.ccc$rho.c[,2], digits = 2), " - ",
                                   round(data.ccc$rho.c[,3], digits = 2), ")", sep = ""))

z       <- lm(cytof ~ aurora)
alpha   <- summary(z)$coefficients[1,1]
beta    <-  summary(z)$coefficients[2,1]
data.lm <- data.frame(alpha, beta)

## Concordance correlation plot
p <- ggplot(data, aes(x = aurora, y = cytof)) +
  geom_point() +
  # scale_y_log10() +
  # scale_x_log10() +
  # geom_abline(intercept = 0, slope = 1) +
  geom_abline(data = data.lm, aes(intercept = alpha, slope = beta), linetype = "dashed") +
  geom_smooth(data = data, aes(x = aurora, y = cytof), method = "lm") +
  xlab("Aurora") +
  ylab("Cytof") +
  geom_text(data = data.lab, x = 10, y = 35, label = data.lab$lab) +
  coord_fixed(ratio = 1 / 1) +
  theme_minimal()
p
# p + coord_trans(x = "log10", y = "log10")
## In this plot the dashed line represents the line of perfect concordance.
## The solid line represents the reduced major axis.
