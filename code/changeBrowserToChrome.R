options(browser = "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe")
options(shiny.maxRequestSize=30*1024^2)
# clear out C:\Users\Dan\AppData\Local\Temp\RtmpYx3aVc/7edb24d09d40f4233ce595b5/0
# per https://groups.google.com/forum/#!topic/shiny-discuss/fHshZgc0yJg
# it created a temporary folder within the temp folder of your current session of R. When R closes the temp folder is deleted. 
# AS LONG AS R/RSTUDIO CLOSE NORMALLY, THIS IS TRUE.
# BUT IF R/RSTUDIO CRASHES, THE Rtmp... folder under Temp may not be deleted