extends Enemy

@onready var AMMO = preload("res://game/enemy/ammunition/artillery/155mm/155mm.tscn")

const MUZZLE: Vector2 = Vector2.ZERO
const MUZZLE_V: float = 3000

func attack():
	var dp: Vector2 = target.global_position - (global_position + MUZZLE)
	var g: float = -get_gravity().y
	dp.y *= -1
	dp.x *= 1.01
	var θ: float = atan((pow(MUZZLE_V,2) + sqrt(pow(MUZZLE_V,4) - g*(g*pow(absf(dp.x),2)+2*dp.y*pow(MUZZLE_V,2)))) / g*absf(dp.x))
	var ammo = AMMO.instantiate()
	ammo.global_position += MUZZLE
	ammo.velocity = MUZZLE_V * Vector2(cos(θ) * -signf(dp.x), sin(θ))
