import os
from tkinter import *
from tkinter import filedialog, colorchooser, font
from tkinter.messagebox import *
# from tkinter.filedialog import *

def change_color():
    color = colorchooser.askcolor(title="pick a color")
    text_area.config(fg=color[1])

# def change_font(*arg):
#     text_area.config(font=(font_box.get(), font_size.get()))

def new_file():
    global filepath
    
    window.title("Untitled")
    filepath = None
    text_area.delete("1.0", END)

def open_file():
    global filepath
    
    filepath = filedialog.askopenfilename(initialdir = "D:\\OneDrive\\6111\\computer science\\python\\job\\12hr_brocode_tutorial\\", title = "Open file", filetypes = (("text files", "*.txt"), ("all files", "*.*")))
    window.title(os.path.basename(filepath))
    
    try:
        file = open(filepath, "r")
        text_area.delete("1.0", END)
        text_area.insert("1.0", file.read())
    except FileNotFoundError:
        showerror(title = "ERROR", message = "File not found")
    except Exception:
        showerror(title = "ERROR", message = "Couldn't open the file")
    else:
        file.close()

def save_file():
    global filepath
    
    if filepath is None:
        filepath = filedialog.askopenfilename(initialdir = "D:\\OneDrive\\6111\\computer science\\python\\job\\12hr_brocode_tutorial\\", title = "Save file", filetypes = (("text files", "*.txt"), ("all files", "*.*")))
        window.title(os.path.basename(filepath))
    
    try:
        file = open(filepath, "w")
        file.write(text_area.get("1.0", END))
    except FileNotFoundError:
        showerror(title = "ERROR", message = "File not found")
    except Exception:
        showerror(title = "ERROR", message = "Couldn't save the file")
    else:
        file.close()

def cut():
    text_area.event_generate("<<Cut>>")

def copy():
    text_area.event_generate("<<Copy>>")

def paste():
    text_area.event_generate("<<Paste>>")

def about():
    showinfo("About this program", "This is a program written by PoYu.")

# def quit():
#     window.destroy()

window = Tk()
# set up and window
window.title("Untitled")
filepath = None

window_width = 500
window_height = 500
screen_width = window.winfo_screenwidth()
screen_height = window.winfo_screenheight()

x = int((screen_width/2) - (window_width/2))
y = int((screen_height/2) - (window_height/2))
window.geometry("{}x{}+{}+{}".format(window_width, window_height, x, y))

font_name = StringVar(window)
font_name.set("Arial")

font_size = StringVar(window)
font_size.set("24")

# menubar
menubar = Menu(window)
window.config(menu = menubar)

filemenu = Menu(menubar, tearoff=0)
menubar.add_cascade(label="File", menu=filemenu)
filemenu.add_command(label="New", command=new_file)
filemenu.add_command(label="Open", command=open_file)
filemenu.add_command(label="Save", command=save_file)
filemenu.add_separator()
filemenu.add_command(label="Exit", command=quit)

editmenu = Menu(menubar, tearoff=0)
menubar.add_cascade(label="Edit", menu=editmenu)
editmenu.add_command(label="Cut", command=cut)
editmenu.add_command(label="Copy", command=copy)
editmenu.add_command(label="Paste", command=paste)

helpmenu = Menu(menubar, tearoff=0)
menubar.add_cascade(label="Help", menu=helpmenu)
helpmenu.add_command(label="About", command=about)

# text area
text_area = Text(window, font=(font_name.get(), font_size.get()))
scrollbar = Scrollbar(text_area)
window.grid_rowconfigure(0, weight=1)
window.grid_columnconfigure(0, weight=1)
text_area.grid(stick=N+E+S+W)
scrollbar.pack(side=RIGHT, fill=Y)
text_area.config(yscrollcommand=scrollbar.set)

# text edit
frame = Frame(window)
frame.grid()

color_button = Button(frame, text="color", command=change_color)
color_button.grid(row=0, column=0)

font_box = OptionMenu(frame, font_name, *font.families(), command=lambda font_name: text_area.config(font=(font_name, font_size.get())))
font_box.grid(row=0, column=1)

size_box = Spinbox(frame, from_=1, to=128, textvariable=font_size, command=lambda: text_area.config(font=(font_name.get(), font_size.get())))
size_box.grid(row=0, column=2)

window.mainloop()

