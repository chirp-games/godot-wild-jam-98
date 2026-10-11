extends PhysicalBone2D

@export var limit_rotation: bool
@export var min_rotation: float
@export var max_rotation: float

func _ready() -> void:
	freeze = true
	await get_tree().physics_frame
	freeze = false
