extends DealDamage
class_name Explosion

var lifetime: float
var timer: float

var damaged: Array = []

func setup(size: float, damage: int):
	self.scale = Vector2.ONE * size
	self.base_damage = damage
	self.lifetime = damage / 60.
	self.timer = lifetime

func _process(delta: float) -> void:
	if timer <= 0:
		queue_free()
	var ratio: float = timer / lifetime
	self_modulate = Color(ratio, ratio, sqrt(ratio), ratio)
	timer -= delta

func calculate_damage(body: Node2D) -> int:
	if not damaged.has(body):
		damaged.append(body)
		return mini(base_damage, (100 * base_damage / body.global_position.distance_squared_to(self.global_position)))
	return 0
