extends Enemy

@onready var EXPLOSION = preload("res://game/enemy/explosion.tscn")

func attack():
	var explosion: Explosion = EXPLOSION.instantiate()
	explosion.setup(0.4, 50)
