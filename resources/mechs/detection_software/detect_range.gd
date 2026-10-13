extends MechDetectionSoftware

class_name DetectRange

@export var range_radius: int

func detect(position: Vector2, enemies: Array[Enemy]) -> Array[Enemy]:
	return enemies.filter(func(x: Enemy): return position.distance_squared_to(x.global_position) < pow(range_radius, 2))
