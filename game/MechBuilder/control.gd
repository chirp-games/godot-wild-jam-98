@tool

extends Control

@export var bg := Color(1,1,1)
@export var fg := Color(0.6,0.5,0.5)
@export var rows := 3
@export var columns := 3

func _draw():
	var w := size.x
	var h := size.y
	var cw := w/columns #cell width
	var ch := h/rows #cell height
	
	draw_rect(Rect2(Vector2.ZERO,size), bg)
	for row in range(1,rows, 2):
		var y := ch*row+(ch*0.5)
		draw_line( Vector2(0,y), Vector2(w,y), fg, ch )
	
	for column in range(1,columns, 2):
		var x := cw*column+(cw*0.5)
		draw_line( Vector2(x,0), Vector2(x,h), fg, cw )
