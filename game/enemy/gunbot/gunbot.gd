extends Enemy

@onready var AMMO = preload("res://game/enemy/ammunition/50AP/APCBC.tscn")

const BARRELS: Array[Vector2] = [Vector2(-96, -85), Vector2(-30, -84), Vector2(-91, -76), Vector2(-25, -75)]
var step = 0
var cooldown = 0

func attack():
	var ammo: CharacterBody2D = AMMO.instantiate()
	ammo.position += BARRELS[step] * ($Sprite2D as Sprite2D).scale.x
	ammo.velocity = ammo.global_position.direction_to(target.global_position) * 2400
	step += 1
	step %= 4
	super.attack()
