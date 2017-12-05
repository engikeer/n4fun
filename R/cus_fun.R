format_difftime <- function(difftime) {
    if (class(difftime) != "difftime") {
        stop("input must be difftime")
    }
    
    num <- as.numeric(difftime, units = "secs")
    ifelse(num >= 0,
           paste(num %/% 3600, num %% 3600 %/% 60, floor(num %% 60), sep = ":"),
           paste0("-", paste(-num %/% 3600, -num %% 3600 %/% 60, floor(-num %% 60), sep = ":")))
}
