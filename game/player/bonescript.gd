extends PhysicalBone2D

@export var limit_rotation: bool
@export var min_rotation: float
@export var max_rotation: float

func _ready() -> void:
	freeze = true
	await get_tree().physics_frame
	freeze = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if limit_rotation:
		rotation = clamp(rotation, min_rotation, max_rotation)
