extends RigidBody2D

func _ready() -> void:
	freeze = true
	await get_tree().physics_frame
	freeze = false
