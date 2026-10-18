extends Camera2D

var camera_speed = 1000

func _process(delta: float) -> void:
	var mouse_position_on_canvas = get_viewport().get_mouse_position()
	
	if mouse_position_on_canvas.y > 72:
		var u = clamp((mouse_position_on_canvas.y - 72) / 144, 0, 1.5)
		if mouse_position_on_canvas.x < 600:
			var v: float = mouse_position_on_canvas.x - 600
			position.x += lerp(0, camera_speed, v / 480) * delta * u
		
		if mouse_position_on_canvas.x > 1920 - 600:
			var v: float = mouse_position_on_canvas.x - 1920 + 600
			position.x += lerp(0, camera_speed, v /480) * delta * u
	
