extends MechDetectionSoftware

class_name DetectClosest

func detect(position: Vector2, enemies: Array[Enemy]) -> Array[Enemy]:
	if len(enemies) == 0:
		return []
	enemies.sort_custom(func(x: Enemy, y: Enemy): return position.distance_squared_to(x.global_position) < position.distance_squared_to(y.global_position))
	return [enemies[0]]
