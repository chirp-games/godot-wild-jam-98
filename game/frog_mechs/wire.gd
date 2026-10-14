@tool

extends Line2D

class_name Wire

@export var a: WireReceptacle
@export var b: WireReceptacle
@export var hover_margin := 10
var delete_started = false


func _ready() -> void:
	clear_points()
	add_point(Vector2(0, 0))
	add_point(Vector2(0, 0))

func _process(_delta: float) -> void:
	if not a:
		return

	set_point_position(0, to_local(a.get_global_rect().get_center()))

	var end_point := get_global_mouse_position()
	if b:
		end_point = b.get_global_rect().get_center()

	set_point_position(1, to_local(end_point))

	default_color = Color(0.134, 0.39, 0.688, 1.0)

func get_other_end(side) -> WireReceptacle:
	if not a or not b:
		return null
	if a == side:
		return b
	return a
