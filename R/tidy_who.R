library(tidyverse)
library(stringr)

View(who)

# 整理过程----------
# country、iso2、iso3是三个含义相同的冗余变量，移除iso2与iso3
cache <- who %>%
    select(-(iso2:iso3))

# new_sp_m014至newrel_f65更像变量值而不是变量名，所以将其聚集为key、value
cache <- cache %>%
    gather("key", "value", new_sp_m014:newrel_f65)

# 移除值为NA的行，聚焦于没有缺失值的数据
cache <- na.omit(cache)

# 根据文档，value实际代表病例数，所以将其重命名为cases
cache <- cache %>%
    rename(cases = value)

# 查询文档，第一个单词代表新病例（new）或老病例（old）
# 第二个单词代表结核病类型：rel（复发）、ep（肺外结核）、sn（涂测阴性）、sp（涂测阳性）
# 第三个单词代表患者性别：f（女）、m（男）
# 剩余数字代表患者年龄段

# 但数据中存在new_sp_m014与newrel_m014两种格式，将“newrel”替换为“new_rel”
cache <- cache %>%
    mutate(key = str_replace(key, "newrel", "new_rel"))

# 先将key列通过“_”分割为3列
cache <- cache %>%
    separate(key, into = c("new", "type", "sexage"))

# new列的值是恒定的，所以为冗余变量，将其移除
cache <- cache %>%
    select(-new)

# 然后将sexage根据位置分割为两列
cache <- cache %>%
    separate(sexage, into = c("sex", "age"), sep = 1)

# 整理代码------------

tidy_who <- who %>%
    gather("key", "cases", new_sp_m014:newrel_f65, na.rm = TRUE) %>%
    mutate(key = str_replace(key, "newrel", "new_rel")) %>%
    separate(key, into = c("new", "type", "sexage"), sep = "_") %>%
    select(-iso2, -iso3, -new) %>%
    separate(sexage, into = c("sex", "age"), sep = 1)

tidy_who
