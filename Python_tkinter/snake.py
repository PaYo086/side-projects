from tkinter import *
from copy import deepcopy
from random import choice
from time import sleep

GAME_WIDTH = 700
GAME_HEIGHT = 700
SPEED = 50
SPACE_SIZE = 50
BODY_PARTS = 3
SNAKE_COLOR = "#00FF00"
FOOD_COLOR = "#FF0000"
BACKGROUND_COLOR = "#000000"

class Snake:
    def __init__(self):
        self.body_size = BODY_PARTS
        self.coordinates = []
        self.squares = []
        
        for i in range(BODY_PARTS):
            self.coordinates.append([0, 0])
        
        for x, y in self.coordinates:
            square = canvas.create_rectangle(x, y, x+SPACE_SIZE, y+SPACE_SIZE, fill=SNAKE_COLOR, tags="snake")
            self.squares.append(square)

class Food:
    def __init__(self):
        global snake, spaces
        
        empty_spaces = deepcopy(spaces)
        for i, j in snake.coordinates:
            if str(int(i/SPACE_SIZE)) + "-" + str(int(j/SPACE_SIZE)) in empty_spaces:
                empty_spaces.remove(str(int(i/SPACE_SIZE)) + "-" + str(int(j/SPACE_SIZE)))
        
        xy = choice(empty_spaces).split("-")
        x = int(xy[0])*SPACE_SIZE
        y = int(xy[1])*SPACE_SIZE
        
        self.coordinate = [x, y]
        canvas.create_oval(x, y, x+SPACE_SIZE, y+SPACE_SIZE, fill=FOOD_COLOR, tag="food")

def next_turn(snake, food):
    x, y = snake.coordinates[0]
    
    if direction == "up":
        y -= SPACE_SIZE
    elif direction == "down":
        y += SPACE_SIZE
    elif direction == "left":
        x -= SPACE_SIZE
    elif direction == "right":
        x += SPACE_SIZE
    
    snake.coordinates.insert(0, (x, y))
    
    square = canvas.create_rectangle(x, y, x+SPACE_SIZE, y+SPACE_SIZE, fill=SNAKE_COLOR, tags="snake")
    snake.squares.insert(0, square)
    
    if not(x == food.coordinate[0] and y == food.coordinate[1]):
        del snake.coordinates[-1]
        canvas.delete(snake.squares[-1])
        del snake.squares[-1]
    else:
        global score
        
        score += 1
        label.config(text="Score:{}".format(score))
        canvas.delete("food")
        food = Food()
    
    if check_collisions(snake):
        game_over()
    else:
        window.after(SPEED, next_turn, snake, food)

def change_direction(new_direction):
    global direction
    
    if new_direction == "up" and direction != "down":
        direction = new_direction
    elif new_direction == "down" and direction != "up":
        direction = new_direction
    elif new_direction == "left" and direction != "right":
        direction = new_direction
    elif new_direction == "right" and direction != "left":
        direction = new_direction

def check_collisions(snake):
    x, y = snake.coordinates[0]
    
    if x < 0 or x >= GAME_WIDTH:
        return True
    if y < 0 or y >= GAME_HEIGHT:
        return True
    
    for body_part in snake.coordinates[1:]:
        if x == body_part[0] and y == body_part[1]:
            return True
    
    return False

def game_over():
    canvas.create_text(canvas.winfo_width()/2, canvas.winfo_height()/2, font=('consolas',72), text="GAME OVER", fill="white", tag="gameover", tags="game_over")
    canvas.create_text(canvas.winfo_width()/2, canvas.winfo_height()/2+80, font=('consolas',32), text="Press any key to play again", fill="white", tag="game_over", tags="game_over")
    
    window.unbind("<Up>")
    window.unbind("<Down>")
    window.unbind("<Left>")
    window.unbind("<Right>")
    window.update()
    sleep(0.5)
    
    window.bind("<Key>",lambda event: play_again(event))

def play_again(event):
    global snake, food, score, direction
    
    canvas.delete(ALL)
    score = 0
    label.config(text="Score:{}".format(score))
    snake = Snake()
    food = Food()
    direction = "down"

    window.unbind("<Key>")
    window.bind("<Up>", lambda event: change_direction("up"))
    window.bind("<Down>", lambda event: change_direction("down"))
    window.bind("<Left>", lambda event: change_direction("left"))
    window.bind("<Right>", lambda event: change_direction("right"))

    next_turn(snake, food)


window = Tk()
window.title("Snake game")
window.resizable(False, False)

score = 0
direction = "down"

spaces = []
for i in range(int(GAME_WIDTH/SPACE_SIZE)):
    for j in range(int(GAME_HEIGHT/SPACE_SIZE)):
        spaces.append(str(i) + "-" + str(j))

label = Label(window, text="Score:{}".format(score), font=("consolas", 40))
label.pack()

canvas = Canvas(window, bg=BACKGROUND_COLOR, height=GAME_HEIGHT, width=GAME_WIDTH)
canvas.pack()

window.update()
window_width = window.winfo_width()
window_height = window.winfo_height()
screen_width = window.winfo_screenwidth()
screen_height = window.winfo_screenheight()
x = int((screen_width/2) - (window_width/2))
y = int((screen_height/2) - (window_height/2))
window.geometry(f"{window_width}x{window_height}+{x}+{y}")

window.bind("<Up>", lambda event: change_direction("up"))
window.bind("<Down>", lambda event: change_direction("down"))
window.bind("<Left>", lambda event: change_direction("left"))
window.bind("<Right>", lambda event: change_direction("right"))

snake = Snake()
food = Food()

next_turn(snake, food)

window.mainloop()
