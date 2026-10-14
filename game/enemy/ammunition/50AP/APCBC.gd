extends CharacterBody2D


@export var SPEED = 5000

func _physics_process(_delta: float) -> void:
	velocity.x = sign(position.x) * SPEED
	move_and_slide()
