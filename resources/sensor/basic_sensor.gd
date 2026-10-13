extends Node

@export var range_radius: int

## Given a list of enemy units in range, return the target
func sense(enemies: Array[Enemy]) -> Enemy:
	return enemies[0]
