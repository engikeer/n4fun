library(tidyverse)
library(nycflights13)

filter(flights, (month >= 11 & day <29) | (month < 11 & day > 29))
df <- tibble(x = c(5, 2, NA), y = c(TRUE, TRUE, FALSE))
df %>% 
    arrange(desc())

select(df, -y)

?everything
?summarise

(var <- quo(mean(cyl)))
summarise(mtcars, !! var)

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)

nycflights13::flights %>% 
    mutate(
        cancelled = is.na(dep_time),
        sched_hour = sched_dep_time %/% 100,
        sched_min = sched_dep_time %% 100,
        sched_dep_time = sched_hour + sched_min / 60
    ) %>% 
    ggplot(mapping = aes(sched_dep_time)) + 
    geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)

test <- tribble(
    ~name, ~age, ~gender,
    #---|-----|------
    "Tom", 11, "male",
    "Mary", 10, "female" 
)
