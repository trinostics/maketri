x <- read.csv(choose.files("data\\*.csv"), header=TRUE, stringsAsFactors = FALSE)
library(reshape2)
suppressPackageStartupMessages(library(mondate))
suppressPackageStartupMessages(library(ChainLadder))

# even tho 'age' was c alculated in 'clmsmpl.r', recalculate it on the fly
# b/c it could be a function of something o/t the lossyear
x$age <- mondate(x$eval_dt) - mondate.ymd(x$ay - 1)

tri <- acast(x, ay ~ age, sum, value.var = "directlossincurred", fill = as.numeric(NA))
tri

# Choose a random 50% of the claims in each ay
## How many claims each ay?
sx <- split(x, x$ay)
clm <- lapply(sx, function(y) unique(y$matterno))
clmsmpl <- lapply(clm, function(y) y[sample(1:length(y), length(y)*.5)])
clmlistsmpl <- do.call(c, clmsmpl)
length(clmlistsmpl)

X <- subset(x, matterno %in% clmlistsmpl)
dim(x)
dim(X)
write.csv(X, file.path("data\\clmsmpl.csv"))
