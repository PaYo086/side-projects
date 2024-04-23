from tkinter import *

cal_express = ""
pre_button = ""
dot_tf = True

def display(s):
    global cal_express, pre_button, dot_tf
    
    if pre_button == "" and s in ("+", "*", "/"):
        cal_express = cal_express
        screen.config(text = cal_express)
    elif pre_button in ("+", "-", "*", "/", ".") and s in ("+", "-", "*", "/"):
        cal_express = cal_express
        screen.config(text = cal_express)
    elif not dot_tf and s == ".":
        cal_express = cal_express
        screen.config(text = cal_express)
    else:
        if s in ("+", "-", "*", "/"):
            dot_tf = True
        elif s == ".":
            dot_tf = False
        pre_button = s
        cal_express = cal_express + s
        screen.config(text = cal_express)
    
    print(cal_express, pre_button, dot_tf)

def clear():
    global  cal_express, pre_button, dot_tf
    
    cal_express = ""
    pre_button = ""
    dot_tf = True
    screen.config(text = cal_express)

def calculate():
    global cal_express, pre_button, dot_tf
    
    try:
        temp = cal_express
        cal_express = str(eval(cal_express))
        if temp != cal_express:
            pre_button = cal_express[-1]
            dot_tf = True
        screen.config(text = cal_express)
        
        print(cal_express, pre_button, dot_tf)
    except ZeroDivisionError:
        screen.config(text = "arithmetic error")
        cal_express = ""
        pre_button = ""
        dot_tf = True
    except TypeError:
        pass
    except SyntaxError:
        pass

window = Tk()
window.title("Calculator")

sq = PhotoImage(width = 1, height = 1)

screen = Label(window, text = "", font = ("Arial", 16), bg = "white", width = 19, height = 2)
screen.grid(row = 0, column = 0, columnspan = 4)

one_button = Button(window, text = "1", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("1"))
one_button.grid(row = 1, column = 0)

two_button = Button(window, text = "2", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("2"))
two_button.grid(row = 1, column = 1)

three_button = Button(window, text = "3", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("3"))
three_button.grid(row = 1, column = 2)

plus_button = Button(window, text = "+", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("+"))
plus_button.grid(row = 1, column = 3)

four_button = Button(window, text = "4", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("4"))
four_button.grid(row = 2, column = 0)

five_button = Button(window, text = "5", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("5"))
five_button.grid(row = 2, column = 1)

six_button = Button(window, text = "6", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("6"))
six_button.grid(row = 2, column = 2)

minus_button = Button(window, text = "-", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("-"))
minus_button.grid(row = 2, column = 3)

seven_button = Button(window, text = "7", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("7"))
seven_button.grid(row = 3, column = 0)

eight_button = Button(window, text = "8", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("8"))
eight_button.grid(row = 3, column = 1)

nine_button = Button(window, text = "9", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("9"))
nine_button.grid(row = 3, column = 2)

multi_button = Button(window, text = "*", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("*"))
multi_button.grid(row = 3, column = 3)

zero_button = Button(window, text = "0", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("0"))
zero_button.grid(row = 4, column = 0)

dot_button = Button(window, text = ".", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = lambda: display("."))
dot_button.grid(row = 4, column = 1)

equal_button = Button(window, text = "=", font = ("Arial", 12), image = sq, compound = "center", width = 50, height = 50, command = calculate)
equal_button.grid(row = 4, column = 2)

divide_button = Button(window, text = "/", image = sq, compound = "center", width = 50, height = 50, command = lambda: display("/"))
divide_button.grid(row = 4, column = 3)

clear_button = Button(window, text = "clear", font = ("Arial", 12), image = sq, compound = "center", width = 100, height = 50, command = clear)
clear_button.grid(row = 5, column = 1, columnspan = 2)

window.mainloop()
