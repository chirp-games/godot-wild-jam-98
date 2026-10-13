extends RigidBody2D # Yes, I know Command Center is a Node2D.

class_name DamageableEntity

@export var health: int

func damage(amount: int):
	health -= amount
	if health <= 0:
		queue_free()
