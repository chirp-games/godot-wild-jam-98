extends CharacterBody2D

@onready var EXPLOSION = preload("res://game/enemy/explosion.tscn")


func _physics_process(delta: float) -> void:
	if is_on_floor():
		var explosion: Explosion = EXPLOSION.instantiate()
		explosion.setup(0.12, 50)
	velocity.y += get_gravity().y * delta
	move_and_slide()
