extends Control

@onready var flare_marker: InstancePlaceholder = %FlareMarker


var markers: Array[Node2D] = []

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	
	var flares = get_tree().get_nodes_in_group("flare")

	while len(flares) > len(markers):
		markers.push_back(flare_marker.create_instance())
	
	while len(markers) > len(flares):
		var marker: Node2D = markers.pop_back()
		marker.queue_free()

	for i in range(len(flares)):
		var f: Node2D = flares[i]
		position_marker(markers[i], f)


func get_visible_rect() -> Rect2:
	var pos := get_viewport().get_camera_2d().get_screen_center_position()
	var size_ := get_viewport_rect().size
	return Rect2(pos - size_ * .5, size_)

## Returns the point where a ray from the center of `rect`, pointing in
## direction `angle` (radians), exits the rectangle.
func get_rect_edge_point(rect: Rect2, angle: float) -> Vector2:
	var dir := Vector2.from_angle(angle)
	var half := rect.abs().size * 0.5

	# Distance along the ray to reach the vertical / horizontal edges
	var tx := half.x / absf(dir.x) if not is_zero_approx(dir.x) else INF
	var ty := half.y / absf(dir.y) if not is_zero_approx(dir.y) else INF

	# Whichever edge is hit first is the exit point
	var t := minf(tx, ty)
	return rect.get_center() + dir * t

func position_marker(marker: Node2D, flare: Node2D):
	var camera_bounds := get_visible_rect()

	if camera_bounds.has_point(flare.global_position):
		marker.hide()
		return
	
	marker.show()

	var angle := camera_bounds.get_center().angle_to_point(flare.global_position)
	marker.global_position = get_rect_edge_point(camera_bounds.grow(-50), angle)
	marker.rotation = angle
