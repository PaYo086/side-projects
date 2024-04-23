from tkinter import *
from time import sleep

def setup():
    global o_or_x, fill, end_label
    
    o_or_x = True
    fill = [9, 9, 9, 9, 9, 9, 9, 9, 9] # NW, N, NE, W, C, E, SW, S, SE
    
    if "end_label" in globals():
        end_label.destroy()
    
    nw_canvas.delete("all")
    n_canvas.delete("all")
    ne_canvas.delete("all")
    w_canvas.delete("all")
    c_canvas.delete("all")
    e_canvas.delete("all")
    sw_canvas.delete("all")
    s_canvas.delete("all")
    se_canvas.delete("all")
    
    for i in range(195):
        nw_canvas.create_line(i, 200, i+1, 200, fill="grey", width=5)
        w_canvas.create_line(i, 200, i+1, 200, fill="grey", width=5)
        nw_canvas.create_line(200, i, 200, i+1, fill="grey", width=5)
        n_canvas.create_line(200, i, 200, i+1, fill="grey", width=5)
        window.update()
        sleep(0.00001)

    for i in range(195):
        n_canvas.create_line(i, 200, i+1, 200, fill="grey", width=5)
        c_canvas.create_line(i, 200, i+1, 200, fill="grey", width=5)
        w_canvas.create_line(200, i, 200, i+1, fill="grey", width=5)
        c_canvas.create_line(200, i, 200, i+1, fill="grey", width=5)
        window.update()
        sleep(0.00001)

    for i in range(195):
        ne_canvas.create_line(i, 200, i+1, 200, fill="grey", width=5)
        e_canvas.create_line(i, 200, i+1, 200, fill="grey", width=5)
        sw_canvas.create_line(200, i, 200, i+1, fill="grey", width=5)
        s_canvas.create_line(200, i, 200, i+1, fill="grey", width=5)
        window.update()
        sleep(0.00001)

def draw(event, canvas, where):
    global o_or_x, fill
    
    if fill[where] != 9 or "end_label" in globals():
        print("end_label" in globals())
        return
    
    if o_or_x:
        canvas.create_oval(48, 48, 148, 148, fill = "", width = 5, outline = "#ff8080")
        o_or_x = False
        fill[where] = 0
        check()
    else:
        canvas.create_line(48, 48, 148, 148, fill = "#8080ff", width = 5)
        canvas.create_line(148, 48, 48, 148, fill = "#8080ff", width = 5)
        o_or_x = True
        fill[where] = 1
        check()

def check():
    global fill, end_label
    
    temp = [sum([fill[x] for x in (0, 1, 2)]),
            sum([fill[x] for x in (3, 4, 5)]),
            sum([fill[x] for x in (6, 7, 8)]),
            sum([fill[x] for x in (0, 3, 6)]),
            sum([fill[x] for x in (1, 4, 7)]),
            sum([fill[x] for x in (2, 5, 8)]),
            sum([fill[x] for x in (0, 4, 8)]),
            sum([fill[x] for x in (2, 4, 6)])]
    
    for i in temp:
        if i == 0:
            end_label = Label(frame, text="O wins!!!", font=("Arial", 34, "bold"))
            end_label.grid(row=1, column=1)
            break
        if i == 3:
            end_label = Label(frame, text="X wins!!!", font=("Arial", 34, "bold"))
            end_label.grid(row=1, column=1)
            break
    
    if 9 not in fill:
        end_label = Label(frame, text="Tie!!!", font=("Arial", 34, "bold"))
        end_label.grid(row=1, column=1)
    
window = Tk()
o_or_x = True
fill = [9, 9, 9, 9, 9, 9, 9, 9, 9] # NW, N, NE, W, C, E, SW, S, SE

frame = Canvas(window, width=600, height=600, borderwidth=0, highlightthickness=0)
frame.pack()

nw_canvas = Canvas(frame, width=200, height=200)
nw_canvas.grid(row=0, column=0)
nw_canvas.bind("<Button-1>", lambda event: draw(event, nw_canvas, 0))
n_canvas = Canvas(frame, width=200, height=200)
n_canvas.grid(row=0, column=1)
n_canvas.bind("<Button-1>", lambda event: draw(event, n_canvas, 1))
ne_canvas = Canvas(frame, width=200, height=200)
ne_canvas.grid(row=0, column=2)
ne_canvas.bind("<Button-1>", lambda event: draw(event, ne_canvas, 2))

w_canvas = Canvas(frame, width=200, height=200)
w_canvas.grid(row=1, column=0)
w_canvas.bind("<Button-1>", lambda event: draw(event, w_canvas, 3))
c_canvas = Canvas(frame, width=200, height=200)
c_canvas.grid(row=1, column=1)
c_canvas.bind("<Button-1>", lambda event: draw(event, c_canvas, 4))
e_canvas = Canvas(frame, width=200, height=200)
e_canvas.grid(row=1, column=2)
e_canvas.bind("<Button-1>", lambda event: draw(event, e_canvas, 5))

sw_canvas = Canvas(frame, width=200, height=200)
sw_canvas.grid(row=2, column=0)
sw_canvas.bind("<Button-1>", lambda event: draw(event, sw_canvas, 6))
s_canvas = Canvas(frame, width=200, height=200)
s_canvas.grid(row=2, column=1)
s_canvas.bind("<Button-1>", lambda event: draw(event, s_canvas, 7))
se_canvas = Canvas(frame, width=200, height=200)
se_canvas.grid(row=2, column=2)
se_canvas.bind("<Button-1>", lambda event: draw(event, se_canvas, 8))

Button(window, text="restart", font=("Arial", 14), command=setup).pack()

setup()

window.mainloop()
