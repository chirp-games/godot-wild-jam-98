extends DealDamage
class_name Explosion

var timer: float

var damaged: Array = []

func setup(size: float, damage: int):
	$Radius.shape.radius *= size
	self.base_damage = damage
	self.timer = 0.01

func _physics_process(delta: float) -> void:
	if timer <= 0:
		queue_free()
	timer -= delta

func calculate_damage(body: Node2D) -> int:
	if not damaged.has(body):
		damaged.append(body)
		deal_damage.emit(body)
		return mini(base_damage, (2500 * base_damage / body.global_position.distance_squared_to(self.global_position)))
	return 0
