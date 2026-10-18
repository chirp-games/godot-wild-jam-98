extends RigidBody2D

class_name Bullet

## Bullets are modified from each item in the chain, from the sensor to the last gun

var target_enemy: Enemy
var damage := 1:
	get():
		return damage
	set(v):
		($Area2D as DealDamage).base_damage = v
		damage = v

func _ready() -> void:
	if not target_enemy:
		return
	var direction := global_position.direction_to(target_enemy.global_position).normalized()
	apply_central_impulse(1000 * direction)

func _on_area_2d_deal_damage(_body: Node2D) -> void:
	Vfx.create_vfx(Vfx.VFX_METAL_SPARK, self.global_position, self.linear_velocity.angle())
	queue_free()

func disintegrate() -> void:
	queue_free()
