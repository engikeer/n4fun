library(tidyverse)
library(DBI)
library(DT)

# 参数设置-------------------------
path = ""
encodeing = ""

# 业务代码-------------------------
con <- dbConnect(RMySQL::MySQL(), host = "127.0.0.1", port = 3306, dbname = "mmdata", username = "root", password = "")
# 设置编码
dbGetQuery(con,"show variables like 'character_set_%'")
dbSendQuery(con, "SET NAMES utf8")
actress <- dbReadTable(con, "actress")
datatable(actress)
write_csv(actress, "data/actress.csv")

actress_copy <- read_csv("data/actress.csv",
                         locale = locale(encoding = "utf-8"),
                         col_types = cols(
                             act_birthday = col_date()
                         ))
str(actress_copy)

dbWriteTable(con, "actress_copy", actress_copy, row.names = FALSE)

dbDisconnect(con)
