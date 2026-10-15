extends Node2D


func _on_decay_timer_timeout() -> void:
	queue_free()
