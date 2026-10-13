@tool
extends PointLight2D

@export var min_energy: float = 0.5
@export var max_energy: float = 1.5
@export var flicker_speed: float = 0.1

var timer: float = 0.0

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		timer = randf_range(0.05, flicker_speed)
	energy = lerp(energy,randf_range(min_energy, max_energy),timer)
