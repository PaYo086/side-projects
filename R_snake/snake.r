##### Snake animation #####
animated.snake <- function(snake.length = 3, square.size = 20, no.step = 0, speed = 300, mode = "shortest", color = "heat"){
  ##############################
  ## Description of arguments ##
  ##############################
  # snake.length: The length of snake
  # square.size: The size of playground
  # no.step: The number of step. If no.step = 0, then it runs till game over.
  # speed: How fast the snake is.
  # mode: How snake acts. Three modes: "random", "clockwise", "shortest".
  # color: The color of snake. "heat", "topo", "cm", "rainbow", or select the palletes from hcl.colors() (e.g., "hcl.Blues 3").
  ##############################
  col.fun <- function(color, snake.length){ # select colors
    if (color == "heat") return(c(heat.colors(snake.length, rev = T), "white", "black"))
    else if (color == "terrain") return(c(terrain.colors(snake.length, rev = T), "white", "black"))
    else if (color == "topo") return(c(topo.colors(snake.length, rev = T), "white", "black"))
    else if (color == "cm") return(c(cm.colors(snake.length, rev = T), "white", "black"))
    else if (color == "rainbow") return(c(rainbow(snake.length, s = 0.5, rev = T), "white", "black"))
    else{ # hcl.colors()
      return(c(hcl.colors(snake.length, palette = strsplit(color, split = ".", fixed = T)[[1]][2], rev = T), "white", "black"))
    }
  }
  # initiate -----
  # ----
  snake <- matrix(NA, ncol = 2, nrow = snake.length)
  snake[1,] <- c(round(square.size/3), round(square.size/5))
  for (i in 2:snake.length){
    snake[i,] <- snake[i-1,] + c(1,0)
  }
  body <- paste(snake[,1], snake[,2], sep = "-")
  fd <- outer(0:square.size, 0:square.size, paste, sep = "-")
  food <- unlist(strsplit(sample(fd[!fd %in% body], 1), split = "-"))
  food <- as.numeric(c(food[1], food[2]))
  eat.food <- FALSE
  
  snake.food <- rbind(food, snake[1,], snake)
  colors <- col.fun(color = color, snake.length = snake.length)
  pch <- c(rep(15, times = snake.length), 16, 16)
  cex <- c(rep(62/square.size, times = snake.length), 15/square.size, 28/square.size)
  
  plot(snake.food[c(nrow(snake.food):1),], xlim = c(0, square.size), ylim = c(0, square.size), pch = pch, col = colors, cex = cex, ann = F, asp = 1, xaxt = "n", yaxt = "n")
  Sys.sleep(20/speed)
  
  # move -----
  # ----
  next.step <- matrix(c(0,1,0,-1,-1,0,1,0, 0, 0), ncol = 2, byrow = T)
  rownames(next.step) <- c("up", "down", "left", "right", "stop")
  clock_dir <- "left"
  if (no.step == 0){
    inf <- TRUE
  } else{
    inf <- FALSE
  }
  i <- 1
  while (i <= no.step | inf){
    i <- i + 1
    nt <- next.step
    # enlarge body size or not?
    # ----
    if (eat.food) {
      # check the coord for food.
      body <- c(body, paste(food, collapse = "-"))
      if (sum(!fd %in% body) == 0){
        snake.food <- rbind(snake[1,], snake)
        plot(snake.food[c(nrow(snake.food):1),], xlim = c(0, square.size), ylim = c(0, square.size), pch = pch, col = colors, cex = cex, ann = F, asp = 1, xaxt = "n", yaxt = "n")
        title(main = "The snake is full :)")
        break
      }
      # change food coord.
      food <- unlist(strsplit(sample(fd[!fd %in% body], 1), split = "-"))
      food <- as.numeric(c(food[1], food[2]))
      snake.food <- rbind(food, snake[1,], snake)
      plot(snake.food[c(nrow(snake.food):1),], xlim = c(0, square.size), ylim = c(0, square.size), pch = pch, col = colors, cex = cex, ann = F, asp = 1, xaxt = "n", yaxt = "n")
      Sys.sleep(20/speed)
      # for the next 
      snake <- rbind(snake, c(0,0))
      snake[-1,] <- snake[-nrow(snake),]
      snake.length <- snake.length + 1
      colors <- col.fun(color = color, snake.length = snake.length)
      pch <- c(rep(15, times = snake.length), 16, 16)
      cex <- c(rep(62/square.size, times = snake.length), 15/square.size, 28/square.size)
      eat.food <- FALSE
      body <- paste(snake[-1,1], snake[-1,2], sep = "-")
    } else {
      snake[-1,] <- snake[-nrow(snake),]
      body <- paste(snake[-1,1], snake[-1,2], sep = "-")
    }
    
    # random ----
    if (mode == "random"){
      # boundary & body
      # body <- str_c(snake[-1,1], snake[-1,2], sep = "-")
      if ((snake[2,2] >= square.size) | (paste(snake[2,1], snake[2,2]+1, sep = "-") %in% body)) nt <- nt[rownames(nt) != "up",] # up
      if ((snake[2,2] <= 0) | (paste(snake[2,1], snake[2,2]-1, sep = "-") %in% body)) nt <- nt[rownames(nt) != "down",] # down
      if ((snake[2,1] <= 0) | (paste(snake[2,1]-1, snake[2,2], sep = "-") %in% body)) nt <- nt[rownames(nt) != "left",] # left
      if ((snake[2,1] >= square.size) | (paste(snake[2,1]+1, snake[2,2], sep = "-") %in% body)) nt <- nt[rownames(nt) != "right",] # right
      # no way
      if (is.null(nrow(nt))) {title(main = "No way to go :("); break}
      snake[1,] <- snake[2,] + nt[sample(1:(nrow(nt)-1), 1),]
    }

    
    # full ----
    else if (mode == "full"){
      print("No idea for odd size...")
    }
    
    # clockwise ----
    else if (mode == "clockwise"){
      clock_count <- 0
      while (TRUE){
        # just food
        if (clock_count == 1){
          if (clock_dir == "left"){ # check left
            if ((snake[2,1] <= 0) | (paste(snake[2,1]-1, snake[2,2], sep = "-") %in% body)) {clock_dir <- "up"; clock_count <- clock_count + 1} # not go left
            else {nt <- nt[clock_dir,]; break}
          }
          else if (clock_dir == "up"){ # check up
            if ((snake[2,2] >= square.size) | (paste(snake[2,1], snake[2,2]+1, sep = "-") %in% body)) {clock_dir <- "right"; clock_count <- clock_count + 1} # not go up
            else {nt <- nt[clock_dir,]; break}
          }
          else if (clock_dir == "right"){ # check right
            if ((snake[2,1] >= square.size) | (paste(snake[2,1]+1, snake[2,2], sep = "-") %in% body)) {clock_dir <- "down"; clock_count <- clock_count + 1} # not go right
            else {nt <- nt[clock_dir,]; break}
          }
          else if (clock_dir == "down"){ # check down
            if ((snake[2,2] <= 0) | (paste(snake[2,1], snake[2,2]-1, sep = "-") %in% body)) {clock_dir <- "left"; clock_count <- clock_count + 1} # not go down
            else {nt <- nt[clock_dir,]; break}
          }
        }
        else if (clock_count == 2){ # just food (different from previous), can't turn right
          if (clock_dir == "left"){ # check right
            if ((snake[2,1] >= square.size) | (paste(snake[2,1]+1, snake[2,2], sep = "-") %in% body)) {clock_dir <- "up"; clock_count <- clock_count + 1} # not go right, turn left?
            else {clock_dir <- "right"; nt <- nt[clock_dir,]; break}
          }
          else if (clock_dir == "up"){ # check down
            if ((snake[2,2] <= 0) | (paste(snake[2,1], snake[2,2]-1, sep = "-") %in% body)) {clock_dir <- "right"; clock_count <- clock_count + 1} # not go down, turn left?
            else {clock_dir <- "down"; nt <- nt[clock_dir,]; break}
          }
          else if (clock_dir == "right"){ # check left
            if ((snake[2,1] <= 0) | (paste(snake[2,1]-1, snake[2,2], sep = "-") %in% body)) {clock_dir <- "down"; clock_count <- clock_count + 1} # not go left, turn left?
            else {clock_dir <- "left"; nt <- nt[clock_dir,]; break}
          }
          else if (clock_dir == "down"){ # check up
            if ((snake[2,2] >= square.size) | (paste(snake[2,1], snake[2,2]+1, sep = "-") %in% body)) {clock_dir <- "left"; clock_count <- clock_count + 1} # not go up, turn left?
            else {clock_dir <- "up"; nt <- nt[clock_dir,]; break}
          }
        }
        else if (clock_count == 3){ # can't turn right, so turn left?
          if (clock_dir == "left"){ # check left
            if ((snake[2,1] <= 0) | (paste(snake[2,1]-1, snake[2,2], sep = "-") %in% body)) {clock_count <- clock_count + 1; break} # not go left
            else {nt <- nt[clock_dir,]; break}
          }
          else if (clock_dir == "up"){ # check up
            if ((snake[2,2] >= square.size) | (paste(snake[2,1], snake[2,2]+1, sep = "-") %in% body)) {clock_count <- clock_count + 1; break} # not go up
            else {nt <- nt[clock_dir,]; break}
          }
          else if (clock_dir == "right"){ # check right
            if ((snake[2,1] >= square.size) | (paste(snake[2,1]+1, snake[2,2], sep = "-") %in% body)) {clock_count <- clock_count + 1; break} # not go right
            else {nt <- nt[clock_dir,]; break}
          }
          else if (clock_dir == "down"){ # check down
            if ((snake[2,2] <= 0) | (paste(snake[2,1], snake[2,2]-1, sep = "-") %in% body)) {clock_count <- clock_count + 1; break} # not go down
            else {nt <- nt[clock_dir,]; break}
          }
        }
        else{
          if (clock_dir == "left"){ # check left
            if ((snake[2,1] <= 0) | (paste(snake[2,1]-1, snake[2,2], sep = "-") %in% body) | (snake[2,1] == food[1] & snake[2,2] < food[2])) {clock_dir <- "up"; clock_count <- clock_count + 1} # not go left
            else {nt <- nt[clock_dir,]; break}
          }
          else if (clock_dir == "up"){ # check up
            if ((snake[2,2] >= square.size) | (paste(snake[2,1], snake[2,2]+1, sep = "-") %in% body) | (snake[2,2] == food[2] & snake[2,1] < food[1])) {clock_dir <- "right"; clock_count <- clock_count + 1} # not go up
            else {nt <- nt[clock_dir,]; break}
          }
          else if (clock_dir == "right"){ # check right
            if ((snake[2,1] >= square.size) | (paste(snake[2,1]+1, snake[2,2], sep = "-") %in% body) | (snake[2,1] == food[1] & snake[2,2] > food[2])) {clock_dir <- "down"; clock_count <- clock_count + 1} # not go right
            else {nt <- nt[clock_dir,]; break}
          }
          else if (clock_dir == "down"){ # check down
            if ((snake[2,2] <= 0) | (paste(snake[2,1], snake[2,2]-1, sep = "-") %in% body) | (snake[2,2] == food[2] & snake[2,1] > food[1])) {clock_dir <- "left"; clock_count <- clock_count + 1} # not go down
            else {nt <- nt[clock_dir,]; break}
          }
        }
      }
      if (clock_count == 4) {title(main = "No way to go :("); break}
      snake[1,] <- snake[2,] + nt
    }
    
    # shortest ----
    else if (mode == "shortest"){
      if (food[1] > snake[2,1]){ # food in right
        if ((!paste(snake[2,1]+1, snake[2,2], sep = "-") %in% body) & (snake[2,1] < square.size)) nt <- nt["right",] # can go right
        else if (food[2] <= snake[2,2]){ # can't go right, food in down
          if ((!paste(snake[2,1], snake[2,2]-1, sep = "-") %in% body) & (snake[2,2] > 0)) nt <- nt["down",] # can go down
          else if ((!paste(snake[2,1], snake[2,2]+1, sep = "-") %in% body) & (snake[2,2] < square.size)) nt <- nt["up",] # cna't go right and down, so go up
          else if ((!paste(snake[2,1]-1, snake[2,2], sep = "-") %in% body) & (snake[2,1] > 0)) nt <- nt["left",] # can't go right, down and up, so go left
          else {title(main = "No way to go :("); break} # stuck!!!
        }
        else{ # can't go right, food in up
          if ((!paste(snake[2,1], snake[2,2]+1, sep = "-") %in% body) & (snake[2,2] < square.size)) nt <- nt["up",] # can go up
          else if ((!paste(snake[2,1], snake[2,2]-1, sep = "-") %in% body) & (snake[2,2] > 0)) nt <- nt["down",] # can't go right and up, so go down
          else if ((!paste(snake[2,1]-1, snake[2,2], sep = "-") %in% body) & (snake[2,1] > 0)) nt <- nt["left",] # can't go right, up and down, so go left
          else {title(main = "No way to go :("); break} # stuck!!!
        }
      }
      else if (food[1] < snake[2,1]){ # food in left
        if ((!paste(snake[2,1]-1, snake[2,2], sep = "-") %in% body) & (snake[2,1] > 0)) nt <- nt["left",] # can go left
        else if (food[2] <= snake[2,2]){ # can't go left, food in down
          if ((!paste(snake[2,1], snake[2,2]-1, sep = "-") %in% body) & (snake[2,2] > 0)) nt <- nt["down",] # can go down
          else if ((!paste(snake[2,1], snake[2,2]+1, sep = "-") %in% body) & (snake[2,2] < square.size)) nt <- nt["up",] # can't go left and down, so go up
          else if ((!paste(snake[2,1]+1, snake[2,2], sep = "-") %in% body) & (snake[2,1] < square.size)) nt <- nt["right",] # can't go left, down and up, so go right
          else {title(main = "No way to go :("); break} # stuck!!!
        }
        else{ # can't go left, food in up
          if ((!paste(snake[2,1], snake[2,2]+1, sep = "-") %in% body) & (snake[2,2] < square.size)) nt <- nt["up",] # can go up
          else if ((!paste(snake[2,1], snake[2,2]-1, sep = "-") %in% body) & (snake[2,2] > 0)) nt <- nt["down",] # can't go left and up, so go down
          else if ((!paste(snake[2,1]+1, snake[2,2], sep = "-") %in% body) & (snake[2,1] < square.size)) nt <- nt["right",] # can't go left, up and down, so go right
          else {title(main = "No way to go :("); break} # stuck!!!
        }
      }
      else if (food[2] < snake[2,2]){ # food in just down (include initial food coord)
        if ((!paste(snake[2,1], snake[2,2]-1, sep = "-") %in% body) & (snake[2,2] > 0)) nt <- nt["down",] # can go down
        else if ((!paste(snake[2,1]-1, snake[2,2], sep = "-") %in% body) & (snake[2,1] > 0)) nt <- nt["left",] # can't go down and right, so go left
        else if ((!paste(snake[2,1]+1, snake[2,2], sep = "-") %in% body) & (snake[2,1] < square.size)) nt <- nt["right",] # can't go down, so go right
        else if ((!paste(snake[2,1], snake[2,2]+1, sep = "-") %in% body) & (snake[2,2] < square.size)) nt <- nt["up",] # can't go down, right and left, so go up
        else {title(main = "No way to go :("); break} # stuck!!!
      }
      else{ # food in just up
        if ((!paste(snake[2,1], snake[2,2]+1, sep = "-") %in% body) & (snake[2,2] < square.size)) nt <- nt["up",] # can go up
        else if ((!paste(snake[2,1]-1, snake[2,2], sep = "-") %in% body) & (snake[2,1] > 0)) nt <- nt["left",] # can't go up and right, so go left
        else if ((!paste(snake[2,1]+1, snake[2,2], sep = "-") %in% body) & (snake[2,1] < square.size)) nt <- nt["right",] # can't go up, so go right
        else if ((!paste(snake[2,1], snake[2,2]-1, sep = "-") %in% body) & (snake[2,2] > 0)) nt <- nt["down",] # can't go up, right and left, so go down
        else {title(main = "No way to go :("); break} # stuck!!!
      }
      snake[1,] <- snake[2,] + nt
    }
    
    # eat food or not?
    # ----
    if ((snake[1,1] == food[1]) & (snake[1,2] == food[2])){ # eat food!
      eat.food <- TRUE
    } else{
      snake.food <- rbind(food, snake[1,], snake)
      plot(snake.food[c(nrow(snake.food):1),], xlim = c(0, square.size), ylim = c(0, square.size), pch = pch, col = colors, cex = cex, ann = F, asp = 1, xaxt = "n", yaxt = "n")
      Sys.sleep(20/speed)
    }
  }
}


windows()
repeat({
  mode <- sample(c("shortest", "clockwise", "random"), size = 1)
  if (mode == "shortest"){no.step <- 0; speed <- 800}
  else if (mode == "clockwise"){no.step <- 0; speed <- 900}
  else {no.step <- 1000; speed <- 1000}
  color <- sample(c("heat", "terrain", "topo", "cm", paste("hcl", hcl.pals(), sep = ".")), size = 1)
  animated.snake(color = color, snake.length = 2, square.size = 20, speed = speed, mode = mode, no.step = no.step)
  Sys.sleep(2)
})

# install.packages ('animation')
# library(animation) 
# ani.options(convert = "c:\\Program Files\\ImageMagick-7.0.8-Q16\\convert.exe")
# ani.options(interval = 0.05)
# saveGIF(animated.snake(snake.length = 12, no.step = 160, square.size = 30, speed = 0), movie.name = "D:\\6111\\TA_REcol\\snake.gif")