x <- read.csv(choose.files("data\\*.csv"), header=TRUE, stringsAsFactors = FALSE)
ls(x)

table(x$itype)
x <- subset(x, itype %in% c("C"))

table(x$lob)
x <- subset(x, lob %in% c("CM"))

table(x$subcompanyid)

library(reshape2)
library(mondate)
head(x$lossdate)
class(x$lossdate)
head(x$eval_dt)
class(x$eval_dt)

x$ay <- year(as.Date(x$lossdate)) # , format = "%m/%d/%Y"))
table(x$ay)

x$eval_dt <- as.Date(x$eval_dt)) # , format = "%m/%d/%Y")
table(x$eval_dt)

x$age <- mondate(x$eval_dt) - mondate.ymd(x$ay - 1)

#tri <- acast(x, ay ~ age, sum, value.var = "directlossincurred", fill = as.numeric(NA))
#tri

# Choose a random 50% of the claims in each ay
## How many claims each ay?
sx <- split(x, x$ay)
clm <- lapply(sx, function(y) unique(y$matterno))
clmsmpl <- lapply(clm, function(y) y[sample(1:length(y), length(y)*.5)])
clmlistsmpl <- do.call(c, clmsmpl)

X <- subset(x, matterno %in% clmlistsmpl)

write.csv(X, file.path("data\\clmsmpl.csv"))

# Now open the file in excel and
##  1.  Delete the first 'recno' column
##  2.  Rename the (now) first column to matterno_eval
