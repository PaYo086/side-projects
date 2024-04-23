from tkinter import *
from time import *
import os

# https://stackoverflow.com/questions/31836104/pyinstaller-and-onefile-how-to-include-an-image-in-the-exe-file

def resource_path(relative_path):
    try:
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")

    return os.path.join(base_path, relative_path)

def update():
    time_label.config(text = strftime("%I:%M:%S %p"))
    day_label.config(text = strftime("%A"))
    date_label.config(text = strftime("%B %d, %Y"))
    
    window.after(1000, update)

window = Tk()
window.title("clock")
icon = PhotoImage(file = "ufo.png") # resource_path("ufo.png")
window.iconphoto(True, icon)
window.geometry("320x150")
window.config(bg = "black")

time_label = Label(window, font = ("Arial", "36"), fg = "#00FF00", bg = "black")
time_label.pack()

day_label = Label(window, font = ("Arial", "24"), fg = "#00FF00", bg = "black")
day_label.pack()

date_label = Label(window, font = ("Arial", "24"), fg = "#00FF00", bg = "black")
date_label.pack()

update()

window.mainloop()

