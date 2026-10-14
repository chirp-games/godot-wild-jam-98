extends Area2D

class_name DealDamage

signal deal_damage(body: Node2D)

@export var base_damage: int

func calculate_damage(body: Node2D) -> int:
	deal_damage.emit(body)
	return base_damage
