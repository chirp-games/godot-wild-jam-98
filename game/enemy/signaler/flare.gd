extends Node2D

class_name Flare

signal decayed

var time = 0.0

func _on_decay_timer_timeout() -> void:
	decayed.emit()
	queue_free()

func fade_out():
	pass
 
func _process(delta: float) -> void:
	time += delta

	if time > .5:
		Vfx.create_vfx(Vfx.VFX_PRESSURE_RING, global_position)
		time = 0
