extends Node2D

class_name Bullet

## Bullets are modified from each item in the chain, from the sensor to the last gun

var target_enemy: Enemy
var damage := 1

func _process(delta: float) -> void:
	if not target_enemy:
		return
	global_position += global_position.direction_to(target_enemy.global_position).normalized() * 10


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		(body as Enemy).damage(damage)
		queue_free()
