extends Camera2D

var camera_speed = 1000

func _process(delta: float) -> void:
	var mouse_position_on_canvas = get_viewport().get_mouse_position()

	if mouse_position_on_canvas.x < 500:
		var v: float = mouse_position_on_canvas.x - 500
		position.x += lerp(0, camera_speed, v / 500) * delta
	
	if mouse_position_on_canvas.x > 1920 - 500:
		var v: float = mouse_position_on_canvas.x - 1920 + 500
		position.x += lerp(0, camera_speed, v /500) * delta
