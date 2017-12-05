# install.packages(c("tidyverse", "dbplyr"))
library(dplyr)

# dplyr------------
con <- DBI::dbConnect(RSQLite::SQLite(), dbname = "data/demo.db")

copy_to(con, nycflights13::flights, "flights",
        temporary = FALSE, 
        indexes = list(
            c("year", "month", "day"), 
            "carrier", 
            "tailnum",
            "dest"
        )
)

flights_db <- tbl(con, "flights")


tailnum_delay_db <- flights_db %>% 
    group_by(tailnum) %>%
    summarise(
        delay = mean(arr_delay),
        n = n()
    ) %>% 
    arrange(desc(delay)) %>%
    filter(n > 100)

DBI::dbDisconnect(con)

# DBI----------
con <- dbConnect(RSQLite::SQLite(), dbname = ":memory:")

dbListTables(con)

dbWriteTable(con, "mtcars", mtcars)

dbListTables(con)

dbListFields(con, "mtcars")

dbReadTable(con, "mtcars")

res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")

dbFetch(res)

dbClearResult(res)

res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
while(!dbHasCompleted(res)){
    chunk <- dbFetch(res, n = 5)
    print(nrow(chunk))
}

dbClearResult(res)

dbDisconnect(con)

# 连接池--------
library(shiny)
library(dplyr)
library(pool)

pool <- dbPool(
    drv = RMySQL::MySQL(),
    dbname = "shinydemo",
    host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
    username = "guest",
    password = "guest"
)
onStop(function() {
    poolClose(pool)
})

ui <- fluidPage(
    textInput("ID", "Enter your ID:", "5"),
    tableOutput("tbl"),
    numericInput("nrows", "How many cities to show?", 10),
    plotOutput("popPlot")
)

server <- function(input, output, session) {
    output$tbl <- renderTable({
        pool %>% tbl("City") %>% filter(ID == input$ID) %>% collect()
    })
    output$popPlot <- renderPlot({
        df <- pool %>% tbl("City") %>% head(input$nrows) %>% collect()
        pop <- df$Population
        names(pop) <- df$Name
        barplot(pop)
    })
}

shinyApp(ui, server)

# 查询时的安全------
airport_code <- "GPT' or faa = 'MSY"

sql <- sqlInterpolate(con, 
                      "SELECT * FROM airports  where faa = ?code", 
                      code = airport_code
)
sql

sql <- paste0("SELECT * FROM airports WHERE faa = '", airport_code ,"'")
sql

# 创建可视化对象----------
library(rlang)
db_bin <- function(var, bins = 30, binwidth = NULL) {
    var <- enexpr(var)
    
    range <- expr(max(!!var) - min(!!var))
    
    if(is.null(binwidth)){
        binwidth <- expr((!!range) / (!!bins))
    } else {
        bins <- expr(as.integer((!!range) / (!!binwidth)))
    }
    
    # Made more sense to use floor() to determine the bin value than
    # using the bin number or the max or mean, feel free to customize
    bin_number <- expr(as.integer(floor(((!!var) - min(!!var)) / (!!binwidth))))
    
    # Value(s) that match max(x) will be rebased to bin -1, giving us the exact number of bins requested
    expr(((!!binwidth) *
              ifelse((!!bin_number) == (!!bins), (!!bin_number) - 1, (!!bin_number))) + min(!!var))
    
}
