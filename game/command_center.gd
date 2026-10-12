extends Node2D

@onready var area2d: Node2D = %Area2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("Attacked by enemy!")
		body.queue_free()
