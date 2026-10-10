extends Node2D

class_name Bullet

## Bullets are modified from each item in the chain, from the sensor to the last gun

var target_enemy: Enemy


func _process(delta: float) -> void:
	if not target_enemy:
		return
	position += position.direction_to(target_enemy.position).normalized() * 10
