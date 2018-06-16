# S3----------------
# 泛型函数
eat <- function(x) {
    UseMethod("eat")
}

eat.default <- function(x) {
    "Default eating."
}
# 父类
eat.animal <- function(x) {
    paste(attr(x, "name"), "is a animal, don't know what it eats.")
}

# 子类
eat.dog <- function(x) {
    paste(attr(x, "name"), "is a dog, it eats meats.")
}

eat.cat <- function(X) {
    paste(attr(x, "name"), "is a cat, it eats fish.")
}

x <- structure(1:5, class = "cat", name = "Tom")
y <- structure(1:5, class = "dog", name = "Mat")

eat(x)
eat(y)

z <- 1:5

eat(z)

# S4---------------------

# 创建类
tt <- setClass("Animal",
         slots = list(name = "character"))
setClass("Cat",
         contains = "Animal")
setClass("Dog",
         contains = "Animal")
tom <- new("Cat", name = "Tom")
mat <- new("Dog", name = "Mat")

# 创建泛型函数
setGeneric("eat",
           function(x) {
               standardGeneric("eat")
           },
           valueClass = "character")

# 添加方法
setMethod("eat",
          signature = signature(x = "Cat"),
          function(x) {
              paste(x@name, "is a cat, it eats fish.")
          })

setMethod("eat",
          signature(x = "Dog"),
          function(x) {
              paste(x@name, "is a dog, it eats meat.")
          })

setGeneric("getAge",
           function(x, age) {
               standardGeneric("getAge")
           })
setMethod("getAge",
          signature(x = "Dog"),
          function(x, age) {
              paste(x@name, "is a dog,", "it's", age)
          })

setMethod("union",
          signature(x = "data.frame"),
          function(x, y) {
              unique(rbind(x, y))
          })

# RC类-------------
# 创建类
Animal <- setRefClass("Animal",
                      fields = list(name = "character"),
                      methods = list(
                          eat = function() {
                              paste(name, "is a animal, don't know what it eats.")
                          }
                      ))
Dog <- setRefClass("Dog",
                   contains = "Animal",
                   methods = list(
                       eat = function() {
                           paste(name, "is a dog, it eats meat.")
                       }
                   ))
Cat <- setRefClass("Cat",
                   contains = "Animal",
                   methods = list(
                       eat = function() {
                           paste(name, "is a cat, it eats fish.")
                       }
                   ))
# 生成对象
mat <- Dog$new(name = "Mat")
tom <- Cat$new(name = "Tom")

mat$eat()
mat$`eat#Animal`()
tom$eat()
