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

	if not b:
		set_point_position(1, get_global_mouse_position())
	else:
		set_point_position(1, b.get_global_rect().get_center())
