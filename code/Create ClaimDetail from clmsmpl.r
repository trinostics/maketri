# Create ClaimDetail from clmsmpl.r
x <- read.csv("..\\data\\clmsmpl.csv", header=TRUE, stringsAsFactors = FALSE)
ls(x)

# Create a 'claimno' field equals index of sorted claimid's.
clmIDs <- unique(x$claimid)
clmIDs <- sort(clmIDs)
class(clmIDs)
clmindex <- seq_along(clmIDs) 
claimno <- structure(sprintf("clm%05.0f", clmindex), names = clmIDs)
x$claimno <- claimno[as.character(x$claimid)] 

# Rename some columns
#names(x)[which(names(x) == "directlossincurred")] <- "lossincurred"
#names(x)[which(names(x) == "directlosspaid")] <- "losspaid"

# Recalc some columns. In SP2, 'loss' is 'indemnity'
x$lossincd <- x$directlossincurred + x$directexpenseincurred
x$losspaid <- x$directlosspaid + x$directexpensepaid

# get rid of zero-dollar claims
x <- subset(x, lossincd != 0)

# Trim old AYs
x <- subset(x, ay %in% 1999:2013)

# Hang on to these for copying into app later
#x$ay <- year(as.Date(x$lossdate)) # , format = "%m/%d/%Y"))
#table(x$ay)

#x$age.ay <- mondate(x$eval_dt) - mondate.ymd(x$ay - 1) # assume last day of 
#x$age    <- mondate(x$eval_dt) - mondate.ymd(x$lossdate) + 1

outx <- data.frame(
  eval_dt = x$eval_dt
  , claimno = x$claimno
  , lossdate = x$lossdate
  , indemnitypaid = x$directlosspaid
  , indemnityincd = x$directlossincurred
  , expensepaid = x$directexpensepaid
  , expenseincd = x$directexpenseincurred
  , losspaid = x$losspaid
  , lossincd = x$lossincd
  , openclosed = x$ocstatus
)
sum(outx$lossincd == 0)

write.csv(outx, file = "..\\data\\ClaimDetail.csv")#, col.names = TRUE)
# Then open the csv file in excel and name the first column 'recno'