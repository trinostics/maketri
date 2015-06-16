#x <- read.csv(choose.files("data\\*.csv"), header=TRUE, stringsAsFactors = FALSE)
x <- read.csv("data\\clmsmpl.csv", header=TRUE, stringsAsFactors = FALSE)
library(reshape2)
suppressPackageStartupMessages(library(mondate))
suppressPackageStartupMessages(library(ChainLadder))

# even tho 'age' was c alculated in 'clmsmpl.r', recalculate it on the fly
# b/c it could be a function of something o/t the lossyear
x$age <- mondate(x$eval_dt) - mondate.ymd(x$ay - 1)

tri <- acast(x, ay ~ age, sum, value.var = "directlossincurred", fill = as.numeric(NA))
tri

ata(tri)
