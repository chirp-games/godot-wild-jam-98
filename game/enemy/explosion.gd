extends Area2D

var base_damage: int
var lifetime: float
var timer: float = 0.

var damaged: Array = []

func _init(size: float, damage: int):
	self.scale = Vector2.ONE * size
	self.base_damage = damage
	self.lifetime = damage / 60
	self.timer = lifetime

func _process(delta: float) -> void:
	if timer <= 0:
		queue_free()
	var ratio: float = timer / lifetime
	self_modulate = Color(ratio, ratio, sqrt(ratio), ratio)
	timer -= delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ally") and not damaged.has(body):
		damaged.append(body)
		(body as DamageableEntity).damage(mini(base_damage, (100 * base_damage / body.global_position.distance_squared_to(self.global_position))))
