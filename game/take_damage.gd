extends Area2D

class_name TakeDamage

signal damage_taken(amount: int)
signal death

@export var max_health: int = 0
@export var healing_per_tick: int = 10
@export var damaged_by_group: StringName

var parent_resource: Resource
var damage_taken_since_last_tick := false

@onready var health = max_health

func _ready() -> void:
	area_entered.connect(_damage)

func heal_tick() -> void:
	if damage_taken_since_last_tick:
		damage_taken_since_last_tick = false
		return
	
	health += parent_resource.healing if ("healing" in parent_resource) else 0
	health = max(health, max_health)

func _damage(body: CollisionObject2D):
	print([damaged_by_group, body, body.get_groups()])
	if damaged_by_group != null:
		if not body.is_in_group(damaged_by_group):
			return
	var damage = (body as DealDamage).calculate_damage(self)
	damage_taken_since_last_tick = true
	health -= damage
	damage_taken.emit(damage)
	
	if health <= 0:
		death.emit()
		collision_layer = 0
		collision_mask = 0
