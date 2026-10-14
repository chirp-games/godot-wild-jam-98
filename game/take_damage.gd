extends Area2D

class_name TakeDamage

signal damage_taken(amount: int)

@export var health: int
@export var damaged_by_group: StringName

func _ready() -> void:
	area_entered.connect(_damage)

func _damage(body: CollisionObject2D):
	if damaged_by_group != null:
		if not body.is_in_group(damaged_by_group):
			return
	var damage = (body as DealDamage).calculate_damage(self)
	health -= damage
	damage_taken.emit(damage)
	if health < 0:
		get_parent().queue_free()
