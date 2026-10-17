extends Node2D

class_name Flare

signal decayed

func _on_decay_timer_timeout() -> void:
	decayed.emit()
	queue_free()

func fade_out():
	$laser.play("fade_out")
	$laser2.play("fade_out")
	$laser3.play("fade_out")
	$laser4.play("fade_out")

func loop():
	$laser.play("loop")
	$laser2.play("loop")
	$laser3.play("loop")
	$laser4.play("loop")
