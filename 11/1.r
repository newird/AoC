install.packages("gmp", repos="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
library(gmp)

content = file("1.in", "r")
line <- readLines(content , n = 1)
arr <- scan(text = line , what = integer(), quiet= TRUE)

tmp <- list()

len <- function(x) {
  if(x == 0) return(1)
  return(floor(log10(abs(x))) + 1)
}

mem <- new.env(hash = TRUE, parent = emptyenv())

make_key <- function(x, time) {
  paste(x, time, sep = ",")
}

dfs <- function(x, time) {
  key <- make_key(x, time)

  if (exists(key, envir = mem, inherits = FALSE)) {
    return(get(key, envir = mem))
  }

  if (time == 0) {
    assign(key, 1, envir = mem)
    return(1)
  }

  if (x == 0) {
    result <- dfs(1, time - 1)
  } else {
    n_str <- as.character(x)
    total_length <- nchar(n_str)

    if (total_length %% 2 == 0) {
      n_str <- as.character(x)
      total_length <- nchar(n_str)
      total_length = len(x)
      half_length <- total_length / 2
      b <- as.numeric(substr(n_str, (half_length + 1), total_length))
      a <- as.numeric(substr(n_str, 1, half_length))
      result <- dfs(a, time - 1) + dfs(b, time - 1)
    } else {
      result <- dfs(x * 2024, time - 1)
    }
  }


  assign(key, result, envir = mem)
  return(result)
}

# part 1
ans <- 0
for (n  in arr ) {
  ans <- ans + dfs(n , 25)
}
print(ans)

# part 2
ans <-as.bigz("0")
for (n  in arr ) {
  ans <- ans + dfs(n , 75)
}
print(ans)
