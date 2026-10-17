extends Enemy

@onready var AMMO = preload("res://game/enemy/ammunition/artillery/155mm/155mm.tscn")

const MUZZLE: Vector2 = Vector2(0, -100)
const MUZZLE_V: float = 2700

var whim = [-1, 1].pick_random()

func attack():
	var dp: Vector2 = target.global_position - (global_position + MUZZLE)
	var p: Vector2 = Vector2(abs(dp.x * 1.025), dp.y)
	var g: float = get_gravity().y
	var a: float = 0.5*g*pow(p.x/MUZZLE_V, 2)
	var b: float = p.x
	var c: float = a - p.y
	var tan: float = (-b + whim * sqrt(pow(b, 2) - 4*a*c)) / (2*a)
	#var tan: float = (pow(MUZZLE_V,2) + whim * sqrt(pow(MUZZLE_V,4) - g*(g*pow(p.x,2)+2*p.y*pow(MUZZLE_V,2)))) / (g*p.x)
	var direction = Vector2(tan * -sign(dp.x), -1).normalized()
	var ammo = AMMO.instantiate()
	ammo.global_position = global_position + MUZZLE
	ammo.velocity = MUZZLE_V * direction
	get_parent().add_child(ammo)
	attack_cooldown += attack_interval
