extends CharacterBody2D


@export var SPEED = 5000
@export var damage = 1


func _physics_process(delta: float) -> void:
	velocity.x = sign(position.x) * SPEED
	move_and_slide()
