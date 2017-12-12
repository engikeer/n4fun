# 将时间间隔换为时:分:秒------------
format_difftime <- function(difftime) {
    if (class(difftime) != "difftime") {
        stop("input must be difftime")
    }
    
    num <- as.numeric(difftime, units = "secs")
    ifelse(num >= 0,
           paste(num %/% 3600, num %% 3600 %/% 60, floor(num %% 60), sep = ":"),
           paste0("-", paste(-num %/% 3600, -num %% 3600 %/% 60, floor(-num %% 60), sep = ":")))
}

# 从数据框选出，所有变量的可能组合，以6个变量为例-------
# 示例数据
test <- data.frame(num1 = "A", num2 = "B", num3 = "C", num4 = "D", num5 = "E", num6 = "F")

# 得到所有变量组合的序号
nd <- data.frame(num = 2:6)
col_list <- map(nd$num, ~t(combn(1:6, .)))

# 取出对应的变量作为列表的一个元素
result <- list()
for (num_matrix in col_list) {
    buffer <- list()
    for (i in seq_len(nrow(num_matrix))) {
        buffer[[i]] <- test[num_matrix[i, ]]
    }
    result <- c(result, buffer)
}

# 最终结果
result