extends CharacterBody2D

class_name Enemy

@export var health = 10

func _process(delta: float) -> void:
	($Health as Label).text = str(health)

func damage(d: int):
	health -= d
	if health <= 0:
		queue_free()
