@tool

extends Line2D

class_name Wire

@export var a: MechPiece
@export var b: MechPiece

func _ready() -> void:
	add_point(Vector2(0, 0))
	add_point(Vector2(0, 0))

func _process(_delta: float) -> void:
	if not a:
		return

	set_point_position(0, a.get_global_rect().get_center())

	var end_point := get_global_mouse_position()
	if b:
		end_point = b.get_global_rect().get_center()

	set_point_position(1, end_point)

	if is_hovered():
		default_color = Color(0.741, 0.0, 0.0, 1.0)
	else:
		default_color = Color(0.134, 0.39, 0.688, 1.0)

func is_hovered():
	var p1 := Geometry2D.get_closest_point_to_segment(get_global_mouse_position(), points.get(0), points.get(1))
	var p2 := get_global_mouse_position()
	return (p1 - p2).abs() < Vector2(Vector2.ONE * (width / 2.))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		if is_hovered():
			queue_free()
