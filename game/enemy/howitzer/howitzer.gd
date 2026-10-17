extends Enemy

@onready var AMMO = preload("res://game/enemy/ammunition/artillery/155mm/155mm.tscn")

const MUZZLE: Vector2 = Vector2(0, -600)
const MUZZLE_V: float = 1800

func attack():
	var dp: Vector2 = target.global_position - (global_position + MUZZLE)
	var p: Vector2 = Vector2(abs(dp.x * 1.1), -dp.y)
	var g: float = -get_gravity().y
	var θ: float = atan((pow(MUZZLE_V,2) - sqrt(pow(MUZZLE_V,4) - g*(g*pow(p.x,2)+2*p.y*pow(MUZZLE_V,2)))) / g*p.x)
	var ammo = AMMO.instantiate()
	print([θ/PI, dp])
	ammo.global_position = global_position + MUZZLE
	ammo.velocity = MUZZLE_V * Vector2(cos(θ) * -signf(dp.x), -sin(θ))
	get_parent().add_child(ammo)
	attack_cooldown += attack_interval
