extends Enemy

@onready var LASER = preload("res://game/enemy/laser.tscn")

var L0: Vector2 = Vector2(-46, 31)

func attack():
	var laser: Laser = LASER.instantiate()
	laser.setup(1, [Vector2.ZERO, target.global_position - L0])
	laser.position += L0
	
