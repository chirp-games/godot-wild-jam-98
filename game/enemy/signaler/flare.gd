extends Node2D

class_name Flare

signal decayed

func _on_decay_timer_timeout() -> void:
	decayed.emit()
	queue_free()
