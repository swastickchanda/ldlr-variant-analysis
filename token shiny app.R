install.packages("rsconnect")
library(rsconnect)
rsconnect::setAccountInfo(name='swastick',
                          token='4F102E7CB4AF66AB2236DE6C017653F7',
                          secret='0HIiTNXrlfF/+tHLs2l8vZewzwQ51IO1JnI9Is3x')
rsconnect::deployApp()
