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

	var make_red = false
	if delete_started:
		make_red = true
	if is_deletable() and not Input.is_action_pressed("right_click"):
		make_red = true
	if not is_placable() and not b:
		make_red = true

	if make_red:
		default_color = Color(0.741, 0.0, 0.0, 1.0)
	else:
		default_color = Color(0.134, 0.39, 0.688, 1.0)

func is_deletable():
	return is_hovered()

func is_placable():
	if b:
		return true
	for piece: WireReceptacle in get_tree().get_nodes_in_group("wire_receptacle"):
		if piece.get_global_rect().has_point(get_global_mouse_position()) and piece.type != a.type:
			return true
	return false

func is_hovered():
	var p1 := Geometry2D.get_closest_point_to_segment(get_global_mouse_position(), get_point_position(0), get_point_position(1))
	var p2 := get_global_mouse_position()
	return (p1 - p2).abs() < Vector2(Vector2.ONE * hover_margin)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		if is_deletable():
			delete_started = true
	if event.is_action_released("right_click"):
		if delete_started:
			delete_started = false
			queue_free()
