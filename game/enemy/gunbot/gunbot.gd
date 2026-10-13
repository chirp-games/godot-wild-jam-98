extends Enemy

@onready var AMMO = preload("res://game/enemy/ammunition/50AP/APCBC.tscn")

const BARRELS: Array[Vector2] = [Vector2(-96, -85), Vector2(-30, -84), Vector2(-91, -76), Vector2(-25, -75)]
var step = 0
var cooldown = 0

func attack():
	var ammo = AMMO.instantiate()
	ammo.position += BARRELS[step]
	step += 1
	step %= 4
	super.attack()
