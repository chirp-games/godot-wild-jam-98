extends CharacterBody2D


@export var SPEED = 2400

func _physics_process(_delta: float) -> void:
	velocity.x = sign(position.x) * SPEED
	move_and_slide()
